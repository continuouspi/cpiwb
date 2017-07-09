__author__ = 's1648321'
import wx

def timeforodeint():

    app = wx.App()
    t0 = 0
    tfinal = 0
    tdivide = 0
    dialog = wx.TextEntryDialog(None, "Time Start:","Text Entry", "0.0")
    dialog2 = wx.TextEntryDialog(None, "Time End:","Text Entry", "0.0")
    dialog3 = wx.TextEntryDialog(None, "Number of Times:","Text Entry", "0")
    if dialog.ShowModal() == wx.ID_OK and dialog2.ShowModal() == wx.ID_OK and dialog3.ShowModal() == wx.ID_OK:
        try:
            t0 = float(dialog.GetValue())
            tfinal = float(dialog2.GetValue())
            tdivide = int(dialog3.GetValue())
        except ValueError:
            print("Please input the correct numerical time.")

    dialog.Destroy()
    dialog2.Destroy()
    dialog3.Destroy()

    if tfinal >= t0 >= 0.0 and tdivide >= 0:
        if tdivide == 0:
            print "Time Start: {}, Time End: {}.".format(t0, tfinal)
            print("Input number of times: 0. You can only use GLIMDA solver to simulate this process.")
        else:
            print "Time Start: {}, Time End: {}, Number of Times: {}.".format(t0, tfinal, tdivide)

        return t0, tfinal, tdivide
    else:
        print("Please input the correct time.")
        return 0, 0, 0

def picturename():

    app = wx.App()
    picture_name = ''

    dialog = wx.TextEntryDialog(None, "Input the name of picture:","Text Entry", ".png")

    if dialog.ShowModal() == wx.ID_OK:
        picture_name = dialog.GetValue()

    dialog.Destroy()

    if picture_name == '.png':
        picture_name = 'fig1.png'

    return picture_name