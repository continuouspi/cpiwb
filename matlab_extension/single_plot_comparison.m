% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = single_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process)

species = {};
species_num = {};
models = {};
plt = {};
legendStrings = {};
chosen_species = {};
separated_species = {};

legendStringSet = [];

for i = 1:num_models
    [legendStrings{end + 1}, species_num{end + 1}] = prepare_legend(process_def{i}, def_tokens{i}, def_token_num{i});
    legendStringSet = [legendStringSet unique(legendStrings{i})];
end

% identify common species between processes
legendStringSet = unique(legendStringSet);

[separated_species, chosen_species] = find_common_species(legendStringSet, legendStrings, num_models);

figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_models
    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{i});
    
    filename_tokens = strsplit(file_name{i}, '.cpi');
    curr_model = strrep(filename_tokens(1),'_',' ');
    models{end + 1} = regexprep(curr_model,'(\<[a-z])','${upper($1)}');
    
    for j = 1:length(legendStrings{i})
        species{end + 1} = strjoin([legendStrings{i}{j} ' (' process{i} ', ' models{i} ')'], '');
    end

    j = 1;

    while (start_index == -1 & j < end_index)
        if (t{i}(j) <= start_time & start_time <= t{i}(j + 1))
            start_index = j;
        end

        j = j + 1;
    end
    
    for k = 1:species_num{i}

        if (not(strcmp(chosen_species, 'all')))
            flag = 0;
            
            j = 1;

            while (not(flag) & j <= length(separated_species))
                if (strcmp(lower(legendStrings{i}{k}), lower(separated_species{j})))
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
    
    if (i == 1)
        hold on;
    end
end

plot_title = 'CPi Models: ';

for i = 1:(num_models - 2)
    plot_title = strjoin([plot_title models{i} ', '], '');
end

plot_title = strjoin([plot_title models{num_models - 1} ' and ' models{num_models}], '');
title(plot_title);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend('show');
legend(num_models, species, 'Location', 'EastOutside');

end