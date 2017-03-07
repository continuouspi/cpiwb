% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function definitions = display_definitions(file_name, file_path)

% read the selected CPi model and display on the console
definitions = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', strtrim(definitions)]);

prompt = '\n\nCPiME:> ';
proceed_input = [];

while(isempty(proceed_input))
    fprintf('\n\nStudy the definitions for the chosen model.\nHit the enter key when ready to proceed, or type ''cancel'' to cancel.');
    proceed_input = strtrim(input(prompt, 's'));

    if (strcmp(proceed_input, 'cancel'))
        definitions = [];
        return;
    elseif(not(strcmp(proceed_input, '')))
        fprintf('\nError: Invalid input provided.');
        proceed_input = [];
    else
        proceed_input = 'Y';
    end
end