% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [selected_params, num_selected_params] = select_parameters(def_tokens, def_token_num)

params = {};
param_locs = {};
num_silent = 0;
num_affinities = 0;
num_ic = 0;
num_params = 0;
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
    
    index = 1;
    
    for j = 2:(length(silent_action_tokens) - 1)
        if (not(isempty(str2num(silent_action_tokens{j}))))
            params{end + 1} = ['tau<', silent_action_tokens{j}, '>'];
            param_locs{end + 1} = {i, silent_locs(index)};
            num_silent = num_silent + 1;
            index = index + 1;
        end
    end
    
    index = 1;
    
    for j = 2:(length(affinity_tokens) - 1)
        if (not(isempty(str2num(affinity_tokens{j}))))
            params{end + 1} = ['@', affinity_tokens{j}];
            param_locs{end + 1} = {i, affinity_locs(index)};
            num_affinities = num_affinities + 1;
            index = index + 1;
        end
    end
    
    index = 1;
    
    for j = 2:(length(ic_tokens) - 1)
        if (not(isempty(str2num(ic_tokens{j}))))
            params{end + 1} = [ic_tokens{j}];
            param_locs{end + 1} = {i, ic_locs(index)};
            num_ic = num_ic + 1;
            index = index + 1;
        end
    end
end

num_params = num_ic + num_silent + num_affinities;

fprintf(['\n', num2str(num_params), ' parameters identified.']);

param_options = {};

for i = 1:num_params
    param_options{end + 1} = [params{i}, ', ', num2str(param_locs{i}{1}), ', ', num2str(param_locs{i}{2})];
end

[selection,ok] = listdlg('Name', 'Select Parameter(s)', 'PromptString', 'Param, Line, Column', 'SelectionMode', 'multiple', 'ListString', param_options);

if (not(ok) || not(length(selection)))
    return;
end

num_selected_params = length(selection);

for i = 1:num_selected_params
    selected_params{end + 1} = {params{selection(i)}, param_locs{selection(i)}{1}, param_locs{selection(i)}{2}};
end

end