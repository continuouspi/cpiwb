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

while(isempty(num_input))
    prompt = 'How many models do you wish to compare? Enter ''cancel'' to cancel.\n> ';
    num_input = input(prompt, 's');

    if (strcmp(num_input, '') == 1 || strcmp(num_input, 'cancel') == 1)
        return;
    elseif(not(isstrprop(num_input, 'digit')))
        disp('Error: Information entered is nonnumeric.');
    else
         num_models = str2num(num_input);
    end
end

% if only one model is to be simulated then go to simulate_model

% determine the time frame to model for comparison
[start_time, end_time] = retrieve_simulation_times();

if (end_time == 0)
    return;
end

for i = 1:num_models
    % select an existing .cpi file
    [file_name{i}, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');
    
    % read the selected CPi model and produce a simulation
    cpi_defs = fileread(strcat(file_path, '/', file_name{i}));
    disp(cpi_defs);

    [process, process_def{end + 1}, def_tokens{end + 1}, def_token_num{end + 1}] = retrieve_process(cpi_defs);

    if (strcmp(process, '') == 1)
        continue;
    end

    [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

    if (ode_num == 0)
        continue;
    end

    [t{end + 1}, Y{end + 1}] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
end

figure('Name','Model Comparison','NumberTitle','on');

for i = 1:num_models
    [legendStrings, species_num, start_index, end_index] = prepare_legend(t{i}, start_time, process_def{i}, def_tokens{i}, def_token_num{i});
    plot(t{i}(start_index:end_index), Y{i}(start_index:end_index, 1:species_num), '-o');
    
    for j = 1:length(legendStrings)
        species{end + 1} = [legendStrings{j}, ', model ', num2str(i)];
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