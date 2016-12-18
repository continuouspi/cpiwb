% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = 0;

% run the script until the users requests to leave
while(not(job == 3))
    job_input = [];
    
    % request a job from the user, given a list of numbered options
    while(isempty(job_input))
        prompt = '\nPlease enter a number to perform your desired task from the list below.\n1. Simulate a CPi model\n2. Edit an existing CPi model\n3. Quit\n\n> ';
        job_input = input(prompt, 's');

        if (strcmp(job_input, '') == 1 || strcmp(job_input, 'quit') == 1 || strcmp(job_input, 'exit') == 1)
            return;
        elseif (not(isstrprop(job_input, 'digit')))
            disp(' ');
            disp('Error: The input given was nonnumeric.');
            job_input = [];
        elseif (str2num(job_input) > 3)
            disp(' ');
            disp('Error: A nonexistent job has been requested.');
            job_input = [];
        end
    end

    job = str2num(job_input);
    
    if (not(job == 3))
        % select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

        % if user selects cancel then terminate the script
        if (not(file_name == 0))

            % job one corresponds to creating a CPi simulation
            if (job == 1)
                % read the selected file and display its contents on the terminal
                cpi_defs = fileread(strcat(file_path, '/', file_name));
                disp(cpi_defs);

                create_cpi_simulation;

            % job two corresponds to editing a CPi file inside Matlab
            elseif (job == 2)
                edit([file_path, '/', file_name]);
            end
        end
    end
end

clc;
return;
