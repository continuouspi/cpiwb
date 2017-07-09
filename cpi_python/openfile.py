__author__ = 's1648321'
import wx
import os

def getFilePath():

    app = wx.App()
    file_path = ''
    filename = ''
    wildcard = "cpi Files (*.cpi)|*.cpi|" "All files (*.*)|*.*"
    dialog = wx.FileDialog(None, "Choose a cpi file", os.getcwd(), "", wildcard, wx.OPEN)
    if dialog.ShowModal() == wx.ID_OK:
        file_path = dialog.GetPath()
        if file_path:
            loc_number = file_path.rfind('/')
            filename = file_path[loc_number + 1:].split('.')[0]
            print "Selected cpi file: %s" % filename

    dialog.Destroy()
    return file_path, filename



def readFileContent(filepath):

    content = open(filepath, 'r')
    lines = content.readlines()
    char_line = ""
    for line in lines:
        char_line += '\n' + line

    return char_line
