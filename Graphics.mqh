//+------------------------------------------------------------------+
#include <MQL4-Utils/Error.mqh>

//+------------------------------------------------------------------+
//|
//+------------------------------------------------------------------+
void WriteTextOnPriceVertically(string text, double price, int font_size = 7, color clr = clrRed) {
    _WriteTextOnPrice(text, price, 90, font_size, clr);
}

//+------------------------------------------------------------------+
//|
//+------------------------------------------------------------------+
void WriteTextOnPriceHorizontally(string text, double price, int font_size = 7, color clr = clrRed) {
    _WriteTextOnPrice(text, price, 0, font_size, clr);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _WriteTextOnPrice(string text, double price, double angle = 0, int font_size = 7, color clr = clrRed) {
    string objName = StringFormat("%d-%s", (int) TimeCurrent(), text);
    ObjectCreate(0, objName, OBJ_TEXT, 0, TimeCurrent(), price);
    ObjectSetText(objName, text, font_size, "Arial", clr);
    ObjectSet(objName, OBJPROP_ANGLE, angle);
    Error error = GetError();
    if(IsError(error)) {
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawButton(string text,
                string name,
                int x,
                int y,
                color clr,
                color back_clr,
                color border_clr,
                int font_size,
                int width,
                int height,
                bool selectable = false,
                ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER,
                ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER,
                long z_order = 0,
                bool hidden = false) {
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
    ObjectSetString(0, name, OBJPROP_FONT, "Arial");
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
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLabel(string text,
               string name,
               int x,
               int y,
               color clr,
               int font_size,
               double angle = 0,
               ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER,
               ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER,
               bool back = false,
               bool selectable = false,
               bool hidden = false,
               long z_order = 0) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0)) {
        error = GetError();
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
        return;
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetString(0, name, OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetDouble(0, name, OBJPROP_ANGLE, angle);
    ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_BACK, false);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, selectable);
    ObjectSetInteger(0, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
}

void UpdateLabel(string name, string text) {
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    int errCode = GetLastError();
    if (errCode != ERR_NO_ERROR) {
        Print(StringFormat("%s - could not update label - %s", __FUNCTION__, ErrorDescription(errCode)));
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawRectangleLabel(string name,
                        int x,
                        int y,
                        int width,
                        int height,
                        color back_clr,
                        ENUM_BORDER_TYPE border,
                        ENUM_BASE_CORNER corner,
                        color clr,
                        ENUM_LINE_STYLE line_style,
                        int line_width = 1,
                        bool back = true,
                        bool selectable = false,
                        bool hidden = true,
                        long z_order = 0) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0)) {
        error = GetError();
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
        return;
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
    ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, border);
    ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_STYLE, line_style);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, line_width);
    ObjectSetInteger(0, name, OBJPROP_BACK, back);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, selectable);
    ObjectSetInteger(0, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawEditBox(string text,
                 string name,
                 int x,
                 int y,
                 int font_size,
                 color clr,
                 color back_clr,
                 int width,
                 int height,
                 ENUM_BASE_CORNER corner,
                 int line_width = 1,
                 bool back = false,
                 bool selectable = false,
                 bool hidden = true,
                 long z_order = 0) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0)) {
        error = GetError();
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
        return;
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
    ObjectSetString(0, name, OBJPROP_TEXT, text);
    ObjectSetString(0, name, OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
    ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, line_width);
    ObjectSetInteger(0, name, OBJPROP_BACK, back);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, selectable);
    ObjectSetInteger(0, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawHorizontalLine(string name,
                        double price,
                        color clr,
                        ENUM_LINE_STYLE style = STYLE_SOLID,
                        int width = 1,
                        bool back = true,
                        bool selectable = false,
                        bool hidden = true,
                        long z_order = 0) {
    Error error = GetErrorByCode(ERR_NO_ERROR);
    if(!ObjectCreate(0, name, OBJ_HLINE, 0, 0, price)) {
        error = GetError();
        Print(StringFormat("%s ERR: %d - %s", __FUNCTION__, error.code, error.text));
        return;
    }
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, name, OBJPROP_STYLE, style);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
    ObjectSetInteger(0, name, OBJPROP_BACK, back);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, selectable);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, selectable);
    ObjectSetInteger(0, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
}
//+------------------------------------------------------------------+
