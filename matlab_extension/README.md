# Setup #
The Matlab extension to CPiWB is work in progess, using GHC version 7.8.4.

To compile `constructODEs.hs` in the event that changes are made, use GHC as follows:
```
ghc constructODEs.hs
```
This will perform the compilation and update `constructODEs_stub.h` automatically.

To compile `odeConstruction.c` in the event that changes are made, use **GHC** as follows:
```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4
```
This will update shared library `libOdeConstruction.so` for use in Matlab.

# Questions #
Please forward any questions regarding this extension to Ross Rhodes (rrhodes).
