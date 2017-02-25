% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [process_name, process_def, definitions, num_definitions] = ...
    select_single_process(cpi_defs)

process_name = '';
process_def = [];

[process_name_options, process_def_options, definitions, ...
    num_definitions] = retrieve_process_definitions(cpi_defs);

% request, from the user, the process to model   
[selection, ok] = listdlg('Name', 'Select Parameter', 'PromptString', ...
    'Param, Line, Column', 'SelectionMode', 'single', 'ListString', ...
    process_name_options);

% if user requests to leave then return to main script
if (not(ok & length(selection)))
    return;
end

process_name = process_name_options{selection};
process_def = process_def_options{selection};

end