% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = parameter_experiment()

% empty output
x = 0;

selected_params = {};
min_values = {};
max_values = {};
experiment_nums = {};
experimental_values = {};
process = {};
process_def = {};
def_tokens = {};
def_token_num = {};
file_name = {};
confirmation = [];
t = {};
Y = {};

% select an existing .cpi file with parameters to estimate
[chosen_file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(chosen_file_name))
    return;
end

cpi_defs = fileread(strcat(file_path, '/', chosen_file_name));
fprintf(['\n', cpi_defs]);

% determine which process the user wishes to model from file
[chosen_process, chosen_process_def, chosen_def_tokens, chosen_def_token_num] = retrieve_single_process(cpi_defs);

if (sum(strcmp(chosen_process, {'cancel', ''})))
    return;
end

% determine the start and end times of the simulation
[start_time, end_time] = retrieve_simulation_times();

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

fprintf('\nThe experiment details are as follows:\nParams\tMin values\tMax values\tNumber of experiments\n');

for i = 1:num_params
    fprintf(['\n', params{i}{1}, '\t', num2str(min_values{i}), '\t', num2str(max_values{i}), '\t', num2str(experiment_nums{i})]);
end

prompt = ['\n\nDo you wish to proceed with this experiment? (Y/n)\nCPiWB:> '];

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
fprintf(['\nPerforming ', num2str(num_experiments), ' experiments with ', num2str(num_params), ' experimental parameters. This may take a while.']);

for k = 2:(num_experiments + 1)
    for j = 1:num_params
        for l = 1:chosen_def_token_num
            
            % num2str removes decimal components in integer values
            % make sure to retain these components for easier substitution
            if (isempty(findstr('.', num2str(combs(k-1,j)))) && isempty(findstr('.', num2str(combs(k-1,j)))))
                
                def_tokens{l} = strrep(chosen_def_tokens{l}, sprintf('%.1f', combs(k-1,j)), sprintf('%.1f', combs(k,j)));
                
            elseif (isempty(findstr('.', num2str(combs(k-1,j)))))
                
                def_tokens{l} = strrep(chosen_def_tokens{l}, sprintf('%.1f', combs(k-1,j)), num2str(combs(k,j)));
                
            elseif (isempty(findstr('.', num2str(combs(k-1,j)))))
                
                def_tokens{l} = strrep(chosen_def_tokens{l}, num2str(combs(k-1,j)), sprintf('%.1f', combs(k,j)));
                
            else
                
                def_tokens{l} = strrep(chosen_def_tokens{l}, num2str(combs(k-1,j)), num2str(combs(k,j)));
                
            end
        end
    end
    
    % redefine the CPi file with the new substitution values
    cpi_defs = strjoin(chosen_def_tokens, ';');
    
    % call CPiWB to construct the system of ODEs for the process
    [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, chosen_process);
    
    [t{end + 1}, Y{end + 1}] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
    process{end + 1} = [chosen_process, ' ', num2str(k-1)];

    file_name{end + 1} = [chosen_file_name, '_experiment_', num2str(k-1)];
   
    if (mod(k-1, 100) == 0)
        fprintf(['\n\n', num2str(k - 1), ' of ', num2str(num_experiments), ' experiments completed.']);
    end
end

% plot the results
experiment_plots(chosen_process_def, chosen_def_tokens, chosen_def_token_num, t, Y, file_name, num_experiments, start_time, process);

end