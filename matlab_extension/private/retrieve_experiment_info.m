% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [min_value, max_value, experiment_num] = ...
    retrieve_experiment_info(parameter_info, parameter_num)

min_value = -1;
max_value = -1;
experiment_num = -1;
valid_range = 0;

prompt = '\n\nCPiME:> ';

% continue until valid minumum and maximum 
while(not(valid_range))
    valid_range = 1;

    fprintf(['\n\nEnter the minimum value for parameter ', ...
            num2str(parameter_num), ': ', parameter_info{1}, ', line ', ...
            num2str(parameter_info{2}), ', column ', num2str(parameter_info{3}), ...
            '\nEnter ''cancel'' to cancel.']);
    
    while(min_value < 0)
        
        user_input = input(prompt, 's');

        if (strcmp(user_input, 'cancel'))
            return;
        end

        if(not(isstrprop(user_input, 'digit')))
            fprintf('\nError: The minimum value entered is nonnumeric.');
            min_value = -1;
        elseif(not(strcmp(user_input, '')))
            min_value = str2double(user_input);

            if (min_value < 0)
                fprintf('\nError: The minimum value must be nonnegative.');
            end
        end
    end
    
    fprintf(['\n\nEnter the maximum value for parameter ', ...
            num2str(parameter_num), ': ', parameter_info{1}, ', line ', ...
            num2str(parameter_info{2}), ', column ', num2str(parameter_info{3}), ...
            '\nEnter ''cancel'' to cancel.']);
        
    while(max_value < 0)
        user_input = input(prompt, 's');

        if (strcmp(user_input, 'cancel'))
            return;
        end

        if(not(isstrprop(user_input, 'digit')))
            fprintf('\nError: The maximum value entered is nonnumeric.');
            max_value = -1;
        elseif (not(strcmp(user_input, '')))
            max_value = str2double(user_input);

            if (max_value < 0)
                fprintf('\nError: The maximum value must be nonnegative.');
            elseif (max_value < min_value)
                fprintf('\nError: Minimum value must not exceed maximum value.');
                valid_range = 0;
            end
        end
    end
end

fprintf(['\n\nEnter the number of experimental values to attempt on parameter ', ...
            num2str(parameter_num), ': ', parameter_info{1}, ', line ', ...
            num2str(parameter_info{2}), ', column ', num2str(parameter_info{3}), ...
            '\nEnter ''cancel'' to cancel.']);

while(experiment_num < 0)
    
    user_input = input(prompt, 's');

    if (strcmp(user_input, 'cancel'))
        return;
    end

    if(not(isstrprop(user_input, 'digit')))
        fprintf('\nError: The number of experiments entered is nonnumeric.');
        experiment_num = -1;
        
    elseif(not(strcmp(user_input, '')))
        experiment_num = str2double(user_input);

        if (experiment_num < 0)
            fprintf('\nError: The number of experiments must be nonnegative.');
        end
    end
end

end