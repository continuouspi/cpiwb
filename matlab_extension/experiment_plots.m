% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function experiment_plots(process_def, def_tokens, def_token_num, t, Y, file_name, num_experiments, start_time, process)

plt = {};
time_points = {};
concentration_points = {};

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
    
    num_chosen_species = length(separated_species);
    count = 1;
    
    for k = 1:species_num
        if (not(strcmp(chosen_species, 'all')))
            flag = 0;
            
            j = 1;

            while (not(flag) & j <= num_chosen_species)
                if (strcmp(lower(legendString{k}), lower(separated_species{j})))
                    flag = 1;
                end
                j = j + 1;
            end
        end
        
        if (strcmp(chosen_species, 'all') || flag)
            plt{end + 1} = plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, k), 'buttonDownFcn', {@plotCallback, k}, 'LineStyle', '-', 'LineWidth', 1.75);
            
            if (i == 1)
                time_points{end + 1} = {};
                concentration_points{end + 1} = {};
                time_points{end}{end + 1} = t{i}(start_index:end_index);
                concentration_points{end}{end + 1} = Y{i}(start_index:end_index, k);
            elseif (i == num_experiments)
                time_points{count}{end + 1} = t{i}(start_index:end_index);
                concentration_points{count}{end + 1} = Y{i}(start_index:end_index, k);
                count = count + 1;
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

i = 1;

while (i <= num_chosen_species)
    time_frame = [time_points{i}{1}; flip(time_points{i}{2})];
    concentration_frame = [concentration_points{i}{1}; flip(concentration_points{i}{2})];
    
    fill(time_frame, concentration_frame, 'r', 'LineStyle', '-.', 'FaceAlpha', 0.5);
    
    hold on;
    
    i = i + 1;
end

legend(legendString, 'Location', 'EastOutside');

end