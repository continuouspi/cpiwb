#include "stdio.h"
#include "string.h"
#include "HsFFI.h"
#include "constructODEs_stub.h"

/*
  author: Ross Rhodes
*/

/*
  callMatlab calls CPiWB with a given filepath, fpath
  Returns the ODEs for the given model
*/
char* callCPiWB(char* defs, char* process){
    char* odes;

    // flag beginning of Haskell call
    // no parameters required given this is not called from command-line
    hs_init(NULL, NULL);

    odes = constructODEs(defs, process);

    // flag end of Haskell call
    hs_exit();
    return odes;
}

/*
  empty main introduced to avoid undefined reference to
` main` in `_start` errors during ghc compilation
*/
int main(){
}
