% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function create_process_simulation(t, Y, start_time, file_name, ...
    process_name, solvers, legend_strings, species_num)

% use the file's name to create a plot header
filename_tokens = strsplit(file_name, '.cpi');
model_name = strrep(filename_tokens(1),'_',' ');
model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
plot_title = [model_name, ['Process ', process_name]];

% plot the simulation, and construct a figure around it
fig = figure('Name',char(model_name),'NumberTitle','on');

% moving the figure to the west to accomodate numerical solutions of 
% ODE.
movegui(fig,'west');
    
for m = 1:length(solvers)
    
    if (length(solvers) > 2)
        subplot(2, 2, m);
    elseif (length(solvers) > 1)
        subplot(1, 2, m);
    end
    
    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{m});

    i = 1;

    while (start_index == -1 && i < end_index)
        if (start_time <= t{m}(i + 1) && t{m}(i) <= start_time)
            start_index = i;
        end

        i = i + 1;
    end

    plots = {};

    for i = 1:species_num
        plots{end + 1} = plot(t{m}(start_index:end_index), Y{m}(start_index:end_index, i), ...
            'buttonDownFcn', {@plotCallback, i}, 'LineStyle', '-', 'LineWidth', 1.75);

        if (i == 1)
            hold on;
        end
    end

    hold off;
    
    % adjust the figure window size to accomodate multiple plots
    if (length(solvers) > 1)
        fig.Position(3) = 1.5 * fig.Position(3);

        if (length(solvers) > 2)
            fig.Position(4) = 1.5 * fig.Position(4);
        end
    end

    ode_name = strsplit(solvers{m}, ' ');
    title([plot_title, ode_name{1}]);
    ylabel('Concentration');
    xlabel('Time (seconds)');
    legend([plots{:}], legend_strings, 'Location', 'EastOutside');

end

end