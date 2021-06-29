//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteTextOnBarVertically(string text) {
    string objName = StringFormat("%s-%s", IntegerToString(TimeCurrent()), text);
    ObjectCreate(objName, OBJ_TEXT, 0, TimeCurrent(), Bid);
    ObjectSetText(objName, text, 7, "Verdana", Red);
    ObjectSet(objName, OBJPROP_ANGLE, 90);
}
//+------------------------------------------------------------------+
