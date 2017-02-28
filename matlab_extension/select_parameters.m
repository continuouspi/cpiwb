% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [selected_params, num_selected_params] = ...
    select_parameters(def_tokens, def_token_num)

params = {};
param_locations = {};
num_silent = 0;
num_affinities = 0;
num_ic = 0;
selected_params = {};
num_selected_params = 0;

% extract and store all actions for the selected CPi file
for i = 1:def_token_num
    silent_action_tokens = strsplit(def_tokens{i}, {'tau<','>.'});
    affinity_tokens = strsplit(def_tokens{i}, {'{', '@', ',', '}'});
    ic_tokens = strsplit(def_tokens{i}, {'[', ']'});
    
    silent_locs = strfind(def_tokens{i}, 'tau<');
    affinity_locs = strfind(def_tokens{i}, '@');
    ic_locs = strfind(def_tokens{i}, '[');
    
    % do not follow Matlab advice to convert str2num to str2double here
    % converts non-numeric tokens into numeric values; not desired
    
    index = 1;
    
    for j = 2:(length(silent_action_tokens) - 1)
        if (not(isempty(str2num(silent_action_tokens{j}))))
            params{end + 1} = ['tau<', silent_action_tokens{j}, '>'];
            param_locations{end + 1} = {i, silent_locs(index)};
            num_silent = num_silent + 1;
            index = index + 1;
        end
    end
    
    index = 1;
    
    for j = 2:(length(affinity_tokens) - 1)
        if (not(isempty(str2num(affinity_tokens{j}))))
            params{end + 1} = ['@', affinity_tokens{j}];
            param_locations{end + 1} = {i, affinity_locs(index)};
            num_affinities = num_affinities + 1;
            index = index + 1;
        end
    end
    
    index = 1;
    
    for j = 2:(length(ic_tokens) - 1)
        if (not(isempty(str2num(ic_tokens{j}))))
            params{end + 1} = [ic_tokens{j}];
            param_locations{end + 1} = {i, ic_locs(index)};
            num_ic = num_ic + 1;
            index = index + 1;
        end
    end
end

num_params = num_ic + num_silent + num_affinities;

if (not(num_params))
    fprintf('\n\nNo parameters identified in this file.');
    return;
end

if (num_params == 1)
    fprintf('\n1 parameter identified.');
else
    fprintf(['\n', num2str(num_params), ' parameters identified.']);
end

longest_param = 0;
longest_param_row = 0;

for i = 1:num_params

    if (length(params{i}) > longest_param)
        longest_param = length(params{i});
    end
    
    if (length(num2str(param_locations{i}{1})) > longest_param_row)
        longest_param_row = length(num2str(param_locations{i}{1}));
    end
   
end

if (length('parameter') > longest_param)
    longest_param = length('parameter');
end

if (length('line') > longest_param_row)
    longest_param_row = length('line');
end

fprintf(['\n\nID', blanks(length(num2str(num_params)) + 2), 'Parameter', ...
    blanks(longest_param - length('parameter') + 4), 'Line', ...
    blanks(longest_param_row - length('line') + 4), 'Column\n']);

for i = 1:num_params
    
    fprintf(['\n', num2str(i), blanks(length(num2str(num_params)) - ...
        length(num2str(i)) + 4), params{i}, blanks(longest_param - ...
        length(params{i}) + 4), num2str(param_locations{i}{1}), ...
        blanks(longest_param_row - length(num2str(param_locations{i}{1})) + 4), ...
        num2str(param_locations{i}{2})]);
end

fprintf(['\n\nPlease select which parameters to experiment by listing ', ...
    'the identifiers on the left-most column, separated by a single space.', ...
    '\nEnter ''cancel'' to cancel.']);

prompt = '\n\nCPiME:> ';

selection_input = [];

while(isempty(selection_input))
    selection_input = strtrim(input(prompt, 's'));

    if (strcmp(selection_input, 'cancel'))
        return;
    elseif (strcmp(selection_input, ''))
        continue;
    end
    
    selection = strsplit(selection_input, ' ');
    
    i = 1;
    
    while (not(isempty(selection_input)) && i <= length(selection))
        if (str2double(selection{i}) > num_params || str2double(selection{i}) < 1)
            fprintf(['\n\nError: ', selection{i}, ' is an invalid parameter identifier.']);
            selection_input = [];
        end
        
        i = i + 1;
    end
end

num_selected_params = length(selection);

for i = 1:num_selected_params
    selected_params{end + 1} = {params{str2num(selection{i})}, ...
        param_locations{str2num(selection{i})}{1}, param_locations{str2num(selection{i})}{2}};
end

end