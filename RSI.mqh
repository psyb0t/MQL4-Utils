//+------------------------------------------------------------------+
#include <MyUtils/Trade.mqh>

class RSI {
    ENUM_TIMEFRAMES timeframe;
    int period;
    ENUM_APPLIED_PRICE appliedPrice;
    double minValForSell; // disabled when == 0
    double maxValForSell; // disabled when == 0
    double minValForBuy; // disabled when == 0
    double maxValForBuy; // disabled when == 0

  public:
    RSI(ENUM_TIMEFRAMES tf, int per, ENUM_APPLIED_PRICE applPrice);
    RSI(ENUM_TIMEFRAMES tf, int per, ENUM_APPLIED_PRICE applPrice, double minValSell, double maxValSell, double minValBuy, double maxValBuy);

    double GetValue();
    bool IsOkayForTradeType(TradeType tradeType);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI(ENUM_TIMEFRAMES tf, int per, ENUM_APPLIED_PRICE applPrice) {
    timeframe = tf;
    period = per;
    appliedPrice = applPrice;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RSI::RSI(ENUM_TIMEFRAMES tf, int per, ENUM_APPLIED_PRICE applPrice, double minValSell, double maxValSell, double minValBuy, double maxValBuy) {
    timeframe = tf;
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
    return(iRSI(_Symbol, timeframe, period, PRICE_CLOSE, 0));
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
