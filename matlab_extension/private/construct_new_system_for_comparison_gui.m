% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes, adapted to GUI by Luke Paul Buttigieg 

function [t, solutions, process_names, process_definitions, definition_tokens, ...
    num_definitions, file_names] = construct_new_system_for_comparison_gui(t, solutions, ...
    process_index, end_time, chosen_solver, process_map, file_map)

process_names = {};
process_definitions = {};
definition_tokens = {};
num_definitions = {};
file_names = {};

% read the selected CPi model and produce a simulation
curr_fname = strcat('fname',num2str(process_index + 1));
curr_pname = strcat('pname',num2str(process_index + 1));

cpi_defs = fileread(strcat(file_map(curr_pname), '/', file_map(curr_fname)));

if (isempty(cpi_defs))
    return;
end

% Selecting process of interest

[process_name_options, process_def_options, new_def_tokens, ...
    Inum_definitions] = retrieve_process_definitions(cpi_defs);

new_processes = {};
new_process_defs = {};

new_processes{end + 1} = process_name_options{process_map(curr_fname)};
new_process_defs{end + 1} = process_def_options{process_map(curr_fname)};

if (not(length(new_processes)))
    return;
end


    for m = 1:length(new_processes)

        % construct and solve the system of ODEs for the selected process
        [odes, ode_num, init_tokens] = create_cpi_odes(cpi_defs, new_processes{m});

        if (ode_num)
            process_names{end + 1} = new_processes{m};
            file_names{end + 1} = file_map(curr_fname);
            process_definitions{end + 1} = new_process_defs{m};
            num_definitions{end + 1} = Inum_definitions;
            definition_tokens{end + 1} = new_def_tokens;

            [t{end + 1}, solutions{end + 1}] = solve_cpi_odes_gui(odes, ode_num, init_tokens, end_time, {chosen_solver}, [], 0);

             if (isempty(t{end}))
                return;
             end
             
             fprintf('Done.');
        end

        m = m + 1;
    end