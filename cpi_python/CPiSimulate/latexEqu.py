__author__ = 's1648321'
import solveodes

def convert_latex(odes):  # convert the odes and print them in LaTeX format

    diff_odes, name_copy = solveodes.preodes(odes)
    name_list = name_copy[:-4].split(',')
    latex_list = []

    for name in name_list:
        num = name_list.index(name)
        latex_pro = '\\frac{\mathit{d}[' + name + ']}{\mathit{d}t} = '
        add_list = diff_odes[num].split('+')

        final_fol = []
        for add_item in add_list:
            mul_list = add_item.split('*')
            fol_list = []

            for item in mul_list:
                item = item.strip()
                if item in name_list:
                    fol_list.append('['+item+']*')
                elif item == '-1.0':
                    fol_list.append('-')
                else:
                    fol_list.append(item+'*')

            final_item = ''.join(fol_list)
            final_fol.append(final_item[:-1])

        latex_fol = ''
        for link_add in final_fol:
            if not link_add[0] == '-':
                latex_fol += '+'+link_add
            else:
                latex_fol += link_add

        if latex_fol[0] == '+':
            latex_fol = latex_fol[1:]

        latex_list.append(latex_pro + latex_fol + '\n')

    return latex_list
