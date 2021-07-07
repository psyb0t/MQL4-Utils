//+------------------------------------------------------------------+
#include <MyUtils/Error.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteTextOnPriceVertically(string text, double price) {
    _WriteTextOnPriceWithAngle(90, text, price);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteTextOnPriceHorizontally(string text, double price) {
    _WriteTextOnPriceWithAngle(0, text, price);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _WriteTextOnPriceWithAngle(double angle, string text, double price) {
    string objName = StringFormat("%d-%s", (int) TimeCurrent(), text);
    ObjectCreate(objName, OBJ_TEXT, 0, TimeCurrent(), price);
    ObjectSetText(objName, text, 7, "Verdana", Red);
    ObjectSet(objName, OBJPROP_ANGLE, angle);
    Error error = GetError();
    if(IsError(error)) {
        Print(StringFormat("_WriteTextOnPriceWithAngle ERR: %d - %s", error.code, error.text));
    }
}
//+------------------------------------------------------------------+
