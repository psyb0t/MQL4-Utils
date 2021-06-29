//+------------------------------------------------------------------+
#include <MyUtils/Trade.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddToBeginningOfArray(int val, int &arr[]) {
    int arrSize = ArraySize(arr);
    int pivotArr[];
    ArrayResize(pivotArr, arrSize);
    pivotArr[0] = val;
    int i;
    for(i = 0; i < arrSize - 1; i++) {
        pivotArr[i + 1] = arr[i];
    }
    for(i = 0; i < arrSize; i++) {
        arr[i] = pivotArr[i];
    }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddToBeginningOfArray(Trade &val, Trade &arr[]) {
    int arrSize = ArraySize(arr);
    Trade pivotArr[];
    ArrayResize(pivotArr, arrSize);
    pivotArr[0] = val;
    int i;
    for(i = 0; i < arrSize - 1; i++) {
        pivotArr[i + 1] = arr[i];
    }
    for(i = 0; i < arrSize; i++) {
        arr[i] = pivotArr[i];
    }
}
//+------------------------------------------------------------------+
