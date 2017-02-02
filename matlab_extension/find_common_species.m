function [separated_species, chosen_species] = find_common_species(legendStringSet, legendStrings, num_models)

separated_species = {};
chosen_species = {};
commonSpecies = {};

for j = 1:length(legendStringSet)
    speciesCount = 0;
    
    for k = 1:num_models
        speciesCount = speciesCount + sum(strcmp(legendStrings{k}, legendStringSet(j)));
    end
   
    if (speciesCount == num_models)
        commonSpecies{end + 1} = legendStringSet{j};
    end
end

% allow user to select one species from the common species list
fprintf(['\n', num2str(length(commonSpecies)), ' common species were found across all selected processes.\nChoose which ones to highlight in simulations, each separated by a space character:']);

fprintf('\n');

for i = 1:length(commonSpecies)
    fprintf(['\n', num2str(i), '. ', commonSpecies{i}]);
end

fprintf(['\n\nAlternatively enter ''all'' for all lines to be fully visible, or enter ''cancel'' to cancel.']);

chosen_species = [];

while (isempty(chosen_species))
    prompt = ['\nCPiME:> '];
    chosen_species = input(prompt, 's');
    
    if (strcmp(chosen_species, 'cancel'))
        return;
    elseif (strcmp(chosen_species, 'all'))
        continue;
    end
    
    separated_species = strsplit(strtrim(chosen_species), ' ');
    
    for j = 1:length(separated_species)
        flag = 0;

        for i = 1:length(commonSpecies)
            flag = flag + sum(strcmp(commonSpecies{i}, strtrim(separated_species{j})));
        end

        if (not(flag))
            fprintf(['\nInvalid species ''', strtrim(separated_species{j}), ''' entered.\nPlease try again, or enter ''cancel'' to cancel.']);
            chosen_species = [];
        end
    end
end

end