//+------------------------------------------------------------------+
enum PricePositionAgainstMA {
    PricePositionOnMA = 0,
    PricePositionBelowMA = 1,
    PricePositionAboveMA = 2
};

class MovingAverage {
    int period;
    ENUM_MA_METHOD method;
    ENUM_APPLIED_PRICE appliedPrice;

  public:
    MovingAverage(int p, ENUM_MA_METHOD m, ENUM_APPLIED_PRICE ap);

    PricePositionAgainstMA GetPricePosition(double p);
    double GetValue();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::MovingAverage(int p, ENUM_MA_METHOD m, ENUM_APPLIED_PRICE ap) {
    period = p;
    method = m;
    appliedPrice = ap;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PricePositionAgainstMA MovingAverage::GetPricePosition(double price) {
    double val = GetValue();
    if(price > val) {
        return(PricePositionAboveMA);
    }
    if(price < val) {
        return(PricePositionBelowMA);
    }
    return(PricePositionOnMA);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MovingAverage::GetValue() {
    return NormalizeDouble(iMA(_Symbol, _Period, period, 0, method, appliedPrice, 0), Digits);
}
//+------------------------------------------------------------------+
