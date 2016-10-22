# Setup #
This extension is work in progress. To run the extension as it stands now, run Matlab and first make sure the MEX (Matlab EXecutable) command uses the GCC compiler. To do this, run

```
mex -setup
```

This should return `MEX configured to use 'gcc' for C language compilation'. If this is not the case, then run

```
mex -setup gcc
```

The MEX command is now set to use GCC.

To build the extension, run

```
mex cpi_extension/odeConstruction.c -I'/usr/lib64/ghc-7.8.4/include/'
```

# Execution #
After building the extension to CPiWB on Matlab (see Setup), it may be executed by running

```
odeConstruction(<.cpi file>)
```

where `<.cpi_file>` is an existing Continuous Pi Calculus model saved with the .cpi extension.
