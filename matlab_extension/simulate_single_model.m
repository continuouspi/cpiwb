% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function simulate_single_model()

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (file_name == 0)
    return;
end

% read the selected CPi model and display on the console
cpi_defs = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', strtrim(cpi_defs)]);

% determine which process the user wishes to model from file
[process, process_def, def_tokens, def_token_num] = retrieve_single_process(cpi_defs);

if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
    return;
end

% call CPiWB to construct the system of ODEs for the process
fprintf('\n\nConstructing the ODEs ... ');
[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

fprintf('Done.');

% determine the start and end times of the simulation
[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

fprintf('\nDo you wish to solve only with the default solver or all four solvers?');
fprintf('\nEnter ''default'' for default, ''all'' for all solvers, or ''cancel'' to cancel.');
prompt = '\nCPiME:> ';
solver_input = [];

while(isempty(solver_input))
    solver_input = strtrim(input(prompt, 's'));

    if (strcmp(solver_input, '') || strcmp(solver_input, 'cancel'))
        return;
    elseif(strcmp(solver_input, 'default'))
        % solve the system of ODEs for the given time period
        fprintf('\nSolving the system with default solver ... ');
        [t, Y] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time, 'default');

        if (isempty(t))
            return;
        end
        
        fprintf('Done.');
        
        % simulate the solution set for the specified time period
        create_cpi_simulation(t, Y, start_time, file_name, process_def, def_tokens, def_token_num, process);
        
    elseif(strcmp(solver_input, 'all'))
        
        % solve the system of ODEs for the given time period
        fprintf('\nSolving the system with all four solvers ... ');
        [t, Y] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time, 'all');

        if (isempty(t))
            return;
        end
        
        Y
        
        fprintf('Done.');
        
        solver_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, start_time);
        
    else
        end_time = str2num(solver_input);
    end
end

end