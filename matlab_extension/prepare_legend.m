function [legendString, species_num] = prepare_legend(process_def, def_tokens, def_token_num) 

species = {};

% retrieve the species names to include in the simulation legend
i = 1;

while(i < def_token_num) 
    def_token = char(def_tokens(i));
    species_found = findstr(def_token, 'species ');
    if (not(isempty(species_found)))
        species_tokens = strsplit(def_token, {'species ', '('});
        species_token = species_tokens(2);
        species_in_process = findstr(process_def, char(species_token));
        if (not(isempty(species_in_process)))
            species{end + 1} = char(species_token);
        end
    end
    i = i + 1;
end

% organise the species names alphabetically from a to z
species_num = length(species);
legendString = cell(1, species_num);

species = sort(species);

for i = 1:species_num
    legendString{i} = sprintf(char(species{i}));
end