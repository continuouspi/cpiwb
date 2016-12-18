% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
job = 0;

% run the script until the users requests to leave
while(not(job == 2))
    prompt = '\nPlease enter a number to perform your desired task from the list below.\n1. Simulate a CPi model\n2. Quit\n> ';
    job = input(prompt);
    
    if (not(job == 2))
        % select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

        % if user selects cancel then terminate the script
        if (file_name == 0)
            return;
        end

        % read the selected file and display its contents on the terminal
        cpi_defs = fileread(strcat(file_path, '/', file_name));
        disp(cpi_defs);

        % job one corresponds to user requesting a model simulation
        create_cpi_simulation;
    end
end

return;
