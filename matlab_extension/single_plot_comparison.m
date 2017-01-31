% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = single_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process)

species = {};
models = {};

figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_models
    [legendStrings, species_num] = prepare_legend(process_def{i}, def_tokens{i}, def_token_num{i});

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
    curr_model = strrep(filename_tokens(1),'_',' ');
    models{end + 1} = regexprep(curr_model,'(\<[a-z])','${upper($1)}');
    
    for j = 1:length(legendStrings)
        species{end + 1} = strjoin([legendStrings{j} ' (' process{i} ', ' models{i} ')'], '');
    end
    
    if (i == 1)
        hold on
    end
end

plot_title = 'CPi Models: ';

for i = 1:(num_models - 2)
    plot_title = strjoin([plot_title models{i} ', '], '');
end

plot_title = strjoin([plot_title models{end - 1} ' and ' models{end}], '');

title(plot_title);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend('show');
legend(num_models, species, 'Location', 'EastOutside');

end