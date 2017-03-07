# Introduction #
The Continuous Pi Calculus Matlab Extension (CPiME) is work in progess [WIP]. The extension runs on Matlab 2015a, calling the Continuous Pi Workbench (CPiWB) in this repository. From its inception in September 2016 until April 2017, the extension is developed by Ross Rhodes (rrhodes) under the supervision of Ian Stark - please forward any questions to these individuals.

# Installation #
First, make sure all Hackage dependencies are installed. Machines provided by the School of Informatics at the University of Edinburgh only require two missing dependencies.

```
cabal install hmatrix
cabal install hmatrix-gsl
```

Then compile these files using **GHC** (tested with version 7.8.4):

```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4 -i../
```

This will prepare the shared library for CPiME.

To start CPiME, run Matlab, and open the `main` script. Run this script.

# Notes to Developers #
In the event that any amendments are made to the following files

* constructODEs.hs
* odeConstruction.c

it will be necessary to update the shared library `libOdeConstruction.so`. Please follow the installation steps to do this.

If any changes are made specifically to the signature for `callCPiWB` in `odeConstruction.c`, it will also be necessary to repeat those changes inside `odeConstruction.h`.
