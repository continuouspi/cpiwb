% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = simulate_single_model()

% void function - dummy variables
x = 0;

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (file_name == 0)
    return;
end

% read the selected CPi model and display on the console
cpi_defs = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', strtrim(cpi_defs)]);

% determine which process the user wishes to model from file
[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
    return;
end

% call CPiWB to construct the system of ODEs for the process
[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

% determine the start and end times of the simulation
[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

% solve the system of ODEs for the given time period
[t, Y] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

% simulate the solution set for the specified time period
create_cpi_simulation(t, Y, start_time, file_name, process_def, def_tokens, def_token_num, process);

end