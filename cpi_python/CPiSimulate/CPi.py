__author__ = 's1648321'
import singleSimulate
import multipleSimulate

def ReadCPiFile(filename):
    single_model = singleSimulate.Simulate(filename)

    return single_model

def ReadMultipleFiles(model_input):
    con_model = multipleSimulate.Simulate(model_input)

    return con_model
