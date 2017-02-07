% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = experiment_plots(process_def, def_tokens, def_token_num, t, Y, file_name, num_experiments, start_time, process)

% dummy variable for void function
x = 0;
plt = {};
legendStrings = {};
chosen_species = {};
separated_species = {};
species_num = {};

[legendString, species_num] = prepare_legend(process_def, def_tokens, def_token_num);

[separated_species, chosen_species] = find_common_species(legendString);

% plot the simulation, and construct a figure around it
fig = figure('Name','Model Experimentation','NumberTitle','on');

divisor = fix(num_experiments/4);

for i = 1:num_experiments
    % introduce a new window to hold space for either 2 or 4 plots
    % in the case that 3 plots are produced, there will be an empty space
    subplot(max(divisor, 1), 4, i);

    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{i});

    j = 1;

    while (start_index == -1 & j < end_index)
        if (t{i}(j) <= start_time & start_time <= t{i}(j + 1))
            start_index = j;
        end

        j = j + 1;
    end

    for k = 1:species_num
        if (not(strcmp(chosen_species, 'all')))
            flag = 0;
            
            j = 1;

            while (not(flag) & j <= length(separated_species))
                if (strcmp(lower(legendString{k}), lower(separated_species{j})))
                    flag = 1;
                end
                j = j + 1;
            end
        end
        
        if (strcmp(chosen_species, 'all') || flag)
            plt{end + 1} = plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, k), 'buttonDownFcn', {@plotCallback, k}, 'LineStyle', '-', 'LineWidth', 1.75);
        else
            plt{end + 1} = plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, k), 'buttonDownFcn', {@plotCallback, k}, 'LineStyle', '--', 'LineWidth', 1.75);
            plt{end}.Color = [plt{end}.Color 0.2]; 
        end
        
        if (k == 1)
            hold on;
        end
    end

    filename_tokens = strsplit(file_name{i}, '.cpi');
    model_name = strrep(filename_tokens(1),'_',' ');
    model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
    plot_title = [model_name, ['Process ', process{i}]];

    % adjust the figure window size to accomodate multiple plots
    fig.Position(3) = 1.5 * fig.Position(3);
    fig.Position(4) = 1.5 * fig.Position(4);
    
    title(plot_title);
    ylabel('Species Concentration (units)');
    xlabel('Time (units)');
end

end