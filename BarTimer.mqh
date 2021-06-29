//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime GetCurrentBarTime() {
    datetime currTime[1];
    if(CopyTime(_Symbol, _Period, 0, 1, currTime) == 0) {
        Alert("Error in copying historical times data, error =", GetLastError());
        ResetLastError();
        return(NULL);
    }
    return currTime[0];
}

class BarTimer {
  public:
    datetime barTime;

    BarTimer();
    bool IsNewBarTime();
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BarTimer::BarTimer() {
    barTime = GetCurrentBarTime();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BarTimer::IsNewBarTime() {
    datetime newBarTime = GetCurrentBarTime();
    if(newBarTime == NULL) {
        return(false);
    }
    if(barTime == newBarTime) {
        return(false);
    }
    barTime = newBarTime;
    return(true);
}
//+------------------------------------------------------------------+
