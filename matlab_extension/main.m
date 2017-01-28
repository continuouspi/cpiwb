% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = '';

% clear the Matlab terminal for CPiME
clc;

fprintf('Welcome to the Continuous Pi Calculus Matlab Extension, CPiME.\nEnter ''help'' for help.');

commands = {'edit_model'; 'view_odes'; 'run_parameter_experiment'; 'simulate_model'; 'help'; 'compare_models'; 'quit'};

assistant = 0;

% run the script until the user requests to leave
% trim initial and trailing whitespace from user input
while(not(strcmp(job, 'quit')))
    
    if (assistant == 0)
        prompt = '\nCPiME:> ';
        job = strtrim(input(prompt, 's'));
    else
        assistant = 0;
    end
    
    if (strcmp(job, 'quit') == 1)
        
        return;
        
    elseif (strcmp(job, 'help') == 1)
        
        fprintf('\nThe following commands are available to execute:\n1. edit_model\n2. view_odes\n3. simulate_model\n4. compare_models\n5. run_parameter_experiment\n6. quit\n\nEnter ''help <command>'' for further details on a specific command.');
   
    elseif (length(job) > 4 & strcmp(job(1:5), 'help ') == 1)
        
        % search command documentation for a suitable description
        % trim the redundant help from start of user input
        input_length = length(job);
        command_docs(job(6:input_length));
        
    elseif (strcmp(job, 'view_odes') == 1)
        
        view_odes();
        
    elseif (strcmp(job, 'simulate_model') == 1)
    
        simulate_single_model();
        
    elseif (strcmp(job, 'edit_model') == 1)
        
        % open a dialog to select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');
        
        % open the chosen file inside Matlab
        edit([file_path, '/', file_name]);
    
    elseif (strcmp(job, 'compare_models') == 1)
    
        compare_cpi_models();
        
    elseif (strcmp(job, 'run_parameter_experiment') == 1)
        
        parameter_experiment();
    
    elseif (not(strcmp(job, '')))
        
        fprintf(['\nError: ', job, ' command not recognised.']);
        
        i = 1;
        num_commands = length(commands);
        best_match = 'help';
        best_coef = 10000000000;
        confirmation = [];
        
        % determine which existing command best matches the user's input
        while (i <= num_commands)
            max_len = max(length(commands{i}), length(job));
            
            if (max_len == length(commands{i}))
                trimmed_command = commands{i}(1:length(job));
                trimmed_job = job;
            else
                trimmed_command = commands{i};
                trimmed_job = job(1:length(commands{i}));
            end
            
            if (abs(sum(double(trimmed_command) - double(trimmed_job))) < best_coef)
                best_coef = abs(sum(double(trimmed_command) - double(trimmed_job)));
                best_match = commands{i};
            end
            
            i = i + 1;
        end
        
        % suggest a command the user likely wanted to execute
        prompt = (['\nDid you mean ', best_match, '? (Y/n)\n> ']);

        while (isempty(confirmation))
            confirmation = strtrim(input(prompt, 's'));

            if (confirmation == 'Y')
                assistant = 1;
                job = commands{i};
            elseif (not(confirmation == 'n'))
                fprintf('\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
                confirmation = [];
            end
        end
    end
end

clc;
return;
