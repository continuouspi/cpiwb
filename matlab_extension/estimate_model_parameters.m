% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = estimate_model_parameters()

% empty output
x = 0;

% select an existing .cpi file to serve as an accepted model
[example_file_name, example_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select an example .cpi file');

cpi_defs = fileread(strcat(example_file_path, '/', example_file_name));
disp(cpi_defs);

[process, example_process_def, example_tokens, example_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1)
    return;
end

[modelODEs, example_ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (example_ode_num == 0)
    return;
end

[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

[example_time, example_solutions] = solve_cpi_odes(modelODEs, example_ode_num, init_tokens, end_time);

% select an existing .cpi file to experiment on
[experimental_file_name, experimental_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select an experimental .cpi file');

cpi_defs = fileread(strcat(experimental_file_path, '/', experimental_file_name));
disp(cpi_defs);

% solve the experimental model as given to start with
[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1)
    return;
end

[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

[experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
optimal_solutions = experiment_solutions;

% identify the parameters in the experimental model
str_params = regexp(modelODEs, '[^x-](\d+(\.\d+)*)', 'match');
str_params = unique([str_params{:}]);

params = str2double(str_params);
num_params = length(params);

disp([num2str(num_params), ' parameters identified in the system of ODEs.']);

% take sum of pairwise differences in example and experimental solutions
min_ode_num = min(ode_num, example_ode_num);
min_time = min(size(example_solutions(:,1:min_ode_num),1), size(experiment_solutions(:,1:min_ode_num), 1));

% account for different number of points in experimental solutions
if (min_time == size(example_solutions(:,1:min_ode_num), 1))
    time_points = round(linspace(1, size(experiment_solutions(:,1:min_ode_num), 1), min_time));
    min_determiner = pdist(example_solutions(:,1:min_ode_num), experiment_solutions(time_points,1:min_ode_num));
else
    time_points = round(linspace(1, size(example_solutions(:,1:min_ode_num), 1), min_time));
    min_determiner = pdist(example_solutions(time_points,1:min_ode_num), experiment_solutions(:,1:min_ode_num));
end

% determine which parameters contribute significantly to model
altered_params = {};
sig_params = {};
min_dist = 1;
extremity_scalar = 2;

for i = 1:num_params
    % double the magnitude of one parameter per iteration and solve
    for l = 1:length(modelODEs)
        % num2str removes decimal in integer numbers. Make sure to keep it
        if (isempty(findstr('.', num2str(params(i)))))
            modelODEs{l} = strrep(modelODEs{l}, sprintf('%.1f', params(i)), sprintf('%.1f', 2 * params(i)));
        else
            modelODEs{l} = strrep(modelODEs{l}, num2str(params(i)), num2str(2 * params(i)));
        end
    end
        
    [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
    
    for l = 1:length(modelODEs)
        if (isempty(findstr('.', num2str(params(i)))))
            modelODEs{l} = strrep(modelODEs{l}, sprintf('%.1f', 2 * params(i)), sprintf('%.1f', params(i)));
        else
            modelODEs{l} = strrep(modelODEs{l}, num2str(2 * params(i)), num2str(params(i)));
        end
    end

    % determine if the parameter change has a significant impact
    min_ode_num = min(ode_num, example_ode_num);
    min_time = min(size(example_solutions(:,1:min_ode_num),1), size(experiment_solutions(:,1:min_ode_num), 1));
    
    if (min_time == size(example_solutions(:,1:min_ode_num), 1))
        time_points = round(linspace(1, size(experiment_solutions(:,1:min_ode_num), 1), min_time));
        curr_determiner = pdist(example_solutions(:,1:min_ode_num), experiment_solutions(time_points,1:min_ode_num));
    else
        time_points = round(linspace(1, size(example_solutions(:,1:min_ode_num), 1), min_time));
        curr_determiner = pdist(example_solutions(time_points,1:min_ode_num), experiment_solutions(:,1:min_ode_num));
    end
    
    % use 5 as a threshold value for now. Not final
    if (abs(pdist(min_determiner, curr_determiner)) >= min_dist)
        altered_params{end + 1} = linspace(0, extremity_scalar * params(i), 5);
        sig_params{end + 1} = params(i);
    end
end

% determine the number of significant parameters in the model
num_params = length(altered_params);

if (not(num_params))
    disp('No parameters of significance to the model were found.');
    return;
end

% construct all possible parameter value combinations
combs = cell(1,num_params);
[combs{end:-1:1}] = ndgrid(altered_params{end:-1:1});

combs = cat(num_params + 1, combs{:});
combs = reshape(combs, [], num_params);

combs = [sig_params{:}; combs];

num_experiments = size(combs, 1);

% begin experiments
disp(['Performing ', num2str(num_experiments - 1), ' experiments with ', num2str(num_params), ' parameters. This may take a while.']);

for k = 3:num_experiments
    for j = 1:num_params
        for l = 1:length(modelODEs)
            if (isempty(findstr('.', num2str(combs(k-1,j)))) && isempty(findstr('.', num2str(combs(k-1,j)))))
                modelODEs{l} = strrep(modelODEs{l}, sprintf('%.1f', combs(k-1,j)), sprintf('%.1f', combs(k,j)));
            elseif (isempty(findstr('.', num2str(combs(k-1,j)))))
                modelODEs{l} = strrep(modelODEs{l}, sprintf('%.1f', combs(k-1,j)), num2str(combs(k,j)));
            elseif (isempty(findstr('.', num2str(combs(k-1,j)))))
                modelODEs{l} = strrep(modelODEs{l}, num2str(combs(k-1,j)), sprintf('%.1f', combs(k,j)));
            else
                modelODEs{l} = strrep(modelODEs{l}, num2str(combs(k-1,j)), num2str(combs(k,j)));
            end
        end
    end

    [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

    min_ode_num = min(ode_num, example_ode_num);

    % to be fixed
    min_time = min(size(example_solutions(:,1:min_ode_num),1), size(experiment_solutions(:,1:min_ode_num), 1));
    
    if (min_time == size(example_solutions(:,1:min_ode_num), 1))
        time_points = round(linspace(1, size(experiment_solutions(:,1:min_ode_num), 1), min_time));
        curr_determiner = pdist(@minus, example_solutions(:,1:min_ode_num), experiment_solutions(time_points,1:min_ode_num));
    else
        time_points = round(linspace(1, size(example_solutions(:,1:min_ode_num), 1), min_time));
        curr_determiner = pdist(@minus, example_solutions(time_points,1:min_ode_num), experiment_solutions(:,1:min_ode_num));
    end

    if (abs(pdist(min_determiner - curr_determiner)) >= min_dist)
        min_determiner = curr_determiner;
        optimal_time = experiment_time;
        optimal_solutions = experiment_solutions;
    end
   
    if (mod(k-1, 100) == 0)
        disp([num2str(k - 1), ' of ', num2str(num_experiments - 1), ' experiments completed.']);
    end
end

% plot the resulting simulation against the example model
create_cpi_simulation(example_time, example_solutions, start_time, example_file_name, example_process_def, example_tokens, example_token_num);
create_cpi_simulation(optimal_time, optimal_solutions, start_time, experimental_file_name, process_def, def_tokens, def_token_num);

end