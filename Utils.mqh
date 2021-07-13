//+------------------------------------------------------------------+
double GetPipValue() {
    double val = MathPow(10, -(Digits));
    // check if broker is counting by pipettes
    if((int)MarketInfo(_Symbol, MODE_DIGITS) == 5) {
        // then pip value is *10
        val *= 10;
    }
    return(val);
}

//+------------------------------------------------------------------+
double PipsToValue(int pips) {
    return pips * GetPipValue();
}

//+------------------------------------------------------------------+
double GetSpreadValue() {
    return MarketInfo(_Symbol, MODE_SPREAD) * Point;
}
//+------------------------------------------------------------------+
