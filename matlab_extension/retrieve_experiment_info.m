% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [min_value, max_value, experiment_num] = retrieve_experiment_info(param, param_num)

min_value = -1;
max_value = -1;
experiment_num = -1;
valid_range = 0;

% continue until valid minumum and maximum 
while(not(valid_range))
    valid_range = 1;
    
    while(min_value < 0)
        prompt = ['\n\nEnter the minimum value for parameter ', num2str(param_num), ': ', param{1}, '.\nEnter ''cancel'' to cancel.\nCPiME:> '];
        user_input = input(prompt, 's');

        if (sum(strcmp(user_input, {'cancel', ''})))
            return;
        end

        if(not(isstrprop(user_input, 'digit')))
            fprintf('\nError: The minimum value entered is nonnumeric.');
            user_input = [];
        else
            min_value = str2num(user_input);

            if (min_value < 0)
                fprintf('\nError: The minimum value must be nonnegative.');
            end
        end
    end
    
    while(max_value < 0)
        prompt = ['\n\nEnter the maximum value for parameter ', num2str(param_num), ': ', param{1}, '.\nEnter ''cancel'' to cancel.\nCPiME:> '];
        user_input = input(prompt, 's');

        if (sum(strcmp(user_input, {'cancel', ''})))
            return;
        end

        if(not(isstrprop(user_input, 'digit')))
            fprintf('\nError: The maximum value entered is nonnumeric.');
            user_input = [];
        else
            max_value = str2num(user_input);

            if (max_value < 0)
                fprintf('\nError: The maximum value must be nonnegative.');
            elseif (max_value < min_value)
                fprintf('\nError: Minimum value must not exceed maximum value.');
                valid_range = 0;
            end
        end
    end
end

while(experiment_num < 0)
    prompt = ['\n\nEnter the number of experimental values to substitute for parameter ', num2str(param_num), ': ', param{1}, '.\nEnter ''cancel'' to cancel.\nCPiME:> '];
    user_input = input(prompt, 's');

    if (sum(strcmp(user_input, {'cancel', ''})))
        return;
    end

    if(not(isstrprop(user_input, 'digit')))
        fprintf('\nError: The number of experiments entered is nonnumeric.');
        user_input = [];
    else
        experiment_num = str2num(user_input);

        if (experiment_num < 0)
            fprintf('\nError: The number of experiments must be nonnegative.');
        end
    end
end

end