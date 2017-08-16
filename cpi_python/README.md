# Introduction #
The Continuous Pi Calculus in Jupyter Notebook is work in progess [WIP]. This tool runs in the Jupyter Notebook, calling the Continuous Pi Workbench (CPiWB) in this repository. From its inception in May 2017 until August 2017, it is developed by Chaonan Dai under the supervision of Ian Stark - please forward any questions to these individuals.


# Environment set up #
Conda environments are required to contain numerical computing libraries like `NumPy` and `SciPy`.

## Installing Miniconda
Instructions for setting up on the DICE machines provided by the School of Informatics at the University of Edinburgh are provided here.

Firstly, download the latest 64-bit Python 2.7 Miniconda install script:
```
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
```
Then run the install script:
```
bash Miniconda2-latest-Linux-x86_64.sh
```
On other Linux machine, you may accept the default `PATH`. But on DICE, we have to append the Miniconda binaries directory to PATH in manually:
```
echo "export PATH=\""\$PATH":$HOME/miniconda2/bin\"" >> ~/.benv
source ~/.benv
```

## Installing necessary packages
Install the dependencies:
```
conda install numpy scipy matplotlib jupyter git
```
Install Assimulo package:
```
conda install -c chria assimulo=2.9
```
Clear the downloaded package
```
conda clean -t
```

# Open the notebooks
To open a notebook, we need to launch a Jupyter notebook server instance. From the directory containing the local copy of this tool:
```
jupyter notebook
```
Then a Jupyter notebook server instance will be started in the current terminal, then the `.ipynb` notebooks are allowed to be loaded.
We may have to click on the `Trust Notebook` in the File menu to show the default figure objects.
