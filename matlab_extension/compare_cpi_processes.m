% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function compare_cpi_processes()

t = {};
solutions = {};
process_names = {};
process_definitions = {};
definition_tokens = {};
num_definitions = {};
file_names = {};

ode_solvers = {'ode15s (default)'; 'ode23s'; 'ode23t'; 'ode23tb'};

% determine the number of processes to be modelled. Maximum 4
num_processes = determine_num_simulations_in_comparison();

% if only one process is to be modelled, follow simulate_model command
if (not(num_processes))
    
    return;
    
elseif (num_processes == 1)
    
    simulate_single_process();
    return;
    
end
    
[selection,ok] = listdlg('Name', 'Select Solver', 'PromptString', ...
    'Please select one solver to simulate the results:', 'SelectionMode', ...
    'single', 'ListString', ode_solvers);

% if user requests to leave then return to main script
if (not(ok & length(selection)))
    return;
end

chosen_solver = ode_solvers(selection);

% determine the time frame to model for comparison
[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

i = 0;

while (i < num_processes)

    [t, solutions, new_process_names, new_process_definitions, ...
        new_definition_tokens, new_num_definitions, new_file_name] = ...
        construct_new_system_for_comparison(t, solutions, i, num_processes, ...
        end_time, chosen_solver);

    if (isempty(new_process_names))
        return;
    end
        
    for m = 1:length(new_process_names)
        process_names{end + 1} = new_process_names{m};
        process_definitions{end + 1} = new_process_definitions{m};
        definition_tokens{end + 1} = new_definition_tokens{m};
        num_definitions{end + 1} = new_num_definitions{m};
        file_names{end + 1} = new_file_name;
    end
    
    i = i + length(new_process_names);

end

% determine whether to simulate on a single or multiple plots
prompt = '\nCPiME:> ';
plot_type = [];

while (isempty(plot_type))
    
    fprintf(['\n\nDo you wish to simulate the behaviour of all processes on ' ...
    'a single plot, or do you wish to see each process on a separate ' ...
    'plot? \nEnter ''single'' for a single plot, ''separate'' for ' ...
    'separate plots, or ''cancel'' to cancel.']);

    plot_type = strtrim(input(prompt, 's'));

    if (strcmp(plot_type, 'cancel'))
        
        return;
        
    elseif (not(sum(strcmp(plot_type, {'separate', 'single'}))))
        
        fprintf(['\nError: Invalid input provided. Please enter ''single'' ', ...
            'for a single plot, or ''separate'' for separate plots.']);
        plot_type = [];
        
    end
end

if (strcmp(plot_type, 'single'))
    single_plot_comparison(process_names, process_definitions, ...
        definition_tokens, num_definitions, t, solutions, file_names, num_processes, start_time);
else 
    separate_plot_comparison(process_names, process_definitions, ...
        definition_tokens, num_definitions, t, solutions, file_names, num_processes, start_time);
end

end
