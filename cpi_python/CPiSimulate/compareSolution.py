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
        self.process_list = []

    def show_common_plot(self, select_one, plot_type):

        if select_one != '':

            tol_numlist = []
            if self.same_list:
                if select_one != 'all':  # if only some common species are required to be emphasized
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
        else:
            print "If you do not prefer to emphasise any species, please sue the 'show_plot' method."

    def show_plot(self, plot_type):

        tol_numlist = []
        if plot_type == 'single':
            singleplot_title = 'CPi Model: ' + ' and '.join(self.tol_title)
            singleCompare.plotdiffs(singleplot_title, self.tol_label, self.input_comparelist, tol_numlist,
                                    self.tol_solution, self.times_list)
        elif plot_type == 'separate':
            separateCompare.plotdiffs(self.separateplot_title, self.input_comparelist, tol_numlist, self.tol_solution,
                                      self.times_list)
        else:
            print "Please input the correct plot type, 'single' or 'separate'."

    def receive_process(self, process_list):

        self.process_list = process_list

    def show_solution(self, process):

        try:
            loc = self.process_list.index(process)
            solution = self.tol_solution[loc]
            return solution.T
        except ValueError:
            print 'Cannot find this process in the selected CPi model, please input the correct one.'
