% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = command_docs(job);

% void function - dummy variable
x = 0;

if (strcmp(job, 'quit') == 1)

    fprint('\nTerminates your current session with CPiME.');
    
elseif (strcmp(job, 'view_odes') == 1)
    
    fprintf('\nBuilds and displays a system of first-order ODEs for a given CPi model, which may be saved.');

elseif (strcmp(job, 'simulate_process') == 1)

    fprintf('\nSimulates one CPi process over a time period of your choosing.');

elseif (strcmp(job, 'edit_model') == 1)

    fprintf('\nEdit the definitions of an existing CPi model inside Matlab.');

elseif (strcmp(job, 'compare_processes') == 1)

    fprintf('\nSimulate at most four CPi processes on a single plot.');
    
elseif (strcmp(job, 'run_parameter_experiment') == 1)
    
    fprintf('\nRun a series of simulations for varying values of one parameter in a CPi model.');
  
elseif (not(strcmp(job, 'help')) == 1)
    
    fprintf(['\nCommand ', job, ' does not exist inside CPiME.']);

end

return;

end