//+------------------------------------------------------------------+
#include <MyUtils/Trade.mqh>

class RSI {
    int period;
    ENUM_APPLIED_PRICE appliedPrice;
    double minValForSell; // disabled when == 0
    double maxValForSell; // disabled when == 0
    double minValForBuy; // disabled when == 0
    double maxValForBuy; // disabled when == 0

  public:
    RSI(int per, ENUM_APPLIED_PRICE applPrice);
    RSI(int per, ENUM_APPLIED_PRICE applPrice, double minValSell, double maxValSell, double minValBuy, double maxValBuy);

    double GetValue();
    bool IsOkayForTradeType(TradeType tradeType);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI(int per, ENUM_APPLIED_PRICE applPrice) {
    period = per;
    appliedPrice = applPrice;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI(int per, ENUM_APPLIED_PRICE applPrice, double minValSell, double maxValSell, double minValBuy, double maxValBuy) {
    period = per;
    appliedPrice = applPrice;
    minValForSell = minValSell;
    maxValForSell = maxValSell;
    minValForBuy = minValBuy;
    maxValForBuy = maxValBuy;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RSI::GetValue() {
    return(iRSI(_Symbol, _Period, period, PRICE_CLOSE, 0));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RSI::IsOkayForTradeType(TradeType tradeType) {
    double val = GetValue();
    double minVal = 0;
    double maxVal = 0;
    switch(tradeType) {
    case TradeTypeSell: {
        minVal = minValForSell;
        maxVal = maxValForSell;
        break;
    }
    case TradeTypeBuy: {
        minVal = minValForBuy;
        maxVal = maxValForBuy;
        break;
    }
    }
    if(minVal > 0 && !(val > minVal)) {
        return(false);
    }
    if(maxVal > 0 && !(val < maxVal)) {
        return(false);
    }
    return(true);
}
//+------------------------------------------------------------------+
