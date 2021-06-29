//+------------------------------------------------------------------+
enum TradeType {
    _TradeTypeNotSet = 0,
    TradeTypeBuy = 1,
    TradeTypeSell = 2
};

class Trade {
  public:
    TradeType type;
    string comment;
    double volume;
    double stopLoss;
    double takeProfit;
    int ticketNumber;

    Trade() {};
    Trade(TradeType t, string cmnt, double vol, double sl, double tp);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade(TradeType t, string cmnt, double vol, double sl, double tp) {
    type = t;
    comment = cmnt;
    volume = vol;
    stopLoss = sl;
    takeProfit = tp;
}
//+------------------------------------------------------------------+
