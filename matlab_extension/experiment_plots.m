% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = experiment_plots(process_def, def_tokens, def_token_num, t, Y, file_name, num_experiments, start_time, process)

% dummy variable for void function
x = 0;
plt = {};
X = {};
Z = {};

[legendString, species_num] = prepare_legend(process_def, def_tokens, def_token_num);

[separated_species, chosen_species] = find_common_species(legendString);

% plot the simulation, and construct a figure around it
figure('Name','Parameter Experimentation','NumberTitle','on');

for i = 1:num_experiments
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
            if (i == 1)
                X{end + 1} = t{i}(start_index:end_index);
                Z{end + 1} = Y{i}(start_index:end_index, k);
            elseif (i == num_experiments)
                X{end + 1} = t{i}(start_index:end_index);
                Z{end + 1} = Y{i}(start_index:end_index, k);
            end
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

filename_tokens = strsplit(file_name, '.cpi');
model_name = strrep(filename_tokens(1),'_',' ');
model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
plot_title = [model_name, ['Process ', process]];

title(plot_title);
ylabel('Species Concentration (units)');
xlabel('Time (units)');

Xs = [];
Zs = [];

i = 1;
max_len = 0;

while (i < length(X))
    if (max_len < length([X{i}; X{i+1}]))
        max_len = length([X{i}; X{i+1}]);
    end
    
    if (max_len < length([Z{i}; Z{i+1}]))
        max_len = length([Z{i}; Z{i+1}]);
    end
    
    i = i + 2;
end

i = 1;

while (i <= length(X))
    len_x = length([X{i}; X{i+1}]);
    
    Xs = [Xs, [X{i}; flip(X{i + 1}); X{i+1}(1) * ones(max_len - len_x, 1)]];
    
    len_z = length([Z{i}; Z{i+1}]);
    
    Zs = [Zs, [Z{i}; flip(Z{i + 1}); Z{i+1}(1) * ones(max_len - len_z, 1)]];
    
    i = i + 2;
end

fill(Xs, Zs, 'r', 'LineStyle', '-.', 'FaceAlpha', 0.5);

legend(legendString, 'Location', 'EastOutside');

end