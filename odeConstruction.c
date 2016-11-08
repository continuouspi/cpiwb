#include "stdio.h"
#include "constructODEs_stub.h"


/*
author: Ross Rhodes
*/

int main(){
  return 0;
}

int callMatlab(char*** fpath){
    int paramNum = 1;
    int *p;

    p = &paramNum;
    hs_init(p, fpath);
    fpath = constructODEs(fpath, fpath);
    hs_exit();
    return 0;
}
