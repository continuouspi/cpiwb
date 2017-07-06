% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [process_names, process_defs, definitions, num_definitions] = ...
    select_multiple_processes(cpi_defs, num_processes_selected, num_total)

process_names = {};
process_defs = {};

[process_name_options, process_def_options, definitions, ...
    num_definitions] = retrieve_process_definitions(cpi_defs);

% request, from the user, the process to model
selection = [];

while(isempty(selection))
    [selection,ok] = listdlg('Name', 'Select Parameter(s)', ...
        'PromptString', 'Param, Line, Column', 'SelectionMode', ...
        'multiple', 'ListString', process_name_options);

    % if user requests to leave then return to main script
    if (not(ok) || not(length(selection)))
        
        return;
        
    elseif (length(selection) > num_total || (length(selection) + ...
            num_processes_selected) > num_total)
        
        avail_spaces = num_total - num_processes_selected;
        
        if(avail_spaces == 1)
            fprintf(['\nError: Too many processes selected. ', ...
                'You may choose one more process to simulate.']);
        else
            fprintf(['\nError: Too many processes selected. You may choose ', ...
                num2str(avail_spaces), ' more processes to simulate.']);
        end
        
        selection = [];
        
    else      
        
        for i = 1:length(selection)
            process_names{end + 1} = process_name_options{selection(i)};
            process_defs{end + 1} = process_def_options{selection(i)};
        end
        
    end
end

end