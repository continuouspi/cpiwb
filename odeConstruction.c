#include "HsFFI.h"
#include "stdio.h"
#include "constructODEs_stub.h"


/*
author: Ross Rhodes
*/

int main(){
  return 0;
}

int callMatlab(char*** fpath){
  int a = 1;
  int *p = a;
  hs_init(p, fpath);
  constructODEs(fpath, fpath);
  hs_exit();
  return 0;
}
