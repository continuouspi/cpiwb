__author__ = 's1648321'
import wx
import os

def getFilePath():  # select a cpi file from locals

    app = wx.App()
    file_path = ''
    filename = ''
    wildcard = "cpi Files (*.cpi)|*.cpi|" "All files (*.*)|*.*"
    dialog = wx.FileDialog(None, "Choose a cpi file", os.getcwd(), "", wildcard, wx.OPEN)
    if dialog.ShowModal() == wx.ID_OK:
        file_path = dialog.GetPath()
        if file_path:
            loc_number = file_path.rfind('/')
            filename_number = file_path.rfind('.')
            filename = file_path[loc_number + 1:filename_number]
            print "Selected cpi file: %s" % filename

    dialog.Destroy()
    return file_path, filename



def readFileContent(filepath):  # read the contents in selected file

    try:
        content = open(filepath, 'r')
        lines = content.readlines()
        char_line = ""
        for line in lines:
            char_line += '\n' + line

        return char_line
    except IOError:
        print 'Cannot open the selected file.'
