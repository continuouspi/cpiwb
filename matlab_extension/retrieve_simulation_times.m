% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [start_time, end_time] = retrieve_simulation_times()

start_time = 0;
end_time = 0;

% determine the time frame for the simulation
valid_time = 1;

while(valid_time == 1)
    
    % request a start time from the user
    time_input = [];
    
    prompt = '\n\nPlease enter the start time.\nEnter ''cancel'' to cancel.\n\nCPiME:> ';
    
    while(isempty(time_input))
        time_input = strtrim(input(prompt, 's'));

        if (sum(strcmp(time_input, {'cancel', ''})))
            
            end_time = 0;
            return;
            
        elseif(not(isstrprop(time_input, 'digit')))
            
            fprintf('\nError: Start time entered is nonnumeric.');
            time_input = [];
            
        elseif (str2double(time_input) < 0)
            
            fprintf('\nError: Negative start time entered.');
            time_input = [];
            
        else
            start_time = str2double(time_input);
        end
    end

    % request an end time from the user
    time_input = [];
    prompt = '\n\nPlease enter the end time.\nEnter ''cancel'' to cancel.\n\nCPiME:> ';
    
    while(isempty(time_input))
        time_input = strtrim(input(prompt, 's'));

        if (sum(strcmp(time_input, {'cancel', ''})))
            
            end_time = 0;
            return;
            
        elseif(not(isstrprop(time_input, 'digit')))
            
            fprintf('\nError: End time entered is nonnumeric.');
            time_input = [];
            
        elseif(str2double(time_input) < 0)
            
            fprintf('\nError: Negative end time entered.');
            time_input = [];
            
        else
            end_time = str2double(time_input);
        end
    end
    
    % confirm the times provided are valid
    if (start_time >= end_time)
        fprintf('\nError: End time must exceed the start time.');
    else
        valid_time = 0;
    end
end

end