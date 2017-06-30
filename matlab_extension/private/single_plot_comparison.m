% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function single_plot_comparison(process, process_def, def_tokens, ...
    def_token_num, t, solutions, file_name, num_processes, start_time)

species = {};
models = {};
lines = {};

[legend_strings, separated_species, chosen_species] = find_common_species(process_def, ...
    def_tokens, def_token_num, num_processes);

figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_processes
    
    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{i}{:});
    filename_tokens = strsplit(file_name{i}{:}, '.cpi');
    curr_model = strrep(filename_tokens(1),'_',' ');
    models{end + 1} = regexprep(curr_model,'(\<[a-z])','${upper($1)}');
    
    for j = 1:length(legend_strings{i})
        species{end + 1} = strjoin({legend_strings{i}{j}, ...
            ' (', process{i}, ', ', models{i}{1}, ')'}, '');
    end

    j = 1;

    while (start_index == -1 && j < end_index)
        
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
            
            lines{i}.Color = [lines{i}.Color 0.2]; 
        end
            
        if (k == 1)
            hold on;
        end
        
    end
    
    if (i == 1)
        hold on;
    end
end

plot_title = 'CPi Models: ';

for i = 1:(num_processes - 2)
    plot_title = strjoin([plot_title models{i} ', '], '');
end

plot_title = strjoin([plot_title models{num_processes - 1} ' and ' models{num_processes}], '');
title(plot_title);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend(species, 'Location', 'EastOutside');

end