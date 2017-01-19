% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = simulate_single_model()

x = 0;

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

% read the selected CPi model and produce a simulation
cpi_defs = fileread(strcat(file_path, '/', file_name));
disp(cpi_defs);

[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1)
    return;
end

[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

[t, Y] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

create_cpi_simulation(t, Y, start_time, file_name, process_def, def_tokens, def_token_num);

disp('Done.');

end