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

[modelODEs, example_ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (example_ode_num == 0)
    return;
end

[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

[example_time, example_solutions] = solve_cpi_odes(modelODEs, example_ode_num, init_tokens, end_time);

% select an existing .cpi file with parameters to estimate
[experimental_file_name, experimental_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select an experimental .cpi file');

cpi_defs = fileread(strcat(experimental_file_path, '/', experimental_file_name));

% identify the parameters
param_indices = [strfind(cpi_defs, 'tau') strfind(cpi_defs, '@')];

num_params = length(param_indices);

disp(cpi_defs);
disp([num2str(num_params), ' parameters identified.']);

% retrieve the parameters
params = [num_params];

for i = 1:num_params
    if (length(cpi_defs) >= param_indices(i) + 10)
        digits = regexp(cpi_defs(param_indices(i):param_indices(i) + 10), '(\d+(\.\d+)*)', 'match');
    else
        digits = regexp(cpi_defs(param_indices(i):length(cpi_defs)), '(\d+(\.\d+)*)', 'match');
    end
    params(i) = str2double(digits{1});
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
min_ode_num = min(ode_num, example_ode_num);
min_determiner = sumabs(example_solutions(1:min_ode_num) - experiment_solutions(1:min_ode_num));
curr_determiner = 0;
optimal_time = experiment_time;
optimal_solutions = experiment_solutions;
optimal_defs = cpi_defs;

outer_diff = 0;
step = 0.1;

disp('Running experiments ... they may take a while.');
while (outer_diff <= 1)
    for k = 1:num_params
        inner_diff = 0.1;
        
        % increment parameter k by the set outer difference
        if (length(cpi_defs) >= param_indices(k) + 10)
            outer_old_action_token = cpi_defs(param_indices(k):param_indices(k) + 10);
        else
            outer_old_action_token = cpi_defs(param_indices(k):length(cpi_defs));
        end
        outer_new_action_token = strrep(outer_old_action_token, num2str(params(k)), num2str(params(k) * (1 + outer_diff)));
        cpi_defs = strrep(cpi_defs, outer_old_action_token, outer_new_action_token);
        
        for j = 1:num_params
            if (not(k == j))
                % increment parameter j by the set inner difference
                if (length(cpi_defs) >= param_indices(j) + 10)
                    old_action_token = cpi_defs(param_indices(j):param_indices(j) + 10);
                else
                    old_action_token = cpi_defs(param_indices(j):length(cpi_defs));
                end
                new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) * (1 + inner_diff)));
                cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                
                [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                if (ode_num == 0)
                    return;
                end

                [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
                
                min_ode_num = min(ode_num, example_ode_num);

                curr_determiner = sumabs(example_solutions(1:min_ode_num) - experiment_solutions(1:min_ode_num));

                if (min_determiner - curr_determiner > 0)
                    min_determiner = curr_determiner;
                    optimal_time = experiment_time;
                    optimal_solutions = experiment_solutions;
                    optimal_defs = cpi_defs;
                end

                cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
                
                % decrement parameter j by the set inner difference
                new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) * (1 - inner_diff)));
                cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);
                
                [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                if (ode_num == 0)
                    return;
                end

                [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                min_ode_num = min(ode_num, example_ode_num);

                curr_determiner = sumabs(example_solutions(1:min_ode_num) - experiment_solutions(1:min_ode_num));

                if (min_determiner - curr_determiner > 0)
                    min_determiner = curr_determiner;
                    optimal_time = experiment_time;
                    optimal_solutions = experiment_solutions;
                    optimal_defs = cpi_defs;
                end

                cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
            end
        end

        cpi_defs = strrep(cpi_defs, outer_new_action_token, outer_old_action_token);
                
        % decrement parameter i by the set outer difference
        outer_new_action_token = strrep(outer_old_action_token, num2str(params(k)), num2str(params(k) * (1 - outer_diff)));
        cpi_defs = strrep(cpi_defs, outer_old_action_token, outer_new_action_token);

        for j = 1:num_params
            if (not(k == j))
                % increment parameter j by the set inner difference
                if (length(cpi_defs) >= param_indices(j) + 10)
                    old_action_token = cpi_defs(param_indices(j):param_indices(j) + 10);
                else
                    old_action_token = cpi_defs(param_indices(j):length(cpi_defs));
                end
                new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) * (1 + inner_diff)));
                cpi_defs = strrep(cpi_defs, old_action_token, new_action_token);

                [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                if (ode_num == 0)
                    return;
                end

                [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                min_ode_num = min(ode_num, example_ode_num);

                curr_determiner = sumabs(example_solutions(1:min_ode_num) - experiment_solutions(1:min_ode_num));

                if (min_determiner - curr_determiner > 0)
                    min_determiner = curr_determiner;
                    optimal_time = experiment_time;
                    optimal_solutions = experiment_solutions;
                    optimal_defs = cpi_defs;
                end

                cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);

                % decrement parameter j by the set inner difference
                new_action_token = strrep(old_action_token, num2str(params(j)), num2str(params(j) * (1 - inner_diff)));
                cpi_defs = strrep(cpi_defs, old_action_token, new_action_token)

                [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

                if (ode_num == 0)
                    return;
                end

                [experiment_time, experiment_solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);

                min_ode_num = min(ode_num, example_ode_num);

                curr_determiner = sumabs(example_solutions(1:min_ode_num) - experiment_solutions(1:min_ode_num))

                if (min_determiner - curr_determiner > 0)
                    min_determiner = curr_determiner;
                    optimal_time = experiment_time;
                    optimal_solutions = experiment_solutions;
                    optimal_defs = cpi_defs;
                end

                cpi_defs = strrep(cpi_defs, new_action_token, old_action_token);
            end  
        end
        
        cpi_defs = strrep(cpi_defs, outer_new_action_token, outer_old_action_token);

        inner_diff = inner_diff + step;
    end
    
    outer_diff = outer_diff + step;
end

disp(optimal_defs);

% plot the resulting simulation
create_cpi_simulation(optimal_time, optimal_solutions, start_time, experimental_file_name, process_def, def_tokens, def_token_num);

end