__author__ = 's1648321'
import scipy.integrate as integrate
import numpy as np
import openfile
import parseodes
import solveodes
import inputtimes
import latexEqu
import singleCompare
import separateCompare
import comparecpi
import compareSolution
from IPython.display import display, Math
from ctypes import *

class Simulate():
    def __init__(self, filename):
        self.filename = filename
        self.cpi_defs = ''
        self.pro_def = []
        self.process_list = []
        self.process_num = 0
        self.odes = []
        self.initial_concentrations = []
        self.species_list = []
        self.select_file()

    def select_file(self):  # selecting a existing .cpi file and one of its process
        print 'Select the model: ' + self.filename
        cpi_defs = openfile.readFileContent(self.filename)

        self.cpi_defs = cpi_defs

        process_list, process_num = parseodes.parse_process(self.cpi_defs)

        if process_list != 0:
            print 'The processes in this cpi model are:'+'\n' + ', '.join(process_list)
            self.process_num = process_num
            self.process_list = process_list

            for item in self.process_list:
                self.get_content(item)

        else:
            print 'Cannot parse existing processes from the selected file, this kernel will restart.'

    def get_content(self, process):  # determine which process the user wishes to model from file

        if process in self.process_list:

            templib = CDLL('../CPiSimulate/libOdeConstruction.so')  # load the cpiwb shared library
            handle = templib._handle
            ode_convert = templib.callCPiWB

            odes, initial_concentrations, ode_num = parseodes.parse_odes(ode_convert, self.cpi_defs, process)
            species_list = parseodes.parse_species(self.cpi_defs, process)

            del templib
            cdll.LoadLibrary('libdl.so').dlclose(handle)  # unload the cpiwb shared library

            self.odes.append(odes)
            self.initial_concentrations.append(initial_concentrations)
            self.species_list.append(species_list)
        else:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def view_definitions(self):
        print 'The cpi definitions of selected file are:'+'\n' + self.cpi_defs

    def view_processdef(self, process):
        try:
            loc = self.process_list.index(process)
            if self.process_num == 1:
                self.view_definitions()
            else:
                self.pro_def = parseodes.parse_processdef(self.cpi_defs, self.species_list[loc], process)
                print 'The cpi definitions of selected process are:'+'\n'
                for item in self.pro_def:
                    print item
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def view_odes(self, process):
        try:
            loc = self.process_list.index(process)
            print 'The odes of selected process are:'+'\n'
            for item in self.odes[loc]:
                print item
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def view_odes_latexprint(self, process):
        try:
            loc = self.process_list.index(process)
            latex_list = latexEqu.convert_latex(self.odes[loc])
            print 'Sample text format:' + '\n'
            for item in latex_list:
                print item

            print 'Sample LaTeX format:' + '\n'
            for item in latex_list:
                display(Math(item))
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def view_initial_concentrations(self, process):

        try:
            loc = self.process_list.index(process)
            print 'The initial concentrations in selected process are:'+'\n'
            print self.initial_concentrations[loc]
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def view_species(self, process):
        try:
            loc = self.process_list.index(process)
            print 'The species in selected process are:'+'\n' + ', '.join(self.species_list[loc])
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    # simulate the solution set for the specified time period
    def simulate(self, process, solver, t_start, t_final, t_divide):

        try:
            loc = self.process_list.index(process)
            diff_odes, name_copy = solveodes.preodes(self.odes[loc])

            t0, tfinal, tdivide = inputtimes.timeforodeint(t_start, t_final, t_divide)

            if tdivide > 0 and solver == 'odeint':
                times = np.linspace(t0, tfinal, tdivide)

                def odeint_fun(w, t):
                    exec(name_copy) in globals(), locals()
                    temp_fun = np.array([])
                    for diff_ode in diff_odes:
                        temp_fun = np.append(temp_fun, (eval(diff_ode)))
                    return temp_fun

                solution = integrate.odeint(odeint_fun, self.initial_concentrations[loc], times)

            else:
                def rhs(t, w):
                    exec(name_copy) in globals(), locals()
                    temp_fun = np.array([])
                    for diff_ode in diff_odes:
                        temp_fun = np.append(temp_fun, (eval(diff_ode)))
                    return temp_fun

                plot_title = self.filename + ' process ' + process
                times, solution = solveodes.solvecomplex(rhs, self.initial_concentrations[loc], t0, tfinal, plot_title)

                if solver == 'odeint':
                    print 'Input number of times: 0. You can only use GLIMDA solver to simulate this process.'
                elif solver != 'GLIMDA':
                    print 'Cannot find the input solver, the process will be solved with GLIMDA solver.'

            spec_num = len(self.species_list[loc])
            solutionc = solution.T
            re_solution = solutionc[0: spec_num]  # cut unnecessary solutions

            return times, re_solution
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'
            return 0, 0

    def simulate_process(self, process, solver, t_start, t_final, t_divide):
        try:
            loc = self.process_list.index(process)
            times, solution = self.simulate(process, solver, t_start, t_final, t_divide)
            plot_title = self.filename + ' process ' + process
            solution_object = solveodes.PlotOdes(plot_title, self.species_list[loc], solution, times)

            return solution_object
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'
            return 0

    # compare the difference of two solver in one cpi model
    def compare_solver(self, process, t_start, t_final, t_divide, plot_type):

        try:
            loc = self.process_list.index(process)

            ode_times, ode_sol = self.simulate(process, 'odeint', t_start, t_final, t_divide)
            GLIMDA_times, GLIMDA_sol = self.simulate(process, 'GLIMDA', t_start, t_final, t_divide)

            plottitle = self.filename + ' process ' + process
            model_tran1 = [i + '(odeint)' for i in self.species_list[loc]]
            model_tran2 = [i + '(GLIMDA)' for i in self.species_list[loc]]

            tol_solution = [ode_sol, GLIMDA_sol]
            tol_label = model_tran1 + model_tran2

            separateplot_title = [plottitle+' (odeint)', plottitle+' (GLIMDA)']
            times_list = [ode_times, GLIMDA_times]

            tol_numlist = []
            input_comparelist = [self.species_list[loc], self.species_list[loc]]

            if plot_type == 'single':
                singleplot_title = plottitle
                singleCompare.plotdiffs(singleplot_title, tol_label, self.species_list[loc], tol_numlist, tol_solution,
                                        times_list)
            elif plot_type == 'separate':
                separateCompare.plotdiffs(separateplot_title, input_comparelist, tol_numlist, tol_solution, times_list)
            else:
                print "Please input the correct plot type, 'single' or 'separate'."

        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'

    def simulate_all_processes(self, solver, t_start, t_final, t_divide):
        if self.process_num == 1:
            self.simulate_process(self.process_list[0], solver, t_start, t_final, t_divide)
        elif self.process_num > 4:
            print "There are too many processes in this models, you need to select at most four of them. "
            return 0
        else:
            times = []
            solution = []
            for process_num in range(0, self.process_num):
                temp_times, temp_sol = self.simulate(self.process_list[process_num], solver, t_start, t_final, t_divide)
                times.append(temp_times)
                solution.append(temp_sol)

            same_list = comparecpi.compare_species(self.species_list)

            if same_list != 0:  # if there are common species
                #self.same_list = same_list
                print 'Common species in these processes are: ' + ', '.join(same_list)
            else:
                print 'There is no common species in selected processes.'

            tol_label = []
            separateplot_title = []
            tol_title = [self.filename]

            for num in range(0, self.process_num):
                model_tran = [i + '(' + self.process_list[num] + ', ' + self.filename + ')'
                              for i in self.species_list[num]]
                tol_label += model_tran
                separateplot_title.append(self.filename + ' process ' + self.process_list[num])

            solution_object = compareSolution.SingleCompareSolution(same_list, separateplot_title, tol_title, tol_label,
                                                                    self.species_list, solution, times)
            solution_object.process_list = self.process_list

            return solution_object