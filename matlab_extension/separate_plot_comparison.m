% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = separate_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process)

% dummy variable for void function
x = 0;
plt = {};

% plot the simulation, and construct a figure around it
figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_models
    % introduce a new window to hold space for either 2 or 4 plots
    % in the case that 3 plots are produced, there will be an empty space
    if num_models > 2
        subplot(2, 2, i);
    else
        subplot(1, 2, i);
    end
    
    [legendString, species_num] = prepare_legend(process_def{i}, def_tokens{i}, def_token_num{i});

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
        plt{end + 1} = plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, k), 'buttonDownFcn', {@plotCallback, k}, 'LineStyle', '-', 'LineWidth', 1.75);

        if (k == 1)
            hold on;
        end
    end

    filename_tokens = strsplit(file_name{i}, '.cpi');
    model_name = strrep(filename_tokens(1),'_',' ');
    model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
    plot_title = [model_name, ['Process ', process{i}]];

    title(plot_title);
    ylabel('Species Concentration (units)');
    xlabel('Time (units)');
    legend('show');
    legend(legendString, 'Location', 'EastOutside');
end

end