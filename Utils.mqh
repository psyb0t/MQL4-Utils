//+------------------------------------------------------------------+
double GetPipValue() {
    if(Digits == 3) {
        return(0.01);
    }
    if(Digits >= 4 ) {
        return(0.0001);
    }
    return(Point);
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
