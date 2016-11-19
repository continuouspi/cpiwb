#include "stdio.h"
#include "HsFFI.h"
#include "constructODEs_stub.h"

/*
  author: Ross Rhodes
*/

/*
  callMatlab calls CPiWB with a given filepath, fpath
  Returns the ODEs for the given model
*/
char* callMatlab(char* fpath){

    // flag beginning of Haskell call
    hs_init(NULL, NULL);

    fpath = constructODEs(fpath, fpath);

    // flag end of Haskell call
    hs_exit();
    return fpath;
}

/*
  empty main introduced to avoid undefined reference to
` main` errors in `_start` during ghc compilation
*/
int main(){
}
