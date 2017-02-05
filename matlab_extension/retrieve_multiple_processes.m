% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [processes, process_def, def_tokens, def_token_num] = retrieve_multiple_processes(cpi_defs, num_processes_selected, num_total)

processes = {};
process_found = [];
process_def = [];
def_tokens = [];
def_token_num = 0;

while(isempty(process_found))
    % request, from the user, the process to model
    prompt = ['\n\nEnter process name(s) from this file, separated by a space character.\nNote: This is case sensitive.\nEnter ''cancel'' to cancel.\nCPiME:> '];
    process = input(prompt, 's');

    % if user requests to leave then return to main script
    if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
        processes = '';
        return;
    end
    
    processes = strsplit(process, ' ');
    num_processes = length(processes);
    
    if (num_processes > num_total || (length(processes) + num_processes_selected) > num_total)
        avail_spaces = num_total - length(num_processes_selected);
        
        if(avail_spaces == 1)
            fprintf(['\nError: Too many processes selected. You may choose ', num2str(avail_spaces), ' more process to simulate.']);
        else
            fprintf(['\nError: Too many processes selected. You may choose ', num2str(avail_spaces), ' more processes to simulate.']);
        end
        
        continue;
    end
    
    % tokenize the CPi file
    def_tokens = strsplit(cpi_defs, ';');
    def_token_num = length(def_tokens);
    
    for m = 1:length(processes)
        process_name = ['process ', processes{m}];
        
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
            continue;
        end
    end
end

end