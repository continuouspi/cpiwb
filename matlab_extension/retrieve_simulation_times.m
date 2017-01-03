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
        prompt = '\nPlease enter the start time for the simulation.\nEnter ''cancel'' to cancel the simulation.\n> ';
        time_input = input(prompt, 's');

        if (strcmp(time_input, '') == 1 || strcmp(time_input, 'cancel') == 1)
            end_time = 0;
            return;
        elseif(not(isstrprop(time_input, 'digit')))
            disp('Error: Information entered is nonnumeric.');
            time_input = [];
        else
             start_time = str2num(time_input);
        end
    end

    % request an end time from the user
    time_input = [];
    while(isempty(time_input))
        prompt = '\nPlease enter the end time for the simulation.\nEnter ''cancel'' to cancel the simulation.\n> ';
        time_input = input(prompt, 's');

        if (strcmp(time_input, '') == 1 || strcmp(time_input, 'cancel') == 1)
            end_time = 0;
            return;
        elseif(not(isstrprop(time_input, 'digit')))
            disp('Error: Information entered is nonnumeric.');
            time_input = [];
        else
            end_time = str2num(time_input);
        end
    end
    
    % confirm the times provided are valid
    if (start_time >= end_time)
        fprintf('\nError: Start time exceeds end time.\n');
    else
        valid_time = 0;
    end
end

end
