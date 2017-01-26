% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = parameter_experiment()

% empty output
x = 0;

% select an existing .cpi file with parameters to estimate
[experimental_file_name, experimental_file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

cpi_defs = fileread(strcat(experimental_file_path, '/', experimental_file_name));
def_tokens = strsplit(cpi_defs, ';');
def_token_num = length(def_tokens);

fprintf(['\n', cpi_defs]);

% identify the initial conditions, silent actions, and affinities
params = {};
param_row_indices = {};
num_affinities = 0;
num_silent = 0;
num_init_conditions = 0;

for i = 1:def_token_num
    silent_actions = strsplit(def_tokens{i}, {'tau<','>.'});
    affinities = strsplit(def_tokens{i}, {'@',',','}'});
    initial_conditions = strsplit(def_tokens{i}, {'[', ']'});

    for j = 2:(length(silent_actions) - 1)
        if (not(isempty(str2num(silent_actions{j}))))
            params{end + 1} = str2num(silent_actions{j});
            param_row_indices{end + 1} = i;
            num_silent = num_silent + 1;
        end
    end
    
    for j = 2:(length(affinities) - 1)
        if (not(isempty(str2num(affinities{j}))))
            params{end + 1} = str2num(affinities{j});
            param_row_indices{end + 1} = i;
            num_affinities = num_affinities + 1;
        end
    end
    
    for j = 2:(length(initial_conditions) - 1)
        if (not(isempty(str2num(initial_conditions{j}))))
            params{end + 1} = str2num(initial_conditions{j});
            param_row_indices{end + 1} = i;
            num_init_conditions = num_init_conditions + 1;
        end
    end
end

num_params = length(params);

fprintf(['\n', num2str(num_params), ' parameters identified:\n\n', num2str(num_silent), ' silent actions\n', num2str(num_affinities), ' affinities\n', num2str(num_init_conditions), ' initial conditions']);
return;

end