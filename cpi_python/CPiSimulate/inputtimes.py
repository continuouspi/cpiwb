__author__ = 's1648321'

def timeforodeint(t_start, t_final, t_divide):  # determine the start and end times of the simulation

    t0 = 0
    tfinal = 0
    tdivide = 0

    try:
        t0 = float(t_start)
        tfinal = float(t_final)
        tdivide = int(t_divide)
    except ValueError:
        print("Please input the correct numerical time.")

    if tfinal >= t0 >= 0.0:
        if tdivide <= 0:
            print "Time Start: {}, Time End: {}.".format(t0, tfinal)
            print("Input number of times: 0. You can only use GLIMDA solver to simulate this process.")
        elif tdivide > 0:
            print "Time Start: {}, Time End: {}, Number of Times: {}.".format(t0, tfinal, tdivide)

        return t0, tfinal, tdivide
    else:
        print("Please input the correct time.")
        return 0, 0, 0

