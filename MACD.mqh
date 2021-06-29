//+------------------------------------------------------------------+
enum MACDDirection {
    MACDNeutral = 0,
    MACDBuying = 1,
    MACDSelling = 2
};

class MACD {
    int fastEMAPeriod;
    int slowEMAPeriod;
    int signalPeriod;
    int appliedPrice;

  public:
    MACD(int fastEMAPer, int slowEMAPer, int signalPer, int price);

    double GetValueMain();
    double GetValueSignal();
    MACDDirection GetDirection();
    MACDDirection GetDirectionComposed();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MACD::MACD(int fastEMAPer, int slowEMAPer, int signalPer, int price) {
    fastEMAPeriod = fastEMAPer;
    slowEMAPeriod = slowEMAPer;
    signalPeriod = signalPer;
    appliedPrice = price;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD::GetValueMain() {
    return NormalizeDouble(iMACD(
                               _Symbol, _Period, fastEMAPeriod, slowEMAPeriod,
                               signalPeriod, appliedPrice, MODE_MAIN, 0
                           ), Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD::GetValueSignal() {
    return NormalizeDouble(iMACD(
                               _Symbol, _Period, fastEMAPeriod, slowEMAPeriod,
                               signalPeriod, appliedPrice, MODE_SIGNAL, 0
                           ), Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MACDDirection MACD::GetDirection() {
    if(GetValueMain() > 0) {
        return(MACDBuying);
    }
    if(GetValueMain() < 0) {
        return(MACDSelling);
    }
    return(MACDNeutral);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MACDDirection MACD::GetDirectionComposed() {
    if(GetValueMain() > 0 && GetValueSignal() > 0) {
        return(MACDBuying);
    }
    if(GetValueMain() < 0 && GetValueSignal() < 0) {
        return(MACDSelling);
    }
    return(MACDNeutral);
}
//+------------------------------------------------------------------+
