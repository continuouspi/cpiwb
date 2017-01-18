function [legendString, species_num, start_index, end_index] = prepare_legend(t, start_time, process_def, def_tokens, def_token_num) 

species = {};
start_index = 0;
end_index = 0;

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

species_num = length(species);
legendString = cell(1, species_num);

species = sort(species);

for i = 1:species_num
    legendString{i} = sprintf(char(species{i}));
end

% simulate the behaviour of the system
start_index = 0;
end_index = length(t);

i = 1;

while (start_index == 0 & i <= end_index)
    if (start_time <= t(i))
        start_index = i;
    else
        i = i + 1;
    end
end