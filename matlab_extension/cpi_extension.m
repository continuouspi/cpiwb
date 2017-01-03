% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = [];
clc;

fprintf('Welcome to the Matlab extension for Continuous Pi Calculus.\nEnter ''help'' for help.');

% run the script until the users requests to leave
while(not(strcmp(job, 'quit')))
    prompt = '\n> ';
    job = input(prompt, 's');
    
    if (strcmp(job, 'quit') == 1)
        return;
    elseif (strcmp(job, 'help') == 1)
        fprintf('\nThe following commands are available to execute:\n1. create_model\n2. simulate_model\n3. edit_model\n4. estimate_model_parameters\n5. quit');
    elseif (strcmp(job, 'simulate_model') == 1 || strcmp(job, 'edit_model') == 1)
        % select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

        if (not(file_name == 0) & (strcmp(job, 'simulate_model') == 1))
            % read the selected CPi model and produce a simulation
            cpi_defs = fileread(strcat(file_path, '/', file_name));
            disp(cpi_defs);
            retrieve_process;
            create_cpi_odes;
            retrieve_simulation_times;
            solve_cpi_odes;
            create_cpi_simulation;
            disp('Done.');
        elseif (not(file_name == 0) & (strcmp(job, 'edit_model') == 1))
            % open an existing CPi model with write permissions
            edit([file_path, '/', file_name])
        end
    elseif (strcmp(job, 'create_model') == 1)
        % open a new script window for the user to create definitions
        edit();
    elseif (strcmp(job, 'estimate_model_parameters') == 1)
        estimate_model_parameters;
    else
        fprintf(['\nError: ', job, ' command not recognised. Please try again.\n']);
    end
end

clc;
return;
