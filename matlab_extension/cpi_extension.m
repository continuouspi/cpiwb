% This Matlab script calls the Continuous Pi Workbench, CPiWB
% Author: Ross Rhodes
job = 0;

% run the script until the users requests to leave
while(not(job == 2))
    prompt = '\nPlease enter a number to perform your desired task from the list below.\n1. Simulate a CPi model\n2. Quit\n> ';
    job = input(prompt);
    
    % Select an existing .cpi file
    [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

    if (file_name == 0)
        return;
    end

    % read the file and display species and process definitions
    cpi_defs = fileread(strcat(file_path, '/', file_name));
    disp(cpi_defs);
        
    % user requests to simulate a CPi model
    if (job == 1)
        create_cpi_simulation;
    end
end

return;
