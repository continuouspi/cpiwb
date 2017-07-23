__author__ = 's1648321'

import matplotlib.pyplot as plt
from matplotlib import gridspec
import inputtimes


def plotdiffs(filetitle, tol_species_list, num_list, solution, times_list, is_save):

    plt.style.use('ggplot')
    num_process = len(solution)

    if num_process == 2:  # the size of figure panel should be changed according to the different number of processes
        fig = plt.figure(figsize=(18, 6))
        gs = gridspec.GridSpec(1, 4, width_ratios=[5, 2, 5, 1])
        ax1 = fig.add_subplot(gs[0])
        ax2 = fig.add_subplot(gs[2])

        ax_list = [ax1, ax2]
    else:
        fig = plt.figure(figsize=(18, 12))

        gs = gridspec.GridSpec(3, 4, height_ratios=[5, 1, 5], width_ratios=[5, 2, 5, 1])
        ax1 = fig.add_subplot(gs[0])
        ax2 = fig.add_subplot(gs[2])
        ax3 = fig.add_subplot(gs[8])

        ax_list = [ax1, ax2, ax3]

        if num_process == 4:
            ax4 = fig.add_subplot(gs[10])
            ax_list.append(ax4)

    legend_add = [[], [], [], []]
    leg_list = []

    if num_list:  # if there are common species and has to emphasize them
        for num in range(0, num_process):
            tempsolution = solution[num]
            temptime = times_list[num]
            tempnum = tol_species_list[num]
            for num_each in range(0, len(tempsolution)):
                if tempnum[num_each] in num_list:
                    line_temp, = ax_list[num].plot(temptime, tempsolution[num_each])
                else:
                    line_temp, = ax_list[num].plot(temptime, tempsolution[num_each], linestyle='--')
                legend_add[num].append(line_temp)

    else:
        for num in range(0, num_process):
            for line in solution[num]:
                legend_temp, = ax_list[num].plot(times_list[num], line, picker=5)
                legend_add[num].append(legend_temp)

    for num in range(0, num_process):
        leg = ax_list[num].legend(tol_species_list[num], bbox_to_anchor=(1.02, 0.4), loc=6)
        ax_list[num].set_xlabel('Time (seconds)')
        ax_list[num].set_ylabel('Concentration')
        ax_list[num].set_title(filetitle[num])
        leg_list.append(leg)

    line_list = [{}, {}, {}, {}]

    for num in range(0, num_process):
        for legline, origline in zip(leg_list[num].get_lines(), legend_add[num]):
            legline.set_picker(5)
            line_list[num][legline] = origline

    def on_pick(event):  # add pick event and the style of label and lines cna be changed by mouse click

        for lined in line_list:
            if event.artist in lined.keys():
                origline = lined[event.artist]

                if origline.get_linestyle() == '-':
                    event.artist.set_linestyle('--')
                    origline.set_linestyle('--')
                elif origline.get_linestyle() == '--':
                    event.artist.set_linestyle('-.')
                    origline.set_linestyle('-.')
                elif origline.get_linestyle() == '-.':
                    event.artist.set_linestyle(':')
                    origline.set_linestyle(':')
                elif origline.get_linestyle() == ':':
                    event.artist.set_linestyle(' ')
                    origline.set_linestyle(' ')
                else:
                    event.artist.set_linestyle('-')
                    origline.set_linestyle('-')

        fig.canvas.draw()

    fig.canvas.mpl_connect('pick_event', on_pick)

    if is_save == 'Yes':
        save_name = inputtimes.picturename()
        plt.savefig(save_name, dpi=300)
    elif is_save == 'No':
        print('Picture will not be saved or you can change your selection.')
    else:
        print('No this selection. Picture will not be saved or you can change your selection.')


