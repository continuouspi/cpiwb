% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function parameter_scan()

selected_params = {};
min_values = {};
max_values = {};
experiment_nums = {};
experimental_values = {};
confirmation = [];
t = {};
solutions = {};
longest_param = 0;
longest_min_value = 0;
longest_max_value = 0;

ode_solvers = {'ode15s (default)'; 'ode23s'; 'ode23t'; 'ode23tb'};

% select an existing .cpi file with parameters to estimate
[chosen_file_name, file_path, ~] = ...
    uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(chosen_file_name))
    return;
end

definitions = display_definitions(chosen_file_name, file_path);

if(isempty(definitions))
    return;
end

% determine which process the user wishes to model from file
[chosen_process, chosen_process_def, chosen_def_tokens, ...
    chosen_def_token_num] = select_single_process(definitions);

if (sum(strcmp(chosen_process, {'cancel', ''})))
    return;
end

% determine the start and end times of the simulation
[start_time, end_time] = retrieve_simulation_times();

if (not(end_time))
    return;
end

% request, from the user, the process to model
[selection,ok] = listdlg('Name', 'Select Solver', 'PromptString', ...
    'Please select one solver to simulate the results', ...
    'SelectionMode', 'single', 'ListString', ode_solvers);

% if user requests to leave then return to main script
if (not(ok & length(selection)))
    return;
end

chosen_solver = ode_solvers(selection);

% select the parameters for experimentation
[params, num_params] = select_parameters(chosen_def_tokens, chosen_def_token_num);

if (not(num_params))
    return;
end
   
% determine the range of values to substitute for each selected parameter
for i = 1:num_params
    [new_min_value, new_max_value, new_experiment_num] = retrieve_experiment_info(params{i}, i);
    
    if (new_min_value < 0 || new_max_value < 0 || new_experiment_num < 0)
        return;
    else
        min_values{end + 1} = new_min_value;
        max_values{end + 1} = new_max_value;
        experiment_nums{end + 1} = new_experiment_num;
    end
end

for i = 1:num_params
    if (length(params{i}{1}) > longest_param)
        longest_param = length(params{i}{1});
    end
    
    if (length(num2str(min_values{i})) > longest_min_value)
        longest_min_value = length(num2str(min_values{i}));
    end
    
    if (length(num2str(max_values{i})) > longest_max_value)
        longest_max_value = length(num2str(max_values{i}));
    end
end

if (length('parameters') > longest_param)
    longest_param = length('parameters');
end

if (length('min values') > longest_min_value)
    longest_min_value = length('min values');
end

if (length('max_values') > longest_max_value)
    longest_max_value = length('max values');
end

fprintf('\nThe experiment details are as follows:\n');
fprintf(['\nParameters', blanks(longest_param - length('params'))]);
fprintf(['\tMin values', blanks(longest_min_value - length('min values'))]);
fprintf(['\tMax values', blanks(longest_max_value - length('max values'))]);
fprintf('\t# values');

for i = 1:num_params
    fprintf(['\n', params{i}{1}, blanks(longest_param - length(params{i}{1}))]);
    
    fprintf(['\t', num2str(min_values{i}), blanks(longest_min_value - ...
        length(num2str(min_values{i})))]);
    
    fprintf(['\t', num2str(max_values{i}), blanks(longest_max_value - ...
        length(num2str(max_values{i})))]);
    
    fprintf(['\t', num2str(experiment_nums{i})]);
end

prompt = '\n\nDo you wish to proceed with this experiment? (Y/n)\n\nCPiWB:> ';

while (isempty(confirmation))
    confirmation = strtrim(input(prompt, 's'));

    if (confirmation == 'n')
        return;
    elseif (not(confirmation == 'Y'))
        fprintf('\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
        confirmation = [];
    end
end

% generate the values to substitute into each selected parameter
for i = 1:num_params
    experimental_values{end + 1} = linspace(min_values{i}, max_values{i}, experiment_nums{i});
    param_digits = regexp(params{i}{1}, '(\d+(\.\d+)*(E(-)?)?(\d)*)', 'match');
    selected_params{end + 1} = str2num(param_digits{1});
end

% construct all possible parameter value combinations
combs = cell(1,num_params);
[combs{end:-1:1}] = ndgrid(experimental_values{end:-1:1});

combs = cat(num_params + 1, combs{:});
combs = reshape(combs, [], num_params);
combs = [selected_params{:}; combs];

num_experiments = size(combs, 1) - 1;

% run the experiments
fprintf(['\nPerforming ', num2str(num_experiments), ' experiments with ', ...
    num2str(num_params), ' experimental parameters. This may take a while.']);

for k = 2:(num_experiments + 1)
    for j = 1:num_params
        for l = 1:chosen_def_token_num
            
            % num2str removes decimal components in integer values
            % make sure to retain these components for easier substitution
            if (isempty(strfind(num2str(combs(k-1,j)), '.')) && ...
                    isempty(strfind(num2str(combs(k,j)), '.')))
                
                chosen_def_tokens{l} = strrep(chosen_def_tokens{l}, ...
                    sprintf('%.1f', combs(k-1,j)), sprintf('%.1f', combs(k,j)));
                
            elseif (isempty(strfind(num2str(combs(k-1,j)), '.')))
                
                chosen_def_tokens{l} = strrep(chosen_def_tokens{l}, ...
                    sprintf('%.1f', combs(k-1,j)), num2str(combs(k,j)));
                
            elseif (isempty(strfind(num2str(combs(k,j)), '.')))
                
                chosen_def_tokens{l} = strrep(chosen_def_tokens{l}, ...
                    num2str(combs(k-1,j)), sprintf('%.1f', combs(k,j)));
                
            else
                
                chosen_def_tokens{l} = strrep(chosen_def_tokens{l}, ...
                    num2str(combs(k-1,j)), num2str(combs(k,j)));
                
            end
        end
    end
    
    % redefine the CPi file with the new substitution values
    definitions = strjoin(chosen_def_tokens, ';');
    
    % call CPiWB to construct the system of ODEs for the process
    [odes, ode_num, init_tokens] = create_cpi_odes(definitions, chosen_process);
    
    [t{end + 1}, solutions{end + 1}] = solve_cpi_odes(odes, ode_num, ...
        init_tokens, end_time, chosen_solver);
end

% plot the results
experiment_plots(chosen_process_def, chosen_def_tokens, chosen_def_token_num, ...
    t, solutions, chosen_file_name, num_experiments, start_time, chosen_process);

end