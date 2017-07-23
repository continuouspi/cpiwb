__author__ = 's1648321'
import wx

def selectapro(process_list):  # determine which process the user wishes to model from file

    app = wx.App()
    select_result = ''
    dialog_pro = wx.SingleChoiceDialog(None, "Select a process", "Processes", process_list)
    if dialog_pro.ShowModal() == wx.ID_OK:
        select_result = dialog_pro.GetStringSelection()
        print "Selected process: %s" % select_result

    dialog_pro.Destroy()
    return select_result

# determine the type the user wishes to plot simulate the behaviour of all processes on a single plot,
#  to see each process on a separate plot
def selectplot():

    app = wx.App()
    select_result = ''
    plot_list = ['single plot', 'separate plot']
    dialog_pro = wx.SingleChoiceDialog(None, "Select how to plot the processes", "Types", plot_list)
    if dialog_pro.ShowModal() == wx.ID_OK:
        select_result = dialog_pro.GetStringSelection()
        print "Selected type: %s" % select_result

    dialog_pro.Destroy()
    return select_result

def selectspecies():  # tore the name of the common species needed to be compared

    app = wx.App()
    species_name = ''

    dialog = wx.TextEntryDialog(None, "Input the common species to compare, "
                                      "each separated by a space character or enter 'all' for all lines :",
                                "Text Entry", " ")

    if dialog.ShowModal() == wx.ID_OK:
        species_name = dialog.GetValue()
        print "Selected species: %s" % species_name

    dialog.Destroy()
    return species_name.strip()
