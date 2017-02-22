% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function analyse_ode_solutions()

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (file_name == 0)
    return;
end

% read the selected CPi model and display on the console
cpi_defs = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', strtrim(cpi_defs)]);

% determine which process the user wishes to model from file
[process, process_def, def_tokens, def_token_num] = retrieve_single_process(cpi_defs);

if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
    return;
end

% call CPiWB to construct the system of ODEs for the process
fprintf('\n\nConstructing the ODEs ... ');
[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

fprintf('Done.\n');

% request an end time from the user
lbc_query = [];
while(isempty(lbc_query))
    prompt = '\nPlease enter a time frame for the system.\nEnter ''cancel'' to cancel.\nCPiME:> ';
    lbc_query = strtrim(input(prompt, 's'));

    if (strcmp(lbc_query, '') == 1 || strcmp(lbc_query, 'cancel') == 1)
        end_time = 0;
        return;
    elseif(not(isstrprop(lbc_query, 'digit')))
        fprintf('\nError: Information entered is nonnumeric.');
        lbc_query = [];
    elseif(str2num(lbc_query) < 0)
        fprintf('\nError: Negative end time entered.');
        lbc_query = [];
    else
        end_time = str2num(lbc_query);
    end
end

if (end_time == 0)
    return;
end

% solve the system of ODEs for the given time period
fprintf('\nSolving the system with default solver ... ');
[~, solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time, 'default');

if (isempty(solutions))
    return;
end

fprintf('Done.\n');

% setup the legend for the simulation
[species, ~] = prepare_legend(process_def, def_tokens, def_token_num);

% request a LBC expression from the user
fprintf('\nPlease enter a query for the solutions of the ODE system.\nFor example queries, enter ''examples''.\nEnter ''finish'' to return to the main options.');
prompt = '\nCPiME:> ';
lbc_query = [];

while (isempty(lbc_query))
    lbc_query = strtrim(input(prompt, 's'));

    if (strcmp(lbc_query, '') || strcmp(lbc_query, 'finish'))
       return;
    elseif (strcmp(lbc_query, 'examples'))
       fprintf('For further guidance, a GUI for creating queries may be found here: http://scantisani.github.io/lbc-expression-creator/.');
       lbc_query = [];
    else
       tokenised_query = validate_query(lbc_query, species);
       
       if (size(tokenised_query))
            answer_query(tokenised_query, species, solutions);
       end
       
       lbc_query = [];
    end
end

end