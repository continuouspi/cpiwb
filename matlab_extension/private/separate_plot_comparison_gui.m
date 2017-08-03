% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function separate_plot_comparison(process, process_def, def_tokens, ...
    def_token_num, t, solutions, file_name, num_processes, start_time)

lines = {};

[legend_strings, separated_species, chosen_species] = find_common_species_gui(process_def, ...
    def_tokens, def_token_num, num_processes);

% plot the simulation, and construct a figure around it
fig = figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_processes
    % introduce a new window to hold space for either 2 or 4 plots
    % in the case that 3 plots are produced, there will be an empty space
    if num_processes > 2
        subplot(2, 2, i);
    else
        subplot(1, 2, i);
    end

    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{i}{:});

    j = 1;

    while (start_index == -1 && j <= end_index)
        
        if (t{i}{:}(j) <= start_time && start_time <= t{i}{:}(j + 1))
            start_index = j;
        end

        j = j + 1;
    end
    
    for k = 1:length(legend_strings{i})
        if (not(strcmp(chosen_species, 'all')))
            flag = 0;
            
            j = 1;

            while (not(flag) && j <= length(separated_species))
                if (strcmpi(legend_strings{i}{k}, separated_species{j}))
                    flag = 1;
                end
                j = j + 1;
            end
        end
        
        if (strcmp(chosen_species, 'all') || flag)
            lines{end + 1} = plot(t{i}{:}(start_index:end_index), ...
                solutions{i}{:}(start_index:end_index, k), 'buttonDownFcn', ...
                {@plotCallback, k}, 'LineStyle', '-', 'LineWidth', 1.75);
        else
            lines{end + 1} = plot(t{i}{:}(start_index:end_index), ...
                solutions{i}{:}(start_index:end_index, k), 'buttonDownFcn', ...
                {@plotCallback, k}, 'LineStyle', '--', 'LineWidth', 1.75);
            lines{end}.Color = [lines{end}.Color 0.2]; 
        end
        
        if (k == 1)
            hold on;
        end
    end

    filename_tokens = strsplit(file_name{i}{:}, '.cpi');
    model_name = strrep(filename_tokens(1),'_',' ');
    model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
    plot_title = [model_name, ['Process ', process{i}]];

    % adjust the figure window size to accomodate multiple plots
    fig.Position(3) = 1.5 * fig.Position(3);
    
    if (num_processes > 2)
        fig.Position(4) = 1.5 * fig.Position(4);
    end
    
    title(plot_title);
    ylabel('Concentration');
    xlabel('Time (seconds)');
    legend('show');
    legend(legend_strings{i}, 'Location', 'EastOutside');
end

end