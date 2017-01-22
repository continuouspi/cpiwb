% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = command_docs(job);

x = 0;

if (strcmp(job, 'quit') == 1)

    disp('Terminates your current session with CPiME.');

elseif (strcmp(job, 'simulate_model') == 1)

    disp('Simulates one CPi process over a time period of your choosing.');

elseif (strcmp(job, 'edit_model') == 1)

    disp('Edit the definitions of an existing CPi model inside Matlab.');

elseif (strcmp(job, 'create_model') == 1)

    disp('Create a new CPi model inside Matlab.');

elseif (strcmp(job, 'compare_models') == 1)

    disp('Simulate at most four CPi processes on a single plot.');
  
elseif (not(strcmp(job, 'help')) == 1)
    
    disp(['Command ', job, ' does not exist inside CPiME.']);

end

return;

end