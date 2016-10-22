#include "mex.h"
#include "stdio.h"
#include "unistd.h"

#include "HsFFI.h"
#ifdef __GLASGOW_HASKELL__
#include "cpiwb_stub.h"
#endif

/*
source: http://uk.mathworks.com/help/matlab/matlab_external/standalone-example.html
author: Ross Rhodes
*/

int validate_input(int nrhs, const mxArray *prhs[])
{
  const char* fpath;

  /* make sure exactly one input argument is provided */
  if (nrhs == 0) {
    mexErrMsgIdAndTxt("MyToolbox:cpi_extension:nrhs_zero",
                      "Please supply a CPi filepath as input.");
    return 1;
  } else if (nrhs > 1) {
    mexErrMsgIdAndTxt("MyToolbox:cpi_extension:nrhs_large",
                      "Please supply exactly one CPi filepath as input.");
    return 1;
  }

  fpath = mxArrayToString(prhs[0]);

  /* make sure C is able to access and read the provided file */
  if (access(fpath, F_OK) != -1 && access(fpath, R_OK) == -1){
    mexErrMsgIdAndTxt("MyToolbox:cpi_extension:no_read_access",
                      "CPi file does not have read permissions.");
    return 1;
  } else if (access(fpath, F_OK) == -1){
    mexErrMsgIdAndTxt("MyToolbox:cpi_extension:prhs_null",
		                 "CPi does not exist along the path provided.");
    return 1;
  }
  return 0;
}


int generate_odes(){
  return;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /*
  param nlhs: Number of output arguments, or size of plhs array
  param plhs: Array of output arguments
  param nrhs: Number of input arguments, or size of prhs array
  param prhs: Array of input arguments
  */

  int valid;

  valid = validate_input(nrhs, prhs);

  if (!valid){
      return;
  }

  hs_init(&nrhs, &prhs);
  generate_odes();
  hs_exit();

  return;
}
