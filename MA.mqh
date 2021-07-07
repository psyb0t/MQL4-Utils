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
    MovingAverage(int per, ENUM_MA_METHOD meth, ENUM_APPLIED_PRICE applPrice);

    double GetValue(int barIndex);
    PricePositionAgainstMA GetPricePosition(double price, int barIndex);
    PricePositionAgainstMA GetAskPricePosition();
    PricePositionAgainstMA GetBidPricePosition();
    PricePositionAgainstMA GetPricePositionForNumBars(int numBars);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MovingAverage::MovingAverage(int per, ENUM_MA_METHOD meth, ENUM_APPLIED_PRICE applPrice) {
    period = per;
    method = meth;
    appliedPrice = applPrice;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MovingAverage::GetValue(int barIndex) {
    return NormalizeDouble(iMA(_Symbol, _Period, period, 0, method, appliedPrice, barIndex), Digits);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PricePositionAgainstMA MovingAverage::GetPricePosition(double price, int barIndex) {
    double val = GetValue(barIndex);
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
PricePositionAgainstMA MovingAverage::GetAskPricePosition() {
    return(GetPricePosition(Ask, 0));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PricePositionAgainstMA MovingAverage::GetBidPricePosition() {
    return(GetPricePosition(Bid, 0));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PricePositionAgainstMA MovingAverage::GetPricePositionForNumBars(int numBars) {
    bool isBelow = true;
    bool isAbove = true;
    for(int i = 0; i < numBars; i++) {
        double price;
        switch(appliedPrice) {
        case PRICE_CLOSE:
            price = Close[i];
            break;
        case PRICE_OPEN:
            price = Open[i];
            break;
        case PRICE_HIGH:
            price = High[i];
            break;
        case PRICE_LOW:
            price = Low[i];
            break;
        default: {
            Alert("Unsupported applied price.");
            return NULL;
        }
        }
        PricePositionAgainstMA barPricePosition = GetPricePosition(price, i);
        switch(barPricePosition) {
        case PricePositionAboveMA: {
            isBelow = false;
            break;
        }
        case PricePositionBelowMA: {
            isAbove = false;
            break;
        }
        }
    }
    if((!isBelow && !isAbove) || (isBelow && isAbove)) {
        return(PricePositionOnMA);
    }
    if(isBelow) {
        return(PricePositionBelowMA);
    }
    if(isAbove) {
        return(PricePositionAboveMA);
    }
    return(PricePositionOnMA);
}
//+------------------------------------------------------------------+
