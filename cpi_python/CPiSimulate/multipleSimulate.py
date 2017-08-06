__author__ = 's1648321'

import scipy.integrate as integrate
import numpy as np
import singleSimulate
import solveodes
import inputtimes
import compareSolution
import comparecpi

class Simulate():
    def __init__(self, process_num, model_input):
        self.process_num = process_num
        self.model_list = []
        self.tol_title = []
        self.tol_label = []
        self.input_comparelist = []  # use to store the common species in these processes
        self.separateplot_title = []
        self.times_list = []
        self.tol_solution = []
        self.tol_numlist = []
        self.same_list = []

        if 2 <= process_num <= 4:
            self.get_models(model_input)
        else:
            print('The number of compared process should be in 2 to 4, please enter the correct process number.')

    def get_models(self, model_input):  # selecting a existing .cpi file and one of its process

        model_list = []
        try:
            for num in range(0, int(self.process_num)):
                model = singleSimulate.Simulate(model_input[num])   # get processes from different models
                model_list.append(model)

            self.model_list = model_list
        except IndexError:
            print "The number of input models should be the same as the 'process_num'."

    # simulate the solution set for the specified time period
    def simulate_process(self, model, loc, t0, tfinal, tdivide, solver):

        diff_odes, name_copy = solveodes.preodes(model.odes[loc])

        if tdivide > 0 and solver == 'odeint':
            times = np.linspace(t0, tfinal, tdivide)

            def odeint_fun(w, t):
                exec(name_copy) in globals(), locals()
                temp_fun = np.array([])
                for diff_ode in diff_odes:
                    temp_fun = np.append(temp_fun, (eval(diff_ode)))
                return temp_fun

            solution = integrate.odeint(odeint_fun, model.initial_concentrations[loc], times)

        else:
            def rhs(t, w):
                exec(name_copy) in globals(), locals()
                temp_fun = np.array([])
                for diff_ode in diff_odes:
                    temp_fun = np.append(temp_fun, (eval(diff_ode)))
                return temp_fun

            plot_title = model.filename + ' process ' + model.process
            times, solution = solveodes.solvecomplex(rhs, model.initial_concentrations[loc], t0, tfinal, plot_title)

            if solver == 'odeint':
                print 'Input number of times: 0. You can only use GLIMDA solver to simulate this process.'
            elif solver != 'GLIMDA':
                print 'Cannot find the input solver, the process will be solved with GLIMDA solver.'

        spec_num = len(model.species_list[loc])
        solutionc = solution.T
        re_solution = solutionc[0: spec_num]  # cut unnecessary solutions

        return times, re_solution

    # compare processes in from different models
    def compare_simulate(self, process_input, solver, t_start, t_final, t_divide):

        loc_list = []
        try:
            for num in range(0, self.process_num):
                loc = self.model_list[num].process_list.index(process_input[num])
                loc_list.append(loc)
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'
        except IndexError:
            print "The number of input models should be the same as the 'process_num'."

        if loc_list:

            # compare processes in same time scope
            t0, tfinal, tdivide = inputtimes.timeforodeint(t_start, t_final, t_divide)

            tol_solution = []
            tol_label = []
            tol_title = []
            input_comparelist = []  # use to store the common species in these processes
            separateplot_title = []
            times_list = []

            for num in range(0, self.process_num):
                model = self.model_list[num]
                times, solution = self.simulate_process(model, loc_list[num], t0, tfinal, tdivide, solver)
                tol_solution.append(solution)
                times_list.append(times)
                model_tran = [i + '(' + model.process_list[loc_list[num]] + ', ' + model.filename + ')'
                              for i in model.species_list[loc_list[num]]]
                separateplot_title.append(model.filename + ' process ' + model.process_list[loc_list[num]])
                tol_label += model_tran
                tol_title.append(model.filename)
                input_comparelist.append(model.species_list[loc_list[num]])

            self.tol_title = tol_title
            self.tol_label = tol_label
            self.input_comparelist = input_comparelist  # use to store the common species in these processes
            self.separateplot_title = separateplot_title
            self.times_list = times_list
            self.tol_solution = tol_solution

            same_list = comparecpi.compare_species(self.input_comparelist)

            if same_list != 0:  # if there are common species

                self.same_list = same_list
                print 'Common species in these processes are: ' + ', '.join(same_list)

            else:
                print 'There is no common species in selected processes.'

    def compare_model(self, process_input, solver, t_start, t_final, t_divide):

        self.compare_simulate(process_input, solver, t_start, t_final, t_divide)

        solution_object = compareSolution.SingleCompareSolution(self.same_list, self.separateplot_title,
                                                                self.tol_title, self.tol_label, self.input_comparelist,
                                                                self.tol_solution, self.times_list)
        return solution_object



