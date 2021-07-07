//+------------------------------------------------------------------+
double GetPipValue() {
    double val = 1;
    for(int i = 0; i < Digits; i++) {
        val /= 10;
    }
    // check if broker is counting by pipettes
    if((int)MarketInfo("EURUSD", MODE_DIGITS) == 5) {
        // then pip value is *10
        val *= 10;
    }
    return(val);
}
//+------------------------------------------------------------------+
