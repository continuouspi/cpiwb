% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
% description: A user can simulate a single CPi definition using this function.
% After selecting a CPi file and displaying the definition on screen, the
% function creates the Ordinary Differential Equations (ODEs) 
% representing the definition, and solves them. The function then plots the
% solved ODEs. This function is called from main Command Line Interface
% function, defined in cpime. 

function simulate_single_process()

chosen_solvers = {};

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(file_name))
    return;
end

definitions = display_definitions(file_name, file_path);

if(isempty(definitions))
    return;
end

% determine which process the user wishes to model from file
[process_name, process_def, definition_tokens, num_definitions] = ...
    select_single_process(definitions);

if (sum(strcmp(process_name, {'cancel', ''})))
    return;
end

% call CPiWB to construct the system of ODEs for the process
fprintf('\n\nConstructing the ODEs ... ');
[odes, ode_num, initial_concentrations] = create_cpi_odes(definitions, process_name);

if (not(ode_num))
    return;
end

fprintf('Done.');

% determine the start and end times of the simulation
[start_time, end_time] = retrieve_simulation_times();

if (not(end_time))
    return;
end

% request, from the user, the process to model
ode_solvers = {'ode15s (default)'; 'ode23s'; 'ode23t'; 'ode23tb'};
[selection,ok] = listdlg('Name', 'Select Solver', 'PromptString', ...
    'Please select at least one solver to simulate the results', ...
    'SelectionMode', 'multiple', 'ListString', ode_solvers);

% if user requests to leave then return to main script
if (not(ok & length(selection)))
    return;
end

for i = 1:length(selection)
    ode_name = strsplit(ode_solvers{selection(i)}, ' ');
    chosen_solvers{end + 1} = ode_name{1};
end

% setup the legend for the simulation
[legend_strings, species_num] = prepare_legend(process_def, ...
    definition_tokens, num_definitions);

fprintf('\nSolving the system ... ');
[t, Y] = solve_cpi_odes(odes, ode_num, initial_concentrations, end_time, ...
    chosen_solvers, legend_strings);

if (isempty(t))
    return;
end
        
% simulate the solution set for the specified time period
create_process_simulation(t, Y, start_time, file_name, ...
    process_name, chosen_solvers, legend_strings, species_num);

end