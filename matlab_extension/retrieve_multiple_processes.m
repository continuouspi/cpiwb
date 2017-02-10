% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [processes, process_defs, def_tokens, def_token_num] = retrieve_multiple_processes(cpi_defs, num_processes_selected, num_total)

processes = {};
process_defs = {};
process_options = {};
process_def_options = {};

% tokenize the CPi file
def_tokens = strsplit(cpi_defs, ';');
def_token_num = length(def_tokens);
i = 1;

% find all process definitions in the file tokens
i = 1;
while(i <= def_token_num)
    def_token = char(def_tokens(i));
    process_found = findstr(def_token, 'process');
    comment_line = findstr(def_token, '--');
    if (process_found & isempty(comment_line))
        process_tokens = strsplit(def_token, ' ');
        process_options{end + 1} = process_tokens{2};
        process_def_options{end + 1} = def_token;
    end
    i = i + 1; 
end

% request, from the user, the process to model
selection = [];
while(isempty(selection))
    [selection,ok] = listdlg('Name', 'Select Parameter(s)', 'PromptString', 'Param, Line, Column', 'SelectionMode', 'multiple', 'ListString', process_options);

    % if user requests to leave then return to main script
    if (not(ok) || not(length(selection)))
        return;
    elseif (length(selection) > num_total || (length(selection) + num_processes_selected) > num_total)
        avail_spaces = num_total - num_processes_selected;
        if(avail_spaces == 1)
            fprintf('\nError: Too many processes selected. You may choose one more process to simulate.');
        else
            fprintf(['\nError: Too many processes selected. You may choose ', num2str(avail_spaces), ' more processes to simulate.']);
        end
        selection = [];
    else      
        for i = 1:length(selection)
            processes{end + 1} = process_options{selection(i)};
            process_defs{end + 1} = process_def_options{selection(i)};
        end
    end
end

end