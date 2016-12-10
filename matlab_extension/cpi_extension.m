% This Matlab script forms part of the Continuous Pi Workbench, CPiWB
% Author: Ross Rhodes
job = 0;

% run the script until the users requests to leave
while(not(job == 2))
    prompt = '\nPlease enter a number to perform your desired task from the list below.\n1. Simulate a CPi model\n2. Quit\n> ';
    job = input(prompt);

    % user requests to simulate a CPi model
    if (job == 1)
        
        % Select an existing .cpi file
        [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

        if (file_name == 0)
            return;
        end

        % read the file and display species and process definitions
        cpi_defs = fileread(strcat(file_path, '/', file_name));
        disp(cpi_defs);

        % allow user to choose an existing process to model
        process_found = [];
        while(isempty(process_found))
            prompt = '\nPlease select a process from your chosen model.\nEnter ''quit'' to quit.\n> ';
            process = input(prompt, 's');

            if (strcmp(process, '') == 1 || strcmp(process, 'quit') == 1 || strcmp(process, 'exit') == 1)
                return;
            end

            process_def = ['process ', process];
            process_found = findstr(cpi_defs, process_def);

            if (isempty(process_found))
                disp(['Error: Process ', process, ' not found. Please try again.']);
            end
        end

        % load the CPiWB shared library
        if not(libisloaded('libOdeConstruction'))
            hsffi_path = '/usr/lib64/ghc-7.8.4/include';
            loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
        end

        % call CPiWB to construct ODEs for the chosen process
        [cpiwb_result, ~] = calllib('libOdeConstruction', 'callCPiWB', cpi_defs, process);

        % free the library loaded at the start
        unloadlibrary('libOdeConstruction');

        % terminate if CPiWB encountered an error
        if (strcmp(cpiwb_result, 'parse error'))
            disp('The CPi Workbench failed to parse your .cpi file. Please try again.');
            return;
        end

        modelODEs = {};
        ode_num = 0;
          
        % tokenize the cpi file
        tokens = strsplit(cpiwb_result, '\n');
        token_num = length(tokens);

        % retrieve the odes from the file
        for i = 1:token_num
            chars_token = char(tokens(i));
            ode_found = findstr(chars_token, 'diff');
            if (ode_found == 1)
                ode_num = ode_num + 1;
                modelODEs{end + 1} = char(chars_token);
                ode_found = 0;
            end
        end

        char_vars = {};
        sym_vars = sym([ode_num 1]);

        % retrieve the variable names
        for i = 1:ode_num
            ode_tokens = strsplit(modelODEs{i}, {'diff(', ','});
            char_vars{end + 1} = char(ode_tokens(2));
            sym_vars(i) = sym(char_vars{i});
        end
        
        % retrieve the initial conditions from the output script
        init_conditions = [ode_num 1];

        init_cond_tokens = strsplit(char(tokens(1)), {'[', ']', ';'});

        for i = 1:ode_num
            init_conditions(i) = str2num(init_cond_tokens{i + 1});
        end

        inits = transpose(init_conditions);

        % prepare the odes to be solved
        sym_odes = sym([ode_num 1]);

        for i = 1:ode_num
            sym_odes(i) = sym(modelODEs{i});
        end

        odes = transpose(sym_odes);
        vars = transpose(sym_vars);

        [M, F] = massMatrixForm(odes, vars);

        % determine how long to simulate the model for
        prompt = '\nPlease enter the desired duration of the simulation, or enter ''quit'' to quit.\n> ';
        duration = input(prompt);

        if (strcmp(duration, '') == 1 || strcmp(duration, 'quit') == 1 || strcmp(duration, 'exit') == 1)
            return;
        end

        % simulate the behaviour of the system
        F = odeFunction(F, vars);

        filename_tokens = strsplit(file_name, '.cpi');
        model_name = strrep(filename_tokens(1),'_',' ');

        model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
        
        legendString = cell(1, ode_num);
        
        % prepare info for figure legend
        for i = 1:ode_num
            legendString{i} = sprintf(char_vars{i});
        end
        
        % display the simulation
        figure
        ode15s(F, [0 duration], inits);
        title(model_name);
        ylabel('Species Concentration (units)');
        xlabel('Time (units)');
        legend('show');
        legend(legendString);
    end
end

return;
