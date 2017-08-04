__author__ = 's1648321'


def compare_species(input_comparelist):  # get the common species in comparing processes

    species_list = []
    for num in range(0, len(input_comparelist)):
        for item_num in range(0, len(input_comparelist)):
            if item_num != num:
                temp_species = list(set(input_comparelist[num]).intersection(set(input_comparelist[item_num])))
                species_list.append(temp_species)

    same_species = []
    for item in species_list:
        same_species = list(set(same_species).union(set(item)))

    if same_species:
        return same_species
    else:
        return 0

