% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = compare_cpi_models()

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

while(isempty(num_input))
    prompt = 'How many processes do you wish to compare? Enter ''cancel'' to cancel.\n> ';
    num_input = input(prompt, 's');

    if (strcmp(num_input, '') == 1 || strcmp(num_input, 'cancel') == 1)
        return;
    elseif(not(isstrprop(num_input, 'digit')))
        disp('Error: Information entered is nonnumeric.');
    else
         num_models = str2num(num_input);
         
         % set the maximum nunber of models allowed to four
         if (num_models > 4)
             disp('Error: No more than four processes may be compared.');
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
                if (file_name{j} == new_file)
                    prompt = 'The selected model has already been chosen. Do you wish to proceed? Y/N\n> ';
                    confirmation = [];
                   
                    while (isempty(confirmation))
                        confirmation = input(prompt, 's');

                        if (confirmation == 'N')
                            new_file = {};
                        elseif (not(confirmation == 'Y'))
                            disp('Error: Invalid input provided. Please enter Y for yes, or N for no.');
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
        disp(cpi_defs);

        [process{i}, process_def{end + 1}, def_tokens{end + 1}, def_token_num{end + 1}] = retrieve_process(cpi_defs);

        if (strcmp(process{i}, '') == 1)
            continue;
        end

        [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process{i});

        if (ode_num == 0)
            continue;
        end

        [t{end + 1}, Y{end + 1}] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
    end

    figure('Name','Model Comparison','NumberTitle','on');

    for i = 1:num_models
        [legendStrings, species_num, start_index, end_index] = prepare_legend(t{i}, start_time, process_def{i}, def_tokens{i}, def_token_num{i});
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