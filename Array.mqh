//+------------------------------------------------------------------+
#include <MQL4-Utils/Trade.mqh>

//+------------------------------------------------------------------+
void ArrayPrepend(int val, int &arr[]) {
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
void ArrayPrepend(Trade &val, Trade &arr[]) {
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
void ArrayRemoveIndex(int index, Trade &arr[]) {
    int arrSize = ArraySize(arr);
    for(int i = index; i < arrSize; i++) {
        if(i == arrSize-1) {
            break;
        }
        arr[i] = arr[i+1];
    }
    arr[arrSize-1] = Trade();
}

//+------------------------------------------------------------------+
void ArrayPrint(Trade &arr[]) {
    int arrSize = ArraySize(arr);
    string text = "";
    for(int i = 0; i < arrSize; i++) {
        text += StringFormat("[%d] - %d", i, arr[i].ticketNumber);
        if(i < arrSize-1) {
            text += " | ";
        }
    }

    Print(text);
}

//+------------------------------------------------------------------+
