% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes
% description: A user can view the Ordinary Differential Equations (ODEs)
% which are created for a CPi file using this function. After a user selects
% the CPi file, the function calls the CPiWB to obtain the ODEs, which are
% then displayed on screen. This function is called by the Command Line
% Interface function which is defined in cpime.

function view_odes()

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (not(file_name))
    return;
end

% read the selected CPi model and display on the console
definitions = display_definitions(file_name, file_path);

if (isempty(definitions))
    return;
end

% determine which process the user wishes to model from file
[process_name, ~, ~, ~] = select_single_process(definitions);

if (sum(strcmp(process_name, {'cancel', ''})))
    return;
end

% call CPiWB to construct the system of ODEs for the process
[modelODEs, ode_num, ~] = create_cpi_odes(definitions, process_name);

if (ode_num == 0)
    return;
end

% display the ODEs to the user on the terminal
fprintf('\n');

for i = 1:length(modelODEs)
    fprintf(['\n', modelODEs{i}]);
end

% prompt the user to save the ODEs to file, or return to the main menu
prompt = '\n\nDo you wish to save this system of ODEs? (Y/n)\nCPiME:> ';
confirmation = [];

while (isempty(confirmation))
    confirmation = strtrim(input(prompt, 's'));

    if (confirmation == 'Y')

        index = 2;
        valid_name = 0;

        file_name_tokens = strsplit(file_name, '.');

        if (exist([file_name_tokens{1}, '_odes.txt'], 'file') == 2)
            while (valid_name == 0)
                if (not(exist([file_name_tokens{1}, '_odes', num2str(index), '.txt'], 'file') == 2))
                    fid = fopen([file_name_tokens{1}, '_odes', num2str(index), '.txt'], 'wt');
                    new_file_name = [file_name_tokens{1}, '_odes', num2str(index), '.txt'];
                    valid_name = 1;
                else
                    index = index + 1;
                end
            end
        else
            fid = fopen([file_name_tokens{1}, '_odes.txt'], 'wt');
            new_file_name = [file_name_tokens{1}, '_odes.txt'];
        end

        for i=1:length(modelODEs)
            fprintf(fid, [modelODEs{i}, '\n']);
        end

        fclose(fid);
        fprintf(['\nDone. Saved in ''', new_file_name, '''.']);
        
    elseif (not(confirmation == 'n'))
        fprintf('\n\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
        confirmation = [];
    end
end

end