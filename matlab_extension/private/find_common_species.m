% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [legend_strings, separated_species, chosen_species] = ...
    find_common_species(process_def, def_tokens, def_token_num, num_processes)

separated_species = {};
chosen_species = {};
common_species = {};
legend_strings = {};
species_num = {};

legendStringList = [];

for i = 1:num_processes
    
    [legend_strings{end + 1}, species_num{end + 1}] = ...
        prepare_legend(process_def{i}, def_tokens{i}, def_token_num{i});
    
    legendStringList = [legendStringList unique(legend_strings{i})];
    
end

% identify common species between processes
legendStringSet = unique(legendStringList);

for j = 1:length(legendStringSet)
    speciesCount = 0;
    
    for k = 1:num_processes
        speciesCount = speciesCount + sum(strcmpi(legend_strings{k}, legendStringSet(j)));
    end
   
    if (speciesCount == num_processes)
        common_species{end + 1} = lower(legendStringSet{j});
    end
end

if (not(isempty(common_species)))
    % allow user to select one species from the common species list
    fprintf(['\n', num2str(length(common_species)), ...
        ' common species were found across all selected processes.', ...
        '\nChoose which ones to highlight in simulations, each separated by a space character:']);

    fprintf('\n');
    
    common_species_set = unique(common_species);

    for i = 1:length(common_species_set)
        common_species_set(i) = regexprep(common_species_set(i),'(\<[a-z])','${upper($1)}');
        fprintf(['\n', num2str(i), '. ', common_species_set{i}]);
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

            for i = 1:length(common_species_set)
                flag = flag + sum(strcmp(common_species_set{i}, strtrim(separated_species{j})));
            end

            if (not(flag))
                fprintf(['\nInvalid species ''', strtrim(separated_species{j}), ...
                    ''' entered.\nPlease try again, or enter ''cancel'' to cancel.']);
                chosen_species = [];
            end
        end
    end
end

if (isempty(chosen_species))
    chosen_species = 'all';
end

end