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
char* callCPiWB(char* input){
    char* fpath;
    char* process;
    char* odes;

    // determine the filepath and process
    // input parameters separated in Matlab by a comma
    fpath = strtok(input, ",");
    process = strtok(NULL, ",");

    // flag beginning of Haskell call
    hs_init(NULL, NULL);

    odes = constructODEs(fpath, process);

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
