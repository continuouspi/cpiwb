% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
% 

function analyse_ode_solutions()

lbc_query = [];

prompt = '\n\nCPiME:> ';

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(file_name))
    return;
end

% read the selected CPi model and display on the console
cpi_defs = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', strtrim(cpi_defs)]);

% determine which process the user wishes to model from file
[process, process_def, def_tokens, def_token_num] = select_single_process(cpi_defs);

if (sum(strcmp(process, {'', 'cancel'})))
    return;
end

% call CPiWB to construct the system of ODEs for the process
fprintf('\n\nConstructing the ODEs ... ');

[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (not(ode_num))
    return;
end

fprintf('Done.\n');

% request an end time from the user
while(isempty(lbc_query))
    fprintf('\nPlease enter an end time for analysis starting from zero.\nEnter ''cancel'' to cancel.');
    lbc_query = strtrim(input(prompt, 's'));

    if (strcmp(lbc_query, 'cancel'))
        return;
    elseif(isnan(str2double(lbc_query)))
        fprintf('\nError: Information entered is nonnumeric.');
        lbc_query = [];
    elseif(str2double(lbc_query) < 0)
        fprintf('\nError: Negative end time entered.');
        lbc_query = [];
    elseif (not(strcmp(lbc_query, '')));
        end_time = str2double(lbc_query);
    end
end

if (not(end_time))
    return;
end

% solve the system of ODEs for the given time period
fprintf('\nSolving the system with default solver ... ');

[t, solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time, {'ode15s'}, []);

if (isempty(solutions))
    return;
end

fprintf('Done.\n');

% setup the legend for the simulation
[species, ~] = prepare_legend(process_def, def_tokens, def_token_num);

lbc_query = [];

% request a LBC expression from the user
fprintf('\nPlease enter a query for the solutions of the system.');
fprintf('\nFor example queries, enter ''examples''.');

while (isempty(lbc_query))   
    fprintf('\nEnter ''finish'' to return to the main menu.');
    lbc_query = strtrim(input(prompt, 's'));

    if (strcmp(lbc_query, 'finish'))
        
       return;
    
    % if examples are requested, print them to terminal
    % also guide users to Cantisani's Blockly tool for LBC expressions
    elseif (strcmp(lbc_query, 'examples'))
        
       fprintf('\nFor all of time the concentration of P exceeds 0.5:\n');
       fprintf('\n\tG([P] > 0.5)\n');
       fprintf('\nEventually T has degraded to the inert species:\n');
       fprintf('\n\tF([T] = 0)\n');
       fprintf('\nEither P falls below 0.5 or T always exceeds 0.1:\n');
       fprintf('\n\tF([P] < 0.5) or G([T] > 0.1)\n');
       fprintf('\nP never exceeds 1 and P does not equal 0:\n');
       fprintf('\n\tG([P] <= 1) and G([P] != 0)\n');
       fprintf('\nFor further guidance, a GUI to create queries may be found <a href="http://scantisani.github.io/lbc-expression-creator/">here</a>.');
       lbc_query = [];
       
    elseif (not(strcmp(lbc_query, '')))
        
       % tokenise and validate the entered expression
       tokenised_query = validate_query(lbc_query, species, end_time);
       
       % if the query is valid, answer it with True or False
       if (size(tokenised_query))
            answer_query(tokenised_query, species, t, solutions);
       end
       
       fprintf('\n');
       lbc_query = [];
    end
end

end