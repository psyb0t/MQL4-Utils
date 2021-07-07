//+------------------------------------------------------------------+
#include <stdlib.mqh>

struct Error {
    int code;
    string text;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error GetError() {
    Error error = {};
    int lastErrCode = GetLastError();
    error.code = lastErrCode;
    error.text = ErrorDescription(lastErrCode);
    ResetLastError();
    return(error);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Error GetErrorByCode(int c) {
    Error error = {};
    error.code = c;
    error.text = ErrorDescription(c);
    return(error);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsError(Error &error) {
    if(error.code != ERR_NO_ERROR) {
        return(true);
    }
    return(false);
}
//+------------------------------------------------------------------+
