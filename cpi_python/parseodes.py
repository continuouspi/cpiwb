__author__ = 's1648321'
from ctypes import c_char_p

def parse_process(cpi_defs):  # parse all the processes in the selected cpi model

    tokens = cpi_defs.split('\n')
    process = []
    process_num = 0

    for token in tokens:
        if token[0:7] == 'process':
            pro_name = token.split()
            process.append(pro_name[1])
            process_num += 1

    return process

def parse_species(cpi_defs, process):  # parse the species in the selected process and sort them alphabetically

    tokens = cpi_defs.split('\n')
    species = []
    process_cur = ''
    species_cur = []

    for token in tokens:
        if token[0:7] == 'species':
            loc_name = token.find('(')
            species.append(token[8:loc_name])

    process_tokens = cpi_defs.split('process ')

    for process_token in process_tokens:
        if process_token[:len(process)] == process:
            process_cur = process_token

    process_curs = process_cur.split('||')

    for line_item in process_curs:
        line_item = line_item.strip()
        if line_item[:1] != '-':
            loc_species_str = line_item.find(']')

            if loc_species_str != -1:
                loc_species_end = line_item.find('(')
                species_item = line_item[loc_species_str+2:loc_species_end]

            if species_item in species and species_item not in species_cur:
                species_cur.append(species_item)

    species_cur.sort()

    return species_cur

def parse_odes(ode_convert, cpi_defs, process):  # parse the odes with the functions in shared library

    ode_convert.argtypes = [c_char_p, c_char_p]
    ode_convert.restype = c_char_p
    ode_string = ode_convert(cpi_defs, process)
    odes = []
    ode_num = 0
    initial_concentrations = []

    if ode_string:   # terminate if CPiWB encountered an error
        if ode_string == 'parse error':
            print('The CPi Workbench failed to parse your .cpi file. Please try again.')
        elif ode_string == 'process not found':
            print('The CPi Workbench failed to to find this process. Please try again.')
        elif ode_string[0:14] == 'CPiWB exception' and len(ode_string) > 14:
            print(ode_string)
        else:
            tokens = ode_string.split('\n')

            for token in tokens:  # retrieve the ODEs from the script
                if token[0:4] == 'diff':
                    odes.append(token)

            initial = tokens[0]
            start = initial.find('[')
            end = initial.find(']')

            initial_list = initial[start + 1: end]
            initial_list = initial_list.split(';')

            for item in initial_list:
                item = float(item)
                initial_concentrations.append(item)

            ode_num = len(odes)
            if ode_num == 0:
                print('The Continuous Pi Workbench did not produce any differential equations for this process. '
                      'Please try another process.')

    else:
        print('Error encountered in the CPi Workbench. Check file definitions before trying again.')

    return odes, initial_concentrations, ode_num
