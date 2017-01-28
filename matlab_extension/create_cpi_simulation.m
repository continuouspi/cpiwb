% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = create_cpi_simulation(t, Y, start_time, file_name, process_def, def_tokens, def_token_num, process, species)

% void function - dummy variable
x = 0;

% setup the legend for the simulation
[legendString, species_num] = prepare_legend(process_def, def_tokens, def_token_num);

% ODE solvers start with time 0. Find index for the user's start time
start_index = -1;
end_index = length(t);

i = 1;

while (start_index == -1 & i < end_index)
    if (start_time <= t(i + 1) & t(i) <= start_time)
        start_index = i;
    end
    
    i = i + 1;
end

% use the file's name to create a plot header
filename_tokens = strsplit(file_name, '.cpi');
model_name = strrep(filename_tokens(1),'_',' ');
model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');

% plot the simulation, and construct a figure around it
figure('Name',char(model_name),'NumberTitle','on');
plot(t(start_index:end_index), Y(start_index:end_index, 1:species_num), '-o');
title([model_name, process]);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend('show');
legend(legendString, 'Location', 'EastOutside');

end