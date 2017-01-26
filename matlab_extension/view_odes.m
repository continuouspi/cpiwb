% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function x = view_odes()

% void function - dummy variables
x = 0;

% select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if (file_name == 0)
    return;
end

% read the selected CPi model and display on the console
cpi_defs = fileread(strcat(file_path, '/', file_name));
fprintf(['\n', cpi_defs]);

% determine which process the user wishes to model from file
[process, process_def, def_tokens, def_token_num] = retrieve_process(cpi_defs);

if (strcmp(process, '') == 1 || strcmp(process, 'cancel') == 1)
    return;
end

% call CPiWB to construct the system of ODEs for the process
[modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process);

if (ode_num == 0)
    return;
end

for i = 1:length(modelODEs)
    fprintf(['\n', modelODEs{i}]);
end

prompt = '\nDo you wish to save this system of ODEs? (Y/n)\n> ';
confirmation = [];

while (isempty(confirmation))
    confirmation = strtrim(input(prompt, 's'));

    if (confirmation == 'Y')
        % save the constructed ODEs to a text file
        index = 1;
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
        fprintf('\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
        confirmation = [];
    end
end

end