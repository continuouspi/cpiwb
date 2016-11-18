#include "stdio.h"
#include "HsFFI.h"
#include "constructODEs_stub.h"


/*
author: Ross Rhodes
*/

int callMatlab(char*** fpath){
    int paramNum = 1;
    int *p;

    p = &paramNum;
    hs_init(p, fpath);
    char *path = (char*) fpath;
    path = constructODEs(path, path);
    hs_exit();
    return 0;
}

int main(){
}
