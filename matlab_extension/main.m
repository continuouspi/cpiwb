% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = [];

% clear the Matlab terminal for CPiME
clc;

fprintf('Welcome to the Continuous Pi Calculus Matlab Extension, CPiME.\nEnter ''help'' for help.');

commands = {'edit_model'; 'simulate_model'; 'help'; 'compare_models'; 'quit'};

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
        
        fprintf('\nThe following commands are available to execute:\n1. edit_model\n2. simulate_model\n3. compare_models\n4. quit\n\nEnter ''help <command>'' for further details on a specific command.');
   
    elseif (length(job) > 4 & strcmp(job(1:5), 'help ') == 1)
        
        % search command documentation for a suitable description
        % trim the redundant help from start of user input
        input_length = length(job);
        command_docs(job(6:input_length));
        
    elseif (strcmp(job, 'simulate_model') == 1)
    
        simulate_single_model();
        
    elseif (strcmp(job, 'edit_model') == 1)
        
        % open a dialog to select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');
        
        % open the chosen file inside Matlab
        edit([file_path, '/', file_name]);
    
    elseif (strcmp(job, 'compare_models') == 1)
    
        compare_cpi_models();
    
    elseif (not(strcmp(job, '')))
        
        fprintf(['\nError: ', job, ' command not recognised. Please try again.\n']);
        
        continue;
        
        i = 1;
        num_commands = length(commands);
        similar_command = 0;
        confirmation = [];
        
        while (similar_command == 0 & i <= num_commands)
            max_len = max(length(commands{i}), length(job));
            
            if (max_len == length(commands{i}))
                diff = max_len - length(job);
                job = pad(job, diff);
            else
                diff = max_len - length(commands{i});
                commands{i} = pad(job, diff);
            end
            
            if (abs(corrcoef(commands{i}, job)) > 0)
                prompt = (['\nDid you mean ', commands{i}, '? (Y/N)']);
                
                while (isempty(confirmation))
                    confirmation = strtrim(input(prompt, 's'));

                    if (confirmation == 'Y')
                        assistant = 1;
                        job = commands{i};
                    elseif (not(confirmation == 'N'))
                        fprintf('\nError: Invalid input provided. Please enter Y for yes, or N for no.');
                        confirmation = [];
                    end
                end
            end
            i = i + 1;
        end
    end
end

clc;
return;
