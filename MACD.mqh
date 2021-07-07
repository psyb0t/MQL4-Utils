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

    double GetValueMain(int barIndex);
    double GetValueSignal(int barIndex);
    MACDDirection GetDirection(int barIndex);
    MACDDirection GetDirectionForNumBars(int numBars);
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
double MACD::GetValueMain(int barIndex) {
    return NormalizeDouble(iMACD(
                               _Symbol, _Period, fastEMAPeriod, slowEMAPeriod,
                               signalPeriod, appliedPrice, MODE_MAIN, barIndex
                           ), Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD::GetValueSignal(int barIndex) {
    return NormalizeDouble(iMACD(
                               _Symbol, _Period, fastEMAPeriod, slowEMAPeriod,
                               signalPeriod, appliedPrice, MODE_SIGNAL, barIndex
                           ), Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MACDDirection MACD::GetDirection(int barIndex) {
    if(GetValueMain(barIndex) > 0) {
        return(MACDBuying);
    }
    if(GetValueMain(barIndex) < 0) {
        return(MACDSelling);
    }
    return(MACDNeutral);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MACDDirection MACD::GetDirectionForNumBars(int numBars) {
    bool isSelling = true;
    bool isBuying = true;
    for(int i = 0; i < numBars; i++) {
        MACDDirection barMACDDirection = GetDirection(i);
        switch(barMACDDirection) {
        case MACDBuying: {
            isSelling = false;
            break;
        }
        case MACDSelling: {
            isBuying = false;
            break;
        }
        }
    }
    if((!isSelling && !isBuying) || (isSelling && isBuying)) {
        return(MACDNeutral);
    }
    if(isSelling) {
        return(MACDSelling);
    }
    if(isBuying) {
        return(MACDBuying);
    }
    return(MACDNeutral);
}
//+------------------------------------------------------------------+
