__author__ = 's1648321'
import wx

def selectapro(process_list):

    app = wx.App()
    select_result = ''
    dialog = wx.SingleChoiceDialog(None, "Select a process", "Processes", process_list)
    if dialog.ShowModal() == wx.ID_OK:
        select_result = dialog.GetStringSelection()
        print "Selected process: %s" % select_result

    dialog.Destroy()
    return select_result