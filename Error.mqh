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
    if(lastErrCode != ERR_NO_ERROR) {
        Alert(StringFormat("ERROR CODE %d - %s", error.code, error.text));
    }
    ResetLastError();
    return(error);
}
//+------------------------------------------------------------------+
