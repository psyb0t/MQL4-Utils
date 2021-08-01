//+------------------------------------------------------------------+
#include <MyUtils/Error.mqh>
#include <MyUtils/Utils.mqh>

enum TradeType {
    _TradeTypeNotSet = 0,
    TradeTypeBuy = 1,
    TradeTypeSell = 2
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeType OpTypeToTradeType(int opType) {
    switch(opType) {
    case OP_BUY:
        return TradeTypeBuy;
    case OP_SELL:
        return TradeTypeSell;
    }
    return(NULL);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeTypeToSendOrderPrice(TradeType tradeType) {
    switch(tradeType) {
    case TradeTypeBuy: {
        return Ask;
    }
    case TradeTypeSell: {
        return Bid;
    }
    }
    return 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeTypeToCloseOrderPrice(TradeType tradeType) {
    switch(tradeType) {
    case TradeTypeBuy: {
        return Bid;
    }
    case TradeTypeSell: {
        return Ask;
    }
    }
    return 0;
}

class Trade {
  public:
    bool isSent;
    TradeType type;
    string comment;
    double volume;
    double stopLoss;
    double takeProfit;
    int magicNumber;
    int ticketNumber;

    Trade();
    Trade(const Trade &trade);
    Trade(TradeType t, string cmnt, double vol, double sl, double tp, int mn);

    bool IsClosed();
    bool IsInProfit();
    bool IsStopLossAcceptable(double sl);
    double GetProfitAsPipValue();
    double GetCommission();
    double GetOpenPrice();
    Error Close();
    Error CloseVolume(double vol);
    Error UpdateSL(double sl);
    Error UpdateTP(double tp);
    Error Send();

  private:
    void init();
    Error selectOrder();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Trade::init() {
    isSent = false;
    ticketNumber = 0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade() {
    init();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade(const Trade &trade) {
    isSent = trade.isSent;
    type = trade.type;
    comment = trade.comment;
    volume = trade.volume;
    stopLoss = trade.stopLoss;
    takeProfit = trade.takeProfit;
    magicNumber = trade.magicNumber;
    ticketNumber = trade.ticketNumber;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade(TradeType t, string cmnt, double vol, double sl, double tp, int mn) {
    init();
    type = t;
    comment = cmnt;
    volume = vol;
    stopLoss = sl;
    takeProfit = tp;
    magicNumber = mn;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::selectOrder() {
    if(ticketNumber == 0) {
        return(GetErrorByCode(ERR_INVALID_TICKET));
    }
    OrderSelect(ticketNumber, SELECT_BY_TICKET);
    return GetError();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trade::IsClosed() {
    Error error = selectOrder();
    if(IsError(error)) {
        Print(StringFormat("Trade::IsClosed ERR: %d - %s", error.code, error.text));
        return(true);
    }
    if(OrderCloseTime() != 0) {
        return(true);
    }
    return(false);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trade::IsInProfit() {
    Error error = selectOrder();
    if(IsError(error)) {
        Print(StringFormat("Trade::IsInProfit ERR: %d - %s", error.code, error.text));
        return(true);
    }
    double closeOrderPrice = TradeTypeToCloseOrderPrice(type);
    switch(type) {
    case TradeTypeBuy:
        return closeOrderPrice > OrderOpenPrice();
    case TradeTypeSell:
        return OrderOpenPrice() > closeOrderPrice;
    default:
        return false;
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trade::IsStopLossAcceptable(double sl) {
    double minSLVal = MarketInfo(_Symbol, MODE_STOPLEVEL) * Point;
    double priceDiff = TradeTypeToSendOrderPrice(type) - sl;
    if(priceDiff < 0) {
        priceDiff *= -1;
    }
    if(priceDiff < minSLVal) {
        return(false);
    }
    return(true);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Trade::GetProfitAsPipValue() {
    Error error = selectOrder();
    if(IsError(error)) {
        Print(StringFormat("Trade::GetProfitAsPipValue ERR: %d - %s", error.code, error.text));
        return(true);
    }
    switch(type) {
    case TradeTypeBuy:
        return Ask - OrderOpenPrice();
    case TradeTypeSell:
        return OrderOpenPrice() - Bid;
    default:
        return 0;
    }
}

//+------------------------------------------------------------------+
//| returns -1 if error
//+------------------------------------------------------------------+
double Trade::GetCommission() {
    Error error = selectOrder();
    if(IsError(error)) {
        Print(StringFormat("Trade::GetCommission (ticket: %d) ERR: %d - %s", ticketNumber, error.code, error.text));
        return(-1);
    }
    return OrderCommission();
}

//+------------------------------------------------------------------+
//| returns -1 if error
//+------------------------------------------------------------------+
double Trade::GetOpenPrice() {
    Error error = selectOrder();
    if(IsError(error)) {
        Print(StringFormat("Trade::GetOpenPrice (ticket: %d) ERR: %d - %s", ticketNumber, error.code, error.text));
        return(-1);
    }
    return OrderOpenPrice();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::Send() {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(isSent) {
        error.code = ERR_TRADE_ERROR;
        error.text = "Already sent";
        return(error);
    }
    if(!IsStopLossAcceptable(stopLoss)) {
        error.code = ERR_INVALID_STOPS;
        error.text = "SL is of lower value than accepted";
        return(error);
    }
    int opType;
    color arrowColor;
    switch(type) {
    case TradeTypeBuy: {
        opType = OP_BUY;
        arrowColor = clrGreen;
        break;
    }
    case TradeTypeSell: {
        opType = OP_SELL;
        arrowColor = clrRed;
        break;
    }
    default: {
        return(GetErrorByCode(ERR_INVALID_TRADE_PARAMETERS));
    }
    }
    int ticketNum = OrderSend(
                        _Symbol, opType, volume, TradeTypeToSendOrderPrice(type),
                        (int) MarketInfo(_Symbol, MODE_SPREAD),
                        stopLoss, takeProfit, comment,
                        magicNumber, 0, arrowColor
                    );
    error = GetError();
    if(IsError(error)) {
        return(error);
    }
    ticketNumber = ticketNum;
    isSent = true;
    return(error);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::Close() {
    if(IsClosed()) {
        Error error = {};
        error.code = ERR_TRADE_ERROR;
        error.text = "Already closed";
        return(error);
    }
    OrderClose(ticketNumber, volume, TradeTypeToCloseOrderPrice(type), (int) MarketInfo(_Symbol, MODE_SPREAD));
    return(GetError());
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::CloseVolume(double vol) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(vol > volume) {
        error.code = ERR_INVALID_TRADE_VOLUME;
        error.text = "Provided volume > 100% of trade volume";
        return(error);
    }
    if(vol == volume) {
        return Close();
    }
    if(IsClosed()) {
        error.code = ERR_TRADE_ERROR;
        error.text = "Already closed entire volume";
        return(error);
    }
    error = selectOrder();
    if(IsError(error)) {
        return(error);
    }
    datetime orderOpenTime = OrderOpenTime();
    double orderOpenPrice = OrderOpenPrice();
    OrderClose(ticketNumber, vol, TradeTypeToCloseOrderPrice(type), (int) MarketInfo(_Symbol, MODE_SPREAD));
    error = GetError();
    if(IsError(error)) {
        return(error);
    }
    // try to update order ticket to next order created after close
    bool gotNewTicketNumber = false;
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        error = GetError();
        if(IsError(error)) {
            return(error);
        }
        if(OrderMagicNumber() == magicNumber && OrderOpenPrice() == orderOpenPrice && OrderOpenTime() == orderOpenTime) {
            ticketNumber = OrderTicket();
            gotNewTicketNumber = true;
            break;
        }
    }
    if(!gotNewTicketNumber) {
        error.code = ERR_RESOURCE_NOT_FOUND;
        error.text = "New ticket number not found";
    }
    return(error);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::UpdateSL(double sl) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(IsClosed()) {
        error.code = ERR_TRADE_ERROR;
        error.text = "Trade is closed";
        return(error);
    }
    if(!IsStopLossAcceptable(sl)) {
        error.code = ERR_INVALID_STOPS;
        error.text = "SL is of lower value than accepted";
        return(error);
    }
    error = selectOrder();
    if(IsError(error)) {
        return(error);
    }
    sl = NormalizeDouble(sl, Digits);
    OrderModify(ticketNumber, OrderOpenPrice(), sl, OrderTakeProfit(), 0);
    error = GetError();
    if(IsError(error) && error.code != ERR_NO_RESULT) {
        return(error);
    }
    error = GetErrorByCode(ERR_NO_ERROR);
    stopLoss = sl;
    return(error);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error Trade::UpdateTP(double tp) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(IsClosed()) {
        error.code = ERR_TRADE_ERROR;
        error.text = "Trade is closed";
        return(error);
    }
    error = selectOrder();
    if(IsError(error)) {
        return(error);
    }
    tp = NormalizeDouble(tp, Digits);
    OrderModify(ticketNumber, OrderOpenPrice(), OrderStopLoss(), tp, 0);
    error = GetError();
    if(IsError(error) && error.code != ERR_NO_RESULT) {
        return(error);
    }
    error = GetErrorByCode(ERR_NO_ERROR);
    takeProfit = tp;
    return(error);
}
//+------------------------------------------------------------------+
