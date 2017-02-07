function [separated_species, chosen_species] = find_common_species(commonSpecies)

separated_species = {};
chosen_species = {};

if (not(isempty(commonSpecies)))
    % allow user to select one species from the common species list
    fprintf(['\n', num2str(length(commonSpecies)), ' common species were found across all selected processes.\nChoose which ones to highlight in simulations, each separated by a space character:']);

    fprintf('\n');
    
    commonSpeciesSet = unique(commonSpecies);

    for i = 1:length(commonSpeciesSet)
        commonSpeciesSet(i) = regexprep(commonSpeciesSet(i),'(\<[a-z])','${upper($1)}');
        fprintf(['\n', num2str(i), '. ', commonSpeciesSet{i}]);
    end

    fprintf(['\n\nAlternatively enter ''all'' for all lines to be fully visible, or enter ''cancel'' to cancel.']);

    chosen_species = [];

    while (isempty(chosen_species))
        prompt = ['\nCPiME:> '];
        chosen_species = input(prompt, 's');

        if (strcmp(strtrim(chosen_species), 'cancel'))
            return;
        elseif (strcmp(strtrim(chosen_species), 'all'))
            continue;
        end

        separated_species = strsplit(strtrim(chosen_species), ' ');

        for j = 1:length(separated_species)
            flag = 0;

            for i = 1:length(commonSpeciesSet)
                flag = flag + sum(strcmp(commonSpeciesSet{i}, strtrim(separated_species{j})));
            end

            if (not(flag))
                fprintf(['\nInvalid species ''', strtrim(separated_species{j}), ''' entered.\nPlease try again, or enter ''cancel'' to cancel.']);
                chosen_species = [];
            end
        end
    end
end

if (isempty(chosen_species))
    chosen_species = 'all';
end

end