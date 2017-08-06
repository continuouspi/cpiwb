__author__ = 's1648321'
import singleCompare
import separateCompare

class SingleCompareSolution():

    def __init__(self, same_list, separateplot_title, tol_title, tol_label, input_comparelist, tol_solution,
                 times_list):
        self.same_list = same_list
        self.tol_title = tol_title
        self.tol_label = tol_label
        self.input_comparelist = input_comparelist
        self.tol_solution = tol_solution
        self.times_list = times_list
        self.separateplot_title = separateplot_title

    def show_plot(self, select_one, plot_type):

        tol_numlist = []
        if self.same_list:
            if select_one != 'all' and select_one != '':  # if only some common species are required to be emphasized
                input_list = select_one.split()

                num_list = []
                for item in input_list:
                    if item in self.same_list:
                        num_list.append(item)
                    else:
                        print 'There is no common species named: ' + item +', it will be ignored here.'

                tol_numlist = num_list
            elif select_one == 'all':
                tol_numlist = self.same_list

        if plot_type == 'single':
            singleplot_title = 'CPi Model: ' + ' and '.join(self.tol_title)
            singleCompare.plotdiffs(singleplot_title, self.tol_label, self.input_comparelist, tol_numlist,
                                    self.tol_solution, self.times_list)
        elif plot_type == 'separate':
            separateCompare.plotdiffs(self.separateplot_title, self.input_comparelist, tol_numlist,
                                      self.tol_solution, self.times_list)
        else:
            print "Please input the correct plot type, 'single' or 'separate'."