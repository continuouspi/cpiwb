% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = estimate_model_parameters()

% empty output
x = 0;

% select an existing .cpi file to serve as a comparison
[example_file_name, example_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select an example .cpi file');

cpi_defs = fileread(strcat(example_file_path, '/', example_file_name));
disp(cpi_defs);

[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1)
    return;
end

[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

[example_time, example_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

% select an existing .cpi file with parameters to estimate
[experimental_file_name, experimental_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select an experimental .cpi file');

cpi_defs = fileread(strcat(experimental_file_path, '/', experimental_file_name));

% identify the parameters
silent_actions = strfind(cpi_defs, 'tau');
affinities = strfind(cpi_defs, '@');

num_params = length(silent_actions) + length(affinities);

params = [];
param_indices = [];

disp(cpi_defs);
disp([num2str(num_params), ' parameters identified.']);

silent_action_tokens = strsplit(cpi_defs, {'tau<','>.'});
affinity_tokens = strsplit(cpi_defs, {'@',',','}'});

action_tokens = [silent_action_tokens affinity_tokens];

index = 0;

for i = 1:length(silent_action_tokens)
    if (not(isempty(str2num(silent_action_tokens{i}))))
        index = index + 1;
        params(index) = str2num(silent_action_tokens{i});
        param_indices(index) = i;
    end
end

for i = 1:length(affinity_tokens)
    if (not(isempty(str2num(affinity_tokens{i}))))
        index = index + 1;
        params(index) = str2num(affinity_tokens{i});
        param_indices(index) = i + length(silent_actions);
    end
end

% begin experimenting with parameter values
[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1)
    return;
end

[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

[experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

% take sum of pairwise differences in example and experimental solutions
min_determiner = abs(sum(example_solutions(:)) - sum(experiment_solutions(:)));
curr_determiner = 0;
optimal_time = experiment_time;
optimal_solutions = experiment_solutions;

outer_diff = 0;
step = 1;

disp('Running experiments ... they may take a while.');
while (outer_diff <= 2)
    for k = 1:num_params
        inner_diff = step;
        
        % increment parameter i by the set outer difference
        old_action_token = action_tokens(param_indices(k));
        new_action_token = strrep(old_action_token, num2str(params(k)), num2str(params(k) + outer_diff));
        cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
        cpi_defs = cpi_defs{:};

        for j = 1:num_params
            if (not(k == j || params(k) == 0))
                % increment parameter j by the set inner difference
                old_action_token = action_tokens(param_indices(j));
                new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) + inner_diff));
                cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                cpi_defs = cpi_defs{:};
                
                [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                if (ode_num == 0)
                    return;
                end

                [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
                
                curr_determiner = abs(sum(example_solutions(:)) - sum(experiment_solutions(:)));
                
                if (min_determiner - curr_determiner > 0)
                    min_determiner = curr_determiner;
                    optimal_time = experiment_time;
                    optimal_solutions = experiment_solutions;
                end
                
                cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
                cpi_defs = cpi_defs{:};
                
                if (params(j) - inner_diff >= 0)
                    % decrement parameter j by the set inner difference
                    new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) - inner_diff));
                    cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                    cpi_defs = cpi_defs{:};

                    [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                    if (ode_num == 0)
                        return;
                    end

                    [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                    curr_determiner = abs(sum(example_solutions(:)) - sum(experiment_solutions(:)));

                    if (min_determiner - curr_determiner > 0)
                        min_determiner = curr_determiner;
                        optimal_time = experiment_time;
                        optimal_solutions = experiment_solutions;
                    end

                    cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
                    cpi_defs = cpi_defs{:};
                end
            end
        end

        if (params(k) - outer_diff >= 0)
            % decrement parameter i by the set outer difference
            new_action_token = strrep(old_action_token, num2str(params(k)), num2str(params(k) - outer_diff));
            cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);

            for j = 1:num_params
                if (not(k == j || params(k) == 0))
                    % increment parameter j by the set inner difference
                    old_action_token = action_tokens(param_indices(j));
                    new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) + inner_diff));
                    cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                    cpi_defs = cpi_defs{:};

                    [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                    if (ode_num == 0)
                        return;
                    end

                    [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                    curr_determiner = abs(sum(example_solutions(:)) - sum(experiment_solutions(:)));

                    if (min_determiner - curr_determiner > 0)
                        min_determiner = curr_determiner;
                        optimal_time = experiment_time;
                        optimal_solutions = experiment_solutions;
                    end

                    cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
                    cpi_defs = cpi_defs{:};

                    if (params(j) - inner_diff >= 0)
                        % decrement parameter j by the set inner difference
                        new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) - inner_diff));
                        cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                        cpi_defs = cpi_defs{:};

                        [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                        if (ode_num == 0)
                            return;
                        end

                        [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                        curr_determiner = abs(sum(example_solutions(:)) - sum(experiment_solutions(:)));

                        if (min_determiner - curr_determiner > 0)
                            min_determiner = curr_determiner;
                            optimal_time = experiment_time;
                            optimal_solutions = experiment_solutions;
                        end

                        cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
                        cpi_defs = cpi_defs{:};
                    end
                end
            end     
        end

        inner_diff = inner_diff + step;
    end
    
    outer_diff = outer_diff + step;
end

% plot the resulting simulation
create_cpi_simulation(optimal_time, optimal_solutions, start_time, experimental_file_name, process_def, def_tokens, def_token_num);

end