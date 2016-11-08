#include "HsFFI.h"
#include "stdio.h"
#include "constructODEs_stub.h"


/*
author: Ross Rhodes
*/

int main(){
  return 0;
}

int callMatlab(char* fpath){
  constructODEs(fpath, fpath);
  return 0;
}
