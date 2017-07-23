__author__ = 's1648321'

import singleSimulate
import solveodes
import inputtimes
import selectprocess
import singleCompare
import separateCompare
import singleSimulateAll
import scipy.integrate as integrate
import numpy as np


def simulate_process(model, t0, tfinal, tdivide, solver):  # simulate the solution set for the specified time period

    diff_odes, name_copy = solveodes.preodes(model.odes)

    if tdivide > 0 and solver == 'odeint':
        times = np.linspace(t0, tfinal, tdivide)

        def odeint_fun(w, t):
            exec(name_copy) in globals(), locals()
            temp_fun = np.array([])
            for diff_ode in diff_odes:
                temp_fun = np.append(temp_fun, (eval(diff_ode)))
            return temp_fun

        solution = integrate.odeint(odeint_fun, model.initial_concentrations, times)

    else:
        def rhs(t, w):
            exec(name_copy) in globals(), locals()
            temp_fun = np.array([])
            for diff_ode in diff_odes:
                temp_fun = np.append(temp_fun, (eval(diff_ode)))
            return temp_fun

        plot_title = model.filename + ' process ' + model.process
        times, solution = solveodes.solvecomplex(rhs, model.initial_concentrations, t0, tfinal, plot_title)

        if solver == 'odeint':
            print 'Input number of times: 0. You can only use GLIMDA solver to simulate this process.'
        elif solver != 'GLIMDA':
            print 'Cannot find the input solver, the process will be solved with GLIMDA solver.'

    spec_num = len(model.species_list)
    solutionc = solution.T
    re_solution = solutionc[0: spec_num]  # cut unnecessary solutions

    return times, re_solution

def compare_species(input_comparelist):  # get the common species in comparing processes

    species_list = []
    for num in range(1, len(input_comparelist)):
        temp_species = [item for item in input_comparelist[0] if item in input_comparelist[num]]
        species_list.append(temp_species)

    same_species = []
    for item in species_list:
        same_species = list(set(same_species).union(set(item)))

    if same_species:
        return same_species
    else:
        return 0


def compare_model(process_num, solver, is_save):  # compare processes in from different models

    if 2 <= process_num <= 4:

        model_list = []
        for num in range(0, int(process_num)):
            model = singleSimulate.Simulate()   # get processes from different models
            model_list.append(model)

        t0, tfinal, tdivide = inputtimes.timeforodeint()  # compare processes in same time scope

        tol_solution = []
        tol_label = []
        tol_title = []
        input_comparelist = []  # use to store the common species in these processes
        separateplot_title = []
        times_list = []
        for model in model_list:
            times, solution = simulate_process(model, t0, tfinal, tdivide, solver)
            tol_solution.append(solution)
            times_list.append(times)
            model_tran = [i + '(' + model.process + ', ' + model.filename + ')' for i in model.species_list]
            separateplot_title.append(model.filename + ' process ' + model.process)
            tol_label += model_tran
            tol_title.append(model.filename)
            input_comparelist.append(model.species_list)

        plot_type = selectprocess.selectplot()
        tol_numlist = []

        def plot_all():
            if plot_type == 'single plot':
                singleplot_title = 'CPi Model: ' + ' and '.join(tol_title)
                singleCompare.plotdiffs(singleplot_title, tol_label, input_comparelist, tol_numlist, tol_solution,
                                        times_list, is_save)
            else:
                separateCompare.plotdiffs(separateplot_title, input_comparelist, tol_numlist, tol_solution, times_list,
                                          is_save)

        same_list = compare_species(input_comparelist)

        if same_list != 0:  # if there are common species

            species_list = same_list
            print 'Common species in these processes are: ' + ', '.join(species_list)

            select_one = selectprocess.selectspecies()
            if select_one != 'all':  # if only some common species are required to be emphasized
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
    else:
        print('The number of compared process should be in 2 to 4, please enter the correct process number.')


def compare_solver(is_save):  # compare the difference of two solver in one cpi model

    model = singleSimulate.Simulate()

    t0, tfinal, tdivide = inputtimes.timeforodeint()

    ode_times, ode_sol = simulate_process(model, t0, tfinal, tdivide, 'odeint')
    GLIMDA_times, GLIMDA_sol = simulate_process(model, t0, tfinal, tdivide, 'GLIMDA')

    plottitle = model.filename + ' process ' + model.process
    model_tran1 = [i + '(odeint)' for i in model.species_list]
    model_tran2 = [i + '(GLIMDA)' for i in model.species_list]

    tol_solution = [ode_sol, GLIMDA_sol]
    tol_label = model_tran1 + model_tran2

    separateplot_title = [plottitle+' (odeint)', plottitle+' (GLIMDA)']
    times_list = [ode_times, GLIMDA_times]

    plot_type = selectprocess.selectplot()
    tol_numlist = []
    input_comparelist = [model.species_list, model.species_list]

    if plot_type == 'single plot':
        singleplot_title = plottitle
        singleCompare.plotdiffs(singleplot_title, tol_label, input_comparelist, tol_numlist, tol_solution,
                                times_list, is_save)
    else:
        separateCompare.plotdiffs(separateplot_title, input_comparelist, tol_numlist, tol_solution, times_list, is_save)



def compare_process(solver, is_save):  # compare all the processes in single cpi model

    model = singleSimulateAll.Simulate()
    simulate_single = model.simulate_process(solver)
    show_plot = model.show_plot(is_save)
