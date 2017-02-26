% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function experiment_plots(process_def, def_tokens, def_token_num, t, Y, file_name, num_experiments, start_time, process)

plots = {};
time_points = {};
concentration_points = {};

fill_colours = ['y'; 'm'; 'c'; 'r'; 'g'; 'b'];

% setup the legend for the simulation
[species, species_num] = prepare_legend(process_def, def_tokens, def_token_num);

% allow user to select one species from the common species list
fprintf(['\n', num2str(length(species)), ...
    ' species were found.', ...
    '\nChoose which ones to highlight in simulations, each separated by a space character:']);

fprintf('\n');

for i = 1:length(species)
    fprintf(['\n', num2str(i), '. ', species{i}]);
end

fprintf('\n\nAlternatively enter ''all'' for all lines to be fully visible, or enter ''cancel'' to cancel.');

chosen_species = [];

while (isempty(chosen_species))
    prompt = '\nCPiME:> ';
    chosen_species = input(prompt, 's');

    if (strcmp(strtrim(chosen_species), 'cancel'))
        return;
    elseif (strcmp(strtrim(chosen_species), 'all'))
        continue;
    end

    separated_species = strsplit(strtrim(chosen_species), ' ');

    for j = 1:length(separated_species)
        flag = 0;

        for i = 1:length(species)
            flag = flag + sum(strcmp(species{i}, strtrim(separated_species{j})));
        end

        if (not(flag))
            fprintf(['\nInvalid species ''', strtrim(separated_species{j}), ...
                ''' entered.\nPlease try again, or enter ''cancel'' to cancel.']);
            chosen_species = [];
        end
    end
end

% plot the simulation, and construct a figure around it
figure('Name','Parameter Experimentation','NumberTitle','on');

for i = 1:num_experiments
    % ODE solvers start with time 0. Find index for the user's start time
    start_index = -1;
    end_index = length(t{i}{:});

    j = 1;

    while (start_index == -1 && j < end_index)
        if (t{i}{:}(j) <= start_time && start_time <= t{i}{:}(j + 1))
            start_index = j;
        end

        j = j + 1;
    end
    
    if (strcmp(strtrim(chosen_species), 'all'))
        num_chosen_species = length(species);
    else
        num_chosen_species = length(separated_species);
    end
    
    count = 1;
    
    for k = 1:species_num
        if (not(strcmp(chosen_species, 'all')))
            flag = 0;
            
            j = 1;

            while (not(flag) && j <= num_chosen_species)
                if (strcmpi(species{k}, separated_species{j}))
                    flag = 1;
                end
                j = j + 1;
            end
        end
        
        if (strcmp(chosen_species, 'all') || flag)
            plots{end + 1} = plot(t{i}{:}(start_index:end_index), Y{i}{:}(start_index:end_index, k), 'HandleVisibility', 'off', 'LineStyle', '-', 'LineWidth', 1.75);
            
            if (i == 1)
                time_points{end + 1} = {};
                concentration_points{end + 1} = {};
                time_points{end}{end + 1} = t{i}{:}(start_index:end_index);
                concentration_points{end}{end + 1} = Y{i}{:}(start_index:end_index, k);
            elseif (i == num_experiments)
                time_points{count}{end + 1} = t{i}{:}(start_index:end_index);
                concentration_points{count}{end + 1} = Y{i}{:}(start_index:end_index, k);
                count = count + 1;
            end
            
        else
            plots{end + 1} = plot(t{i}{:}(start_index:end_index), Y{i}{:}(start_index:end_index, k), 'HandleVisibility', 'off', 'LineStyle', '--', 'LineWidth', 1.75);
            plots{end}.Color = [plots{end}.Color 0.2]; 
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
fills = {};

while (i <= num_chosen_species)
    time_frame = [time_points{i}{1}; flip(time_points{i}{2})];
    concentration_frame = [concentration_points{i}{1}; flip(concentration_points{i}{2})];
    
    fills{end + 1} = patch(time_frame, concentration_frame, fill_colours(mod(i,6)), 'HandleVisibility', 'on', 'FaceAlpha', 0.2, 'buttonDownFcn', {@fillCallback, i}, 'LineStyle', '-.');
    
    hold on;
    
    i = i + 1;
end

legend(separated_species, 'Location', 'EastOutside');

end