# Introduction #
The Matlab extension to CPiWB is work in progess. The extension runs on Matlab 2015a and compiled using GHC version 7.8.4.

Please forward any questions regarding this extension to Ross Rhodes (rrhodes).

# Updating Files #
In the event that any changes are made to the following files:

* constructODEs.hs
* odeConstruction.c

It will be necessary to manually update the library `libOdeConstruction.so`.

First, make sure Numeric Hackage dependencies are installed. Run the following commands:

```
cabal install hmatrix
cabal install hmatrix-gsl
```

Then compile using **GHC**:

```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4 -i../
```

This will automatically update `constructODEs_stub.h` in addition to `libOdeConstruction.so`, if necessary.

If any changes are made to `callCPiWB`'s signature in `odeConstruction.c`, it will also be necessary to update `odeConstruction.h` in addition to `libOdeConstruction.so`.
