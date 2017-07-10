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
        self.species_list = ''
        self.solution = ''
        self.select_file()

    def select_file(self):

        filepath, filename = openfile.getFilePath()
        cpi_defs = openfile.readFileContent(filepath)

        self.filename = filename
        self.cpi_defs = cpi_defs

        templib = cdll.LoadLibrary('./libOdeConstruction.so')
        ode_convert = templib.callCPiWB
        process_list = parseodes.parse_process(self.cpi_defs)
        process = selectprocess.selectapro(process_list)
        odes, initial_concentrations, ode_num = parseodes.parse_odes(ode_convert, self.cpi_defs, process)
        species_list = parseodes.parse_species(self.cpi_defs, self.process)

        self.process = process
        self.odes = odes
        self.initial_concentrations = initial_concentrations
        self.species_list = species_list

    def view_definitions(self):
        print 'The cpi definitions of selected file are:'+'\n' + self.cpi_defs

    def view_odes(self):
        print 'The odes of selected process are:'+'\n'
        for item in self.odes:
            print item

    def view_species(self):
        print 'The species in selected process are:'+'\n' + ''.join(self.species_list)

    def simulate_process(self, solver, is_save):

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

        self.solution = solution
        solveodes.plotodes(self.filename, self.process, self.species_list, solution, times, is_save)
        
