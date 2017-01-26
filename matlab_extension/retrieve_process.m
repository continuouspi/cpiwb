% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs)

process = '';
process_found = [];
process_def = [];
def_tokens = [];
def_token_num = 0;

while(isempty(process_found))
    % request, from the user, the process to model
    prompt = ['\nEnter a process name from this file.\nNote: This is case sensitive.\nEnter ''cancel'' to cancel.\nCPiME:> '];
    process = input(prompt, 's');

    % if user requests to leave then return to main script
    if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
        return;
    end
    
    process_name = ['process ', process];
    
    % tokenize the CPi file
    def_tokens = strsplit(cpi_defs, ';');
    def_token_num = length(def_tokens);
    species = {};
    i = 1;

    % find the requested process in the file tokens
    while((i <= def_token_num) & (isempty(process_found))) 
        def_token = char(def_tokens(i));
        process_found = findstr(def_token, process_name);
        if (not(isempty(process_found)))
            process_def = def_token;
        end
        i = i + 1;
    end

    % report an error if the process does not exist on file
    if (isempty(process_found))
        fprintf(['\nError: Process ', process, ' not found. Please try again.']);
    end
end

end