% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [start_time, end_time] = retrieve_simulation_times();

start_time = 0;
end_time = 0;

% determine the time frame for the simulation
valid_time = 1;

while(valid_time == 1)
    % request a start time from the user
    time_input = [];
    while(isempty(time_input))
        prompt = '\nPlease enter the start time.\nEnter ''cancel'' to cancel.\nCPiME:> ';
        time_input = strtrim(input(prompt, 's'));

        if (strcmp(time_input, '') == 1 || strcmp(time_input, 'cancel') == 1)
            end_time = 0;
            return;
        elseif(not(isstrprop(time_input, 'digit')))
            fprintf('\nError: Information entered is nonnumeric.');
            time_input = [];
        elseif (str2num(time_input) < 0)
            fprintf('\nError: Negative start time entered.');
            time_inout = [];
        else
            start_time = str2num(time_input);
        end
    end

    % request an end time from the user
    time_input = [];
    while(isempty(time_input))
        prompt = '\nPlease enter the end time.\nEnter ''cancel'' to cancel.\nCPiME:> ';
        time_input = strtrim(input(prompt, 's'));

        if (strcmp(time_input, '') == 1 || strcmp(time_input, 'cancel') == 1)
            end_time = 0;
            return;
        elseif(not(isstrprop(time_input, 'digit')))
            fprintf('\nError: Information entered is nonnumeric.');
            time_input = [];
        elseif(str2num(time_input) < 0)
            fprintf('\nError: Negative end time entered.');
            time_input = [];
        else
            end_time = str2num(time_input);
        end
    end
    
    % confirm the times provided are valid
    if (start_time >= end_time)
        fprintf('\nError: Start time either exceeds or equates to the end time.\n');
    else
        valid_time = 0;
    end
end

end