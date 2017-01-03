% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

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

filename_tokens = strsplit(file_name, '.cpi');
model_name = strrep(filename_tokens(1),'_',' ');

model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');

figure('Name',char(model_name),'NumberTitle','on');
plot(t(start_index:end_index), Y(start_index:end_index, 1:species_num), '-o');
title(model_name);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend('show');
legend(legendString, 'Location', 'EastOutside');

return;