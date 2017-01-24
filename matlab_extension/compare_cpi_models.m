% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = compare_cpi_models()

% dummy variable - void function
x = 0;

num_input = [];
Y = {};
t = {};
start_time = 0;
file_name = {};
process_def = {};
def_tokens = {};
def_token_num = {};
species_num = 0;
species = {};
process = {};
new_process = {};

while(isempty(num_input))
    prompt = '\nHow many processes do you wish to compare?\nEnter ''cancel'' to cancel.\n> ';
    num_input = input(prompt, 's');

    if (strcmp(num_input, '') == 1 || strcmp(num_input, 'cancel') == 1)
        return;
    elseif(not(isstrprop(num_input, 'digit')))
        fprintf('\nError: Information entered is nonnumeric.');
    else
         num_models = str2num(num_input);
         
         % set the maximum nunber of models allowed to four
         if (num_models > 4)
             fprintf('\nError: No more than four processes may be modelled simultaneously.');
             num_models = [];
         end
    end
end

if (num_models == 0)
    return;
elseif (num_models == 1)
    simulate_single_model;
else

    % determine the time frame to model for comparison
    [start_time, end_time] = retrieve_simulation_times();

    if (end_time == 0)
        return;
    end

    for i = 1:num_models

        new_file = {};

        while(isempty(new_file))
            % select an existing .cpi file
            [new_file, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, ['Select .cpi file number ', num2str(i)]);

            if (new_file == 0)
                return;
            end

            % confirm the chosen model is not already in our list
            j = 1;
            file_found = 0;
            
            while (j <= 1:length(file_name) & file_found == 0)
                if (strcmp(file_name{j}, new_file) == 1)
                    prompt = 'The selected model has already been chosen. Do you wish to proceed? Y/N\n> ';
                    confirmation = [];
                   
                    while (isempty(confirmation))
                        confirmation = strtrim(input(prompt, 's'));

                        if (confirmation == 'N')
                            new_file = {};
                        elseif (not(confirmation == 'Y'))
                            fprintf('\nError: Invalid input provided. Please enter Y for yes, or N for no.');
                            confirmation = [];
                        end
                    end
                    
                    file_found = 1;
                end
                j = j + 1;
            end
        end

        file_name{i} = new_file;

        % read the selected CPi model and produce a simulation
        cpi_defs = fileread(strcat(file_path, '/', file_name{i}));
        fprintf(['\n', cpi_defs]);

        [new_process, process_def{end + 1}, def_tokens{end + 1}, def_token_num{end + 1}] = retrieve_process(cpi_defs);

        if (strcmp(new_process, '') == 1)
            continue;
        else
            j = 1;
            duplicate = 0;
            
            while(j< length(process) & duplicate == 0)
                if (strcmp(new_process, process{j}) == 1 & strcmp(new_file, file_name{j}) == 1)
                    fprintf(['\nError: Process ', new_process, ' is already selected for modelling.']);
                    duplicate = 1;
                end
                j = j + 1;
            end
            
            if (duplicate == 1)
                continue;
            end
            
            process{end + 1} = new_process;
        end

        [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process{i});

        if (ode_num == 0)
            continue;
        end

        [t{end + 1}, Y{end + 1}] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
    end

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
        model_name = strrep(filename_tokens(1),'_',' ');

        model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');

        for j = 1:length(legendStrings)
            species{end + 1} = [legendStrings{j}, ', process ' process{i}, ', model ', model_name{:}];
        end

        if (i == 1)
            hold on
        end
    end

    title('CPi Models');
    ylabel('Species Concentration (units)');
    xlabel('Time (units)');
    legend('show');
    legend(species, 'Location', 'EastOutside');

    disp('Done.');
end
end