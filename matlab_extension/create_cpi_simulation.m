% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = create_cpi_simulation(t, Y, start_time, file_name, process_def, def_tokens, def_token_num)

% empty output to function
x = 0;

[legendString, species_num, start_index, end_index] = prepare_legend(t, start_time, process_def, def_tokens, def_token_num);

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

end