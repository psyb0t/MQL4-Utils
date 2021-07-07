//+------------------------------------------------------------------+
#include <MyUtils/Error.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime GetCurrentBarTime() {
    datetime currTime[1];
    CopyTime(_Symbol, _Period, 0, 1, currTime);
    Error error = GetError();
    if(IsError(error)) {
        Print(StringFormat("GetCurrentBarTime ERR: %d - %s", error.code, error.text));
        return(NULL);
    }
    return currTime[0];
}

class BarTimer {
  public:
    BarTimer();

    bool IsNewBarTime();

  private:
    datetime barTime;
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
    if(newBarTime == NULL || barTime == newBarTime) {
        return(false);
    }
    barTime = newBarTime;
    return(true);
}
//+------------------------------------------------------------------+
