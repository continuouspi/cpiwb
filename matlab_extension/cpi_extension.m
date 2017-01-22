% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = [];
clc;

fprintf('Welcome to the Continuous Pi Calculus Matlab Extension, CPiME.\nEnter ''help'' for help.');

% run the script until the users requests to leave
while(not(strcmp(job, 'quit')))
    prompt = '\n> ';
    job = input(prompt, 's');
    
    if (strcmp(job, 'quit') == 1)
        
        return;
        
    elseif (strcmp(job, 'help') == 1)
        
        fprintf('\nThe following commands are available to execute:\n1. create_model\n2. simulate_model\n3. edit_model\n4. compare_models\n5. quit\n\nEnter ''help <command>'' for further details on a specific command.');
   
    elseif (strcmp(job(1:5), 'help ') == 1)
        
        input_length = length(job);
        command_docs(job(6:input_length));
        
    elseif (strcmp(job, 'simulate_model') == 1)
    
        simulate_single_model();
        
    elseif (strcmp(job, 'edit_model') == 1)
        
        % select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');
        
        % open an existing CPi model with write permissions
        edit([file_path, '/', file_name])
        
    elseif (strcmp(job, 'create_model') == 1)
        
        % open a new script window for the user to create definitions
        edit();
    
    elseif (strcmp(job, 'compare_models') == 1)
    
        compare_cpi_models();
    
    elseif (not(strcmp(job, '')))
        
        fprintf(['\nError: ', job, ' command not recognised. Please try again.\n']);
        
    end
end

clc;
return;
