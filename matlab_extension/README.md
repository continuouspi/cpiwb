# Introduction #
The Continuous Pi Calculus Matlab Extension (CPiME) is work in progess [WIP]. The extension runs on Matlab 2015a, calling the Continuous Pi Workbench (CPiWB) in this repository. From its inception in September 2016 until present, the extension is developed by Ross Rhodes (rrhodes) under the supervision of Ian Stark - please forward any questions to these individuals.

# Development & Compilation #
In the event that any amendments are made to the following files

* constructODEs.hs
* odeConstruction.c

it will be necessary to update the library `libOdeConstruction.so`.

First, make sure Numeric Hackage dependencies are installed. Run the following commands:

```
cabal install hmatrix
cabal install hmatrix-gsl
```

Then compile these files using **GHC** (version 7.8.4):

```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4 -i../
```

This will automatically update `constructODEs_stub.h` in addition to `libOdeConstruction.so`, if necessary.

If any changes are made specifically to method `callCPiWB`'s signature in `odeConstruction.c`, it will also be necessary to update `odeConstruction.h` in addition to `libOdeConstruction.so`. This is simply a case of amending `odeConstruction.h`'s signature to reflect changes made in `odeConstruction.c`.
