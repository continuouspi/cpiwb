# Setup #
The Matlab extension to CPiWB is work in progess, using GHC version 7.8.4.

Make sure Numeric Hackage dependencies are installed prior to compilation. Run the following commands:

```
cabal install hmatrix
cabal install hmatrix-gsl
```

Then compile `constructODEs.hs`:

```
ghc constructODEs.hs -i../
```

This will generate `constructODEs_stub.h` automatically.

Now compile `odeConstruction.c` using **GHC**:

```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4 -i../
```

This will generate shared library `libOdeConstruction.so` for use in Matlab.

# Questions #
Please forward any questions regarding this extension to Ross Rhodes (rrhodes).
