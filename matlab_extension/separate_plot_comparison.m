% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = separate_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process)

% dummy variable for void function
x = 0;

% plot the simulation, and construct a figure around it
figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_models
    subplot(2, 2, i);
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

    plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, 1:species_num), '-o');

    filename_tokens = strsplit(file_name{i}, '.cpi');
    model_name = strrep(filename_tokens(1),'_',' ');
    model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');

    title([model_name, ' Process ', process{i}]);
    ylabel('Species Concentration (units)');
    xlabel('Time (units)');
    legend('show');
    legend(legendString, 'Location', 'EastOutside');
end

end