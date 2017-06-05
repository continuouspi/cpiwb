% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function command_docs(job)
% input 'job': the command the user wishes to receive details about

if (strcmp(job, 'quit'))

    fprintf('\nTerminates your current session with CPiME.');
    
elseif (strcmp(job, 'view_odes'))
    
    fprintf(['\nBuilds and displays a system of first-order ODEs ', ...
        'for a CPi process, which may be saved in a text file.']);

elseif (strcmp(job, 'simulate_process'))

    fprintf('\nSimulates one CPi process over a time period of your choosing.');
    
elseif (strcmp(job, 'analyse_solutions'))
    
    fprintf(['\nAnalyse solutions to systems of first-order ODEs using ', ...
        'Logic of Behaviour in Context expressions.']);

elseif (strcmp(job, 'edit_model'))

    fprintf('\nEdit the definitions of an existing CPi model inside Matlab.');

elseif (strcmp(job, 'compare_processes'))

    fprintf('\nSimulate at most four CPi processes under a single window.');
    
elseif (strcmp(job, 'parameter_scans'))
    
    fprintf(['\nSelect at least one parameter and plot a series of ' ...
        'simulations for different values.']);
  
elseif (not(strcmp(job, 'help')))
    
    fprintf(['\nCommand ''', job, ''' is not recognised.']);

end

end