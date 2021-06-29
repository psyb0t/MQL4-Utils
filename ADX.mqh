//+------------------------------------------------------------------+
class ADX {
    int period;
    double minVal; // disabled when == 0
    double maxVal; // disabled when == 0
    ENUM_APPLIED_PRICE appliedPrice;

  public:
    ADX(int per, ENUM_APPLIED_PRICE applPrice);
    ADX(int per, ENUM_APPLIED_PRICE applPrice, double min, double max);

    double GetValue();
    bool IsInRange();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ADX::ADX(int per, ENUM_APPLIED_PRICE applPrice) {
    period = per;
    appliedPrice = applPrice;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ADX::ADX(int per, ENUM_APPLIED_PRICE applPrice, double min, double max) {
    period = per;
    appliedPrice = applPrice;
    minVal = min;
    maxVal = max;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ADX::GetValue() {
    return(iADX(_Symbol, _Period, period, appliedPrice, MODE_MAIN, 0));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ADX::IsInRange() {
    double val = GetValue();
    if(minVal > 0 && !(val > minVal)) {
        return(false);
    }
    if(maxVal > 0 && !(val < maxVal)) {
        return(false);
    }
    return(true);
}
//+------------------------------------------------------------------+
