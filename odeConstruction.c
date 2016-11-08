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
  hs_init(1, fpath);
  constructODEs(fpath, fpath);
  hs_exit();
  return 0;
}
