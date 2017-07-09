__author__ = 's1648321'

import matplotlib.pyplot as plt
from assimulo.problem import Explicit_Problem  #Imports the problem formulation from Assimulo
from assimulo.solvers import GLIMDA #Imports the solver from Assimulo
import inputtimes

def preodes(odes):

    name_list = []
    diff_odes = []

    for item in odes:
        loc_ode = item.find('=')
        pro_name = item[:loc_ode]
        p_name = item[pro_name.find('(')+1: pro_name.rfind('(')]
        p_ode = item[loc_ode + 1:len(item) - 1].strip()
        diff_odes.append(p_ode)
        name_list.append(p_name)

    name_copy = ','.join(name_list)
    name_copy +=' = w'

    return diff_odes, name_copy


def solvecomplex(rhs, initial_concentrations, t0, tfinal):

    model = Explicit_Problem(rhs, initial_concentrations, t0)
    model.name = 'Simulate ODEs'

    sim = GLIMDA(model)

    t, y = sim.simulate(tfinal)
    return t, y


def plotodes(filename, process, species_list, solution, times, is_save):

    plt.style.use('ggplot')
    fig = plt.figure(figsize=(12, 6))
    ax1 = fig.add_subplot(111)

    color_list = ['peru', 'khaki','aquamarine', 'darkblue', 'lime', 'darkgreen', 'cyan']
    solutionc = solution.T

    if len(species_list) > 7:
        for num in range(len(species_list)):
            if num < 7:
                ax1.plot(times, solutionc[num])
            elif 7 <= num < 14:
                ax1.plot(times, solutionc[num], linestyle='--')
            else:
                ax1.plot(times, solutionc[num], color=color_list[num-14])
    else:
        for num in range(len(species_list)):
            ax1.plot(times, solutionc[num])

    ax1.legend(species_list, bbox_to_anchor=(1.02,0.8),loc=6)
    ax1.set_xlabel('Time (seconds)')
    ax1.set_ylabel('Concentration')
    ax1.set_title(filename +' process ' + process)

    if is_save == 'Yes':
        save_name = inputtimes.picturename()
        plt.savefig(save_name, dpi=300)
    elif is_save == 'No':
        print('Picture will not be saved or you can change your selection.')
