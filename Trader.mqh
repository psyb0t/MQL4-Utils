//+------------------------------------------------------------------+
#include <MyUtils/Trade.mqh>
#include <MyUtils/Array.mqh>
#include <MyUtils/Error.mqh>

struct TradeStatus {
    Error error;
    Trade trade;
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
    Trade trade(t, cmnt, vol, sl, tp, magicNumber);
    TradeStatus tradeStatus;
    Error error = trade.Send();
    tradeStatus.error = error;
    if(IsError(tradeStatus.error)) {
        return(tradeStatus);
    }
    tradeStatus.trade = trade;
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
