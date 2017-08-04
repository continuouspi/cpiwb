__author__ = 's1648321'

import matplotlib.pyplot as plt


def plotdiffs(filetitle, label_list, input_comparelist, num_list, solution, times_list):

    plt.style.use('ggplot')
    fig = plt.figure(figsize=(12, 6))
    ax1 = fig.add_axes([0.1, 0.1, 0.7, 0.8])
    line_add = []

    if num_list:  # if there are common species and has to emphasize them
        for num1 in range(0, len(solution)):
            tempsolution = solution[num1]
            temptime = times_list[num1]
            tempnum = input_comparelist[num1]
            for num_each in range(0, len(tempsolution)):
                if tempnum[num_each] in num_list:
                    line_temp, = ax1.plot(temptime, tempsolution[num_each])
                else:
                    line_temp, = ax1.plot(temptime, tempsolution[num_each], linestyle='--')
                line_add.append(line_temp)

    else:
        for num1 in range(0, len(solution)):
            tempsolution = solution[num1]
            temptime = times_list[num1]
            for num_each in range(0, len(tempsolution)):
                line_temp, = ax1.plot(temptime, tempsolution[num_each])
                line_add.append(line_temp)

    leg = ax1.legend(label_list, bbox_to_anchor=(1.02, 0.4), loc=6)
    ax1.set_xlabel('Time (seconds)')
    ax1.set_ylabel('Concentration')
    ax1.set_title(filetitle)

    line_leg = dict()
    for legline, origline in zip(leg.get_lines(), line_add):
        legline.set_picker(5)
        line_leg[legline] = origline

    def on_pick(event):   # add pick event and the style of label and lines cna be changed by mouse click
        origline = line_leg[event.artist]

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

