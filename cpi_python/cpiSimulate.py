__author__ = 's1648321'
import scipy.integrate as integrate
import numpy as np
import openfile
import parseodes
import solveodes
import selectprocess
import inputtimes
from ctypes import *

class Simulate():
    def __init__(self):
        self.filename = ''
        self.cpi_defs = ''
        self.process = ''
        self.odes = ''
        self.initial_concentrations = ''

    def view_odes(self, is_print):
        templib = cdll.LoadLibrary('./libOdeConstruction.so')
        ode_convert = templib.callCPiWB
        filepath, filename = openfile.getFilePath()
        cpi_defs = openfile.readFileContent(filepath)

        process_list = parseodes.parse_process(cpi_defs)
        process = selectprocess.selectapro(process_list)
        odes, initial_concentrations, ode_num = parseodes.parse_odes(ode_convert, cpi_defs, process)

        self.filename = filename
        self.cpi_defs = cpi_defs
        self.process = process
        self.odes = odes
        self.initial_concentrations = initial_concentrations

        if is_print == 'Yes':
            print 'The odes of selected process are:'+'\n'
            for item in odes:
                print item
        elif is_print == 'No':
            print 'The odes will not be printed here.'
        else:
            print 'Please input the right print choice. (Yes or No) Or you can print the odes manually.'

    def simulate_process(self, is_print, solver, is_save):
        self.view_odes(is_print)

        species_list = parseodes.parse_species(self.cpi_defs, self.process)
        diff_odes, name_copy = solveodes.preodes(self.odes)

        t0, tfinal, tdivide = inputtimes.timeforodeint()

        if tdivide > 0 and solver == 'odeint':
            times = np.linspace(t0, tfinal, tdivide)

            def odeint_fun(w, t):
                exec(name_copy) in globals(), locals()
                temp_fun = np.array([])
                for diff_ode in diff_odes:
                    temp_fun = np.append(temp_fun, (eval(diff_ode)))
                return temp_fun

            solution = integrate.odeint(odeint_fun, self.initial_concentrations, times)

        else:
            def rhs(t, w):
                exec(name_copy) in globals(), locals()
                temp_fun = np.array([])
                for diff_ode in diff_odes:
                    temp_fun = np.append(temp_fun, (eval(diff_ode)))
                return temp_fun

            times, solution = solveodes.solvecomplex(rhs, self.initial_concentrations, t0, tfinal)

            if solver == 'odeint':
                print 'Input number of times: 0. You can only use GLIMDA solver to simulate this process.'
            elif solver != 'GLIMDA':
                print 'Cannot find the input solver, the process will be solved with GLIMDA solver.'

        solveodes.plotodes(self.filename, self.process, species_list, solution, times, is_save)
