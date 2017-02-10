% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [process, process_def, def_tokens, def_token_num] = retrieve_single_process(cpi_defs)

process = '';
process_options = {};
process_def_options = {};
process_def = [];

% tokenize the CPi file
def_tokens = strsplit(cpi_defs, ';');
def_token_num = length(def_tokens);
i = 1;

% find all process definitions in the file tokens
i = 1;
while(i <= def_token_num)
    def_token = char(def_tokens(i));
    process_found = findstr(def_token, 'process')
    comment_line = findstr(def_token, '--')
    if (process_found & isempty(comment_line))
        process_tokens = strsplit(def_token, ' ');
        process_options{end + 1} = process_tokens{2};
        process_def_options{end + 1} = def_token;
    end
    i = i + 1;
end

% request, from the user, the process to model   
[selection,ok] = listdlg('Name', 'Select Parameter(s)', 'PromptString', 'Param, Line, Column', 'SelectionMode', 'single', 'ListString', process_options);

% if user requests to leave then return to main script
if (not(ok) || not(length(selection)))
    return;
end

process = process_options{selection};
process_def = process_def_options{selection};

end