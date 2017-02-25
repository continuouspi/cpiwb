% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [t, solutions, process_names, process_definitions, definition_tokens, ...
    num_definitions, file_names] = construct_new_system_for_comparison(t, solutions, ...
    process_index, num_processes, end_time, chosen_solver)

process_names = {};
process_definitions = {};
definition_tokens = {};
num_definitions = {};
file_names = {};

% select an existing .cpi file
[new_file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(new_file_name))
    return;
end

% read the selected CPi model and produce a simulation
cpi_defs = display_definitions(new_file_name, file_path);

if (isempty(cpi_defs))
    return;
end

[new_processes, new_process_defs, new_def_tokens, new_def_token_nums] = ...
    select_multiple_processes(cpi_defs, process_index, num_processes);

if (not(length(new_processes)))
    return;
end

for m = 1:length(new_processes)
    % confirm the new process is not a duplicate from previous choices            
    j = 1;
    duplicate = 0;

    while(j <= length(process_names) && not(duplicate))
        
        if (strcmp(new_processes{m}, process_names{j}) && strcmp(new_file_name, new_file_name{j}))
        
            fprintf(['\nError: Process ', new_processes{m}, ' is already selected for modelling.']);
            duplicate = 1;
            
        end
        
        j = j + 1;
    end

    if (duplicate)
        continue;
    end
end

if (not(duplicate))

    for m = 1:length(new_processes)

        % construct and solve the system of ODEs for the selected process
        [odes, ode_num, init_tokens] = create_cpi_odes(cpi_defs, new_processes{m});

        if (ode_num)
            process_names{end + 1} = new_processes{m};
            file_names{end + 1} = new_file_name;
            process_definitions{end + 1} = new_process_defs{m};
            num_definitions{end + 1} = new_def_token_nums;
            definition_tokens{end + 1} = new_def_tokens;

            [t{end + 1}, solutions{end + 1}] = solve_cpi_odes(odes, ode_num, init_tokens, end_time, chosen_solver);

             if (isempty(t{end}))
                return;
             end
        end

        m = m + 1;
    end
end