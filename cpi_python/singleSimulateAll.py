__author__ = 's1648321'

import openfile
import parseodes
import solveodes
import selectprocess
import singleCompare
import separateCompare
import comparecpi
import inputtimes
from ctypes import *
import scipy.integrate as integrate
import numpy as np

class Simulate():
    def __init__(self):
        self.filename = ''
        self.cpi_defs = ''
        self.processes = []
        self.odes = []
        self.initial_concentrations = []
        self.species_list = []
        self.times = []
        self.solutions = []
        self.select_file()

    def select_file(self):  # selecting a existing .cpi file and one of its process

        filepath, filename = openfile.getFilePath()
        cpi_defs = openfile.readFileContent(filepath)

        self.filename = filename
        self.cpi_defs = cpi_defs

        process_list = parseodes.parse_process(self.cpi_defs)
        self.processes = process_list

        print 'The processes in this cpi model are:'+'\n' + ', '.join(process_list)

        if len(self.species_list) == 1:
            print 'There is only one process in this cpi model, you cannot compare the processes in single model.'
        elif len(self.species_list) > 4:
            print 'The maximun compare number is 4, you should selected 4 of the processes through "compare_model".'
        else:
            for item in self.processes:
                self.get_content(item)

    def get_content(self, process):
        templib = CDLL('./libOdeConstruction.so')  # load the cpiwb shared library
        handle = templib._handle
        ode_convert = templib.callCPiWB

        odes, initial_concentrations, ode_num = parseodes.parse_odes(ode_convert, self.cpi_defs, process)
        species_list = parseodes.parse_species(self.cpi_defs, process)

        del templib
        cdll.LoadLibrary('libdl.so').dlclose(handle)  # unload the cpiwb shared library

        self.odes.append(odes)
        self.initial_concentrations.append(initial_concentrations)
        self.species_list.append(species_list)

    def view_definitions(self):

        print 'The cpi definitions of this cpi model are:'+'\n'+ self.cpi_defs

    def view_odes(self):

        process = selectprocess.selectapro(self.processes)
        loc = self.processes.index(process)
        print 'The odes of selected process are:'+'\n'
        for item in self.odes[loc]:
            print item

    def view_species(self):

        process = selectprocess.selectapro(self.processes)
        loc = self.processes.index(process)
        print 'The species in selected process are:'+'\n' + ', '.join(self.species_list[loc])

    def view_initial_concentrations(self):

        process = selectprocess.selectapro(self.processes)
        loc = self.processes.index(process)
        print 'The initial concentrations in selected process are:'+'\n'
        print self.initial_concentrations[loc]

    def view_solutions(self):

        process = selectprocess.selectapro(self.processes)
        loc = self.processes.index(process)
        print 'The numerical solution of selected process are:'+'\n'
        print self.solutions[loc]

    def simulate_process(self, solver):  # simulate the solution set for the specified time period

        t0, tfinal, tdivide = inputtimes.timeforodeint()

        for process_num in range(0, len(self.processes)):
            diff_odes, name_copy = solveodes.preodes(self.odes[process_num])

            if tdivide > 0 and solver == 'odeint':
                times = np.linspace(t0, tfinal, tdivide)

                def odeint_fun(w, t):
                    exec(name_copy) in globals(), locals()
                    temp_fun = np.array([])
                    for diff_ode in diff_odes:
                        temp_fun = np.append(temp_fun, (eval(diff_ode)))
                    return temp_fun

                solution = integrate.odeint(odeint_fun, self.initial_concentrations[process_num], times)

            else:
                def rhs(t, w):
                    exec(name_copy) in globals(), locals()
                    temp_fun = np.array([])
                    for diff_ode in diff_odes:
                        temp_fun = np.append(temp_fun, (eval(diff_ode)))
                    return temp_fun

                plot_title = self.filename + ' process ' + self.processes[process_num]
                times, solution = solveodes.solvecomplex(rhs, self.initial_concentrations[process_num], t0, tfinal,
                                                         plot_title)

                if solver == 'odeint':
                    print 'Input number of times: 0. You can only use GLIMDA solver to simulate this process.'
                elif solver != 'GLIMDA':
                    print 'Cannot find the input solver, the process will be solved with GLIMDA solver.'

            spec_num = len(self.species_list[process_num])
            solutionc = solution.T
            re_solution = solutionc[0: spec_num]
            self.times.append(times)
            self.solutions.append(re_solution)

    def show_plot(self, is_save):

        process_num = len(self.processes)
        plot_type = selectprocess.selectplot()
        tol_numlist = []
        tol_label = []
        separateplot_title = []

        for num in range(0, process_num):
            model_tran = [i + '(' + self.processes[num] + ', ' + self.filename + ')' for i in self.species_list[num]]
            tol_label += model_tran
            separateplot_title.append(self.filename + ' process ' + self.processes[num])

        def plot_all():
            if plot_type == 'single plot':
                singleplot_title = 'CPi Model: ' + self.filename
                singleCompare.plotdiffs(singleplot_title, tol_label, self.species_list, tol_numlist, self.solutions,
                                        self.times, is_save)
            else:
                separateCompare.plotdiffs(separateplot_title, self.species_list, tol_numlist, self.solutions,
                                          self.times, is_save)

        same_list = comparecpi.compare_species(self.species_list)

        if same_list != 0:

            species_list = same_list
            print 'Common species in these processes are: ' + ', '.join(species_list)

            select_one = selectprocess.selectspecies()
            if select_one != 'all':
                input_list = select_one.split()

                num_list = []
                for item in input_list:

                    if item in species_list:
                        num_list.append(item)
                    else:
                        print 'There is no common species named: ' + item +', it will be ignored here.'

                tol_numlist = num_list
                plot_all()

            else:
                plot_all()

        else:
            print 'There is no common species in selected processes.'
            plot_all()

