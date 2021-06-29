//+------------------------------------------------------------------+
#include <MyUtils/Trade.mqh>
#include <MyUtils/Array.mqh>
#include <MyUtils/Error.mqh>

struct TradeStatus {
    Error error;
    int ticketNumber;
};

class Trader {
    int magicNumber;
    Trade tradeHistory[1000];

  public:
    Trader(int magicNum);
    TradeStatus DoTrade(TradeType t, string cmnt, double vol, double sl, double tp);
    void GetTradesFromHistory(Trade &targetArr[]);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trader::Trader(int magicNum) {
    magicNumber = magicNum;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeStatus Trader::DoTrade(TradeType t, string cmnt, double vol, double sl, double tp) {
    Trade trade(t, cmnt, vol, sl, tp);
    int opType;
    color arrowColor;
    double orderPrice;
    double minStopLevel = MarketInfo(_Symbol, MODE_STOPLEVEL);
    TradeStatus tradeStatus = {};
    if(t == TradeTypeBuy) {
        opType = OP_BUY;
        orderPrice = Ask;
        arrowColor = clrGreen;
    } else if(t == TradeTypeSell) {
        opType = OP_SELL;
        orderPrice = Bid;
        arrowColor = clrRed;
    } else {
        Alert("Invalid TradeType");
        tradeStatus.error.code = ERR_INVALID_TRADE_PARAMETERS;
        tradeStatus.error.text = ErrorDescription(tradeStatus.error.code);
        return(tradeStatus);
    }
    int ticketNumber = OrderSend(
                           _Symbol, opType, trade.volume, orderPrice,
                           (int) MarketInfo(_Symbol, MODE_SPREAD),
                           trade.stopLoss, trade.takeProfit, trade.comment,
                           magicNumber, 0, arrowColor
                       );
    Error error = GetError();
    tradeStatus.error = error;
    tradeStatus.ticketNumber = ticketNumber;
    if(tradeStatus.error.code != ERR_NO_ERROR) {
        return(tradeStatus);
    }
    trade.ticketNumber = ticketNumber;
    AddToBeginningOfArray(trade, tradeHistory);
    return(tradeStatus);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Trader::GetTradesFromHistory(Trade &targetArr[]) {
    int tradeHistorySize = ArraySize(tradeHistory);
    ArrayResize(targetArr, tradeHistorySize);
    for(int i = 0; i < tradeHistorySize; i++) {
        targetArr[i] = tradeHistory[i];
    }
}
//+------------------------------------------------------------------+
