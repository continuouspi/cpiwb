% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function solver_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, start_time)

plt = {};
solver = {'ode15s'; 'ode23s'; 'ode23t'; 'ode23tb'};

[legendStrings, species_num] = prepare_legend(process_def, def_tokens, def_token_num);

[separated_species, chosen_species] = find_common_species(legendStrings);

% plot the simulation, and construct a figure around it
fig = figure('Name','Model Comparison','NumberTitle','on');

for i = 1:4

    subplot(2, 2, i);

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
                if (strcmp(lower(legendStrings{k}), lower(separated_species{j})))
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

    filename_tokens = strsplit(file_name, '.cpi');
    model_name = strrep(filename_tokens(1),'_',' ');
    model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
    plot_title = ['Solver ', solver{i}];

    % adjust the figure window size to accomodate multiple plots
    fig.Position(3) = 1.5 * fig.Position(3);
    fig.Position(4) = 1.5 * fig.Position(4);
    
    title(plot_title);
    ylabel('Species Concentration (units)');
    xlabel('Time (units)');
    legend('show');
    legend(legendStrings, 'Location', 'EastOutside');
end

end