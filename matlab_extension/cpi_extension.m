% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = 0;

% run the script until the users requests to leave
while(not(job == 3))
    try
        prompt = '\nPlease enter a number to perform your desired task from the list below.\n1. Simulate a CPi model\n2. Edit an existing CPi model\n3. Quit\n> ';
        job = input(prompt);
    catch
        return;
    end
    
    if (job > 3)
        disp('An invalid option has been requested. Please enter a number corresponding to the task you wish to perform.');
    elseif (not(job == 3))
        % select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

        % if user selects cancel then terminate the script
        if (file_name == 0)
            return;
        end

        if (job == 1)
            % read the selected file and display its contents on the terminal
            cpi_defs = fileread(strcat(file_path, '/', file_name));
            disp(cpi_defs);

            % job one corresponds to user requesting a model simulation
            create_cpi_simulation;
        elseif (job == 2)
            edit([file_path, '/', file_name]);
        end
    end
end

return;
