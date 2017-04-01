# Introduction #
The Continuous Pi Calculus MATLAB Extension (CPiME) is work in progess [WIP]. The extension runs on MATLAB 2015a, calling the Continuous Pi Workbench (CPiWB) in this repository. From its inception in September 2016 until April 2017, the extension is developed by Ross Rhodes (rrhodes) under the supervision of Ian Stark - please forward any questions to these individuals.

# Embedding CPiME in Matlab Code #
To include CPiME in your own Matlab code, download `CPi Calculus MATLAB Extension.mltbx`. Unpackage this toolbox in a directory of your choice. Then open MATLAB, and select `set path` in the Editor tab of the File menu. Add your chosen directory to the list of paths. After this, you are free to call any CPiME functions inside your own code. In particular, call `cpime` to run CPiME from the main menu.

# Installation for Developers #
First, make sure all Hackage dependencies are installed. Machines provided by the School of Informatics at the University of Edinburgh only require two missing dependencies.

```
cabal install hmatrix
cabal install hmatrix-gsl
```

If Cabal fails to download the latest package list, read the `Updating Cabal` notes, then attempt the installation process again.

Then compile these files using **GHC** (tested with version 7.8.4):

```
ghc -O2 -dynamic -shared -fPIC -o libOdeConstruction.so constructODEs.hs odeConstruction.c -lHSrts-ghc7.8.4 -i../
```

This will prepare the shared library for CPiME.

To start CPiME, run Matlab, and open the `main` script. Run this script.

## Updating Cabal ##
One student experienced issues running Cabal to install dependencies for CPiME. Below are the steps this student followed to resolve their issue:

1. Scrutinise your Cabal config file in `~.cabal/config`
2. Uncomment your `ghc-location` property and set it to the location of the GHC compiler on your machines
3. Run `update cabal` on the terminal
4. Re-comment your `ghc-location` property

## Notes to Developers ##
In the event that any amendments are made to the following files

* constructODEs.hs
* odeConstruction.c

it will be necessary to update the shared library `libOdeConstruction.so`. Please follow the installation steps to do this.

If any changes are made specifically to the signature for `callCPiWB` in `odeConstruction.c`, it will also be necessary to repeat those changes inside `odeConstruction.h`.
