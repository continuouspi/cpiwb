__author__ = 's1648321'

import matplotlib.pyplot as plt
from assimulo.problem import Explicit_Problem  # Imports the problem formulation from Assimulo
from assimulo.solvers import GLIMDA  # Imports the solver from Assimulo
import inputtimes

def preodes(odes):  # prepare to convert the string ODEs and Xns into variables and funcrions

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

# GLIMDA solver, provided for the case that odeint cannot solve the odes
def solvecomplex(rhs, initial_concentrations, t0, tfinal, plot_title):

    model = Explicit_Problem(rhs, initial_concentrations, t0)
    model.name = 'Simulate ' + plot_title

    sim = GLIMDA(model)

    t, y = sim.simulate(tfinal)
    return t, y


def plotodes(filetitle, species_list, solution, times, is_save):

    plt.style.use('ggplot')
    fig = plt.figure(figsize=(12, 6))
    ax1 = fig.add_axes([0.1, 0.1, 0.7, 0.8])
    line_add = []

    for item in solution:
        line_temp, = ax1.plot(times, item, picker=5)
        line_add.append(line_temp)

    leg = ax1.legend(species_list, bbox_to_anchor=(1.02, 0.4), loc=6)
    ax1.set_xlabel('Time (seconds)')
    ax1.set_ylabel('Concentration')
    ax1.set_title(filetitle)

    line_leg = dict()
    for origline, legline in zip(line_add, leg.get_lines()):
        line_leg[origline] = legline

    def on_pick(event):
        legline = line_leg[event.artist]

        if event.artist.get_linestyle() == '-':
            event.artist.set_linestyle('--')
            legline.set_linestyle('--')
        elif event.artist.get_linestyle() == '--':
            event.artist.set_linestyle(':')
            legline.set_linestyle(':')
        elif event.artist.get_linestyle() == ':':
            event.artist.set_linestyle(' ')
            legline.set_linestyle(' ')
        else:
            event.artist.set_linestyle('-')
            legline.set_linestyle('-')
        fig.canvas.draw()

    fig.canvas.mpl_connect('pick_event', on_pick)

    if is_save == 'Yes':
        save_name = inputtimes.picturename()
        plt.savefig(save_name, dpi=300)
    elif is_save == 'No':
        print('Picture will not be saved or you can change your selection.')
    else:
        print('No this selection. Picture will not be saved or you can change your selection.')