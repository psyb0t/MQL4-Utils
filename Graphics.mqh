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
    ObjectCreate(0, objName, OBJ_TEXT, 0, TimeCurrent(), price);
    ObjectSetText(objName, text, 7, "Verdana", Red);
    ObjectSet(objName, OBJPROP_ANGLE, angle);
    Error error = GetError();
    if(IsError(error)) {
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawButton(string text, string name, int x, int y,
                color clr, color back_clr, color border_clr, int font_size,
                int width, int height, bool selectable = false,
                ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER,
                ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER,
                long z_order = 0, bool hidden = false) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) {
        error = GetError();
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
        return;
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
    ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetString(0, name, OBJPROP_FONT, "Verdana");
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
    ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_clr);
    ObjectSetInteger(0, name, OBJPROP_BACK, false);
    ObjectSetInteger(0, name, OBJPROP_STATE, false);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, selectable);
    ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
    ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
    ObjectSetInteger(0, name, OBJPROP_HIDDEN, hidden);
    error = GetError();
    if(IsError(error)) {
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
    }
    return;
}
//+------------------------------------------------------------------+
