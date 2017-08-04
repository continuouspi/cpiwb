__author__ = 's1648321'

def readFileContent(filename):  # read the contents in selected file
    filename = filename.strip()
    filepath = '../models/' + filename + '.cpi'
    try:
        content = open(filepath, 'r')
        lines = content.readlines()
        char_line = ""
        for line in lines:
            char_line += '\n' + line

        return char_line
    except IOError:
        print 'Cannot open the selected file.'

