% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function num_processes = determine_num_simulations_in_comparison()

num_processes = 0;
num_input = [];
prompt = '\n\nHow many processes do you wish to compare?\nEnter ''cancel'' to cancel.\nCPiME:> ';

while(isempty(num_input))
    num_input = input(prompt, 's');

    if (sum(strcmp(num_input, {'cancel', ''})))
        
        return;
        
    elseif(not(isstrprop(num_input, 'digit')))
        
        fprintf('\nError: The information entered is nonnumeric.');
        num_input = [];
        
    else
         num_processes = str2double(num_input);
         
         if (num_processes > 4)
             fprintf('\nError: No more than four processes may be modelled simultaneously.');
             num_input = [];
         end
    end
end

end