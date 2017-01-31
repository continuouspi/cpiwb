% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = compare_cpi_models()

% dummy variable - void function
x = 0;

num_input = [];
Y = {};
t = {};
file_name = {};
process_def = {};
def_tokens = {};
def_token_num = {};
process = {};
new_process = {};

% determine the number of processes to be modelled. Maximum 4
while(isempty(num_input))
    prompt = '\n\nHow many processes do you wish to compare?\nEnter ''cancel'' to cancel.\nCPiME:> ';
    num_input = input(prompt, 's');

    if (strcmp(num_input, '') == 1 || strcmp(num_input, 'cancel') == 1)
        return;
    elseif(not(isstrprop(num_input, 'digit')))
        fprintf('\nError: Information entered is nonnumeric.');
    else
         num_models = str2num(num_input);
         
         if (num_models > 4)
             fprintf('\nError: No more than four processes may be modelled simultaneously.');
             num_models = [];
         end
    end
end

% if only one process is to be modelled, follow simulate_model command
if (num_models == 0)
    return;
elseif (num_models == 1)
    simulate_single_model();
else
    % determine the time frame to model for comparison
    [start_time, end_time] = retrieve_simulation_times();

    if (end_time == 0)
        return;
    end
    
    i = 1;

    while i <= num_models

        % select an existing .cpi file
        [new_file, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, ['Select .cpi file number ', num2str(i)]);

        if (new_file == 0)
            return;
        end

        % read the selected CPi model and produce a simulation
        cpi_defs = fileread(strcat(file_path, '/', new_file));
        fprintf(['\n', strtrim(cpi_defs)]);

        [new_process, process_def{end + 1}, def_tokens{end + 1}, def_token_num{end + 1}] = retrieve_process(cpi_defs);

        % confirm the new process is not a duplicate from previous choices
        if (strcmp(new_process, '') == 1)
            return;
        else
            j = 1;
            duplicate = 0;
            
            while(j< length(process) & duplicate == 0)
                if (strcmp(new_process, process{j}) == 1 & strcmp(new_file, file_name{j}) == 1)
                    fprintf(['\nError: Process ', new_process, ' is already selected for modelling.']);
                    duplicate = 1;
                end
                j = j + 1;
            end
            
            if (duplicate == 1)
                continue;
            end
            
            process{end + 1} = new_process;
            file_name{end + 1} = new_file;
        end

        % construct and solve the system of ODEs for the selected process
        [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process{i});

        if (ode_num == 0)
            continue;
        end

        [t{end + 1}, Y{end + 1}] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time);
        
        i = i + 1;
    end

    % determine whether to simulate on a single or multiple plots
    prompt = '\n\nDo you wish to simulate the behaviour of all processes on a single plot, or do you wish to see each process on a separate plot?\nEnter ''single'' for a single plot, ''separate'' for separate plots, or ''cancel'' to cancel.\nCPiME:> ';
    plot_type = [];

    while (isempty(plot_type))
        plot_type = strtrim(input(prompt, 's'));

        if (strcmp(plot_type, 'cancel') == 1)
            return;
        elseif (not(strcmp(plot_type, 'single') == 1) & not(strcmp(plot_type,'separate') == 1))
            fprintf('\nError: Invalid input provided. Please enter ''single'' for a single plot, or ''separate'' for separate plots.');
            plot_type = [];
        end
    end

    if (strcmp(plot_type, 'single') == 1)
        single_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process);
    else 
        separate_plot_comparison(process_def, def_tokens, def_token_num, t, Y, file_name, num_models, start_time, process);
    end
end
end