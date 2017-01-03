% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

process_found = [];

while(isempty(process_found))
    % request, from the user, the process to model
    prompt = ['\nEnter a process name from this file for simulation.\nNote: This is case sensitive.\nEnter ''cancel'' to cancel the simulation.\n> '];
    process = input(prompt, 's');

    % if user requests to leave then return to main script
    if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
        return;
    end

    % find the process definition inside the CPi file
    process_name = ['process ', process];

    def_tokens = strsplit(cpi_defs, ';');
    def_token_num = length(def_tokens);
    species = {};
    i = 1;

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
        fprintf(['Error: Process ', process, ' not found. Please try again.']);
    end
end