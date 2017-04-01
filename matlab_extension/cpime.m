% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function cpime()
    clc;
    fprintf('Welcome to the Continuous Pi Calculus Matlab Extension, CPiME.');

    % list the commands CPiME recognises
    commands = {'edit_model'; 'view_odes'; 'parameter_scans'; ...
        'simulate_process'; 'help'; 'compare_processes'; 'analyse_solutions'; ...
        'quit'};

    suggestion_followed = 0;
    job = [];

    % run the script until the user enters 'quit'
    while(not(strcmp(job, 'quit')))
        clearvars -except suggestion_followed commands job experiment_performed;

        % when the user mistypes a command, one suggestion is given
        % if the suggestion is accepted, then suggestion_followed = 1
        if (not(suggestion_followed))
            fprintf('\n\nMain Menu\nEnter ''help'' for help, or ''quit'' to quit.');
            prompt = '\n\nCPiME:> ';
            job = strtrim(input(prompt, 's'));
        else
            suggestion_followed = 0;
        end

        if (strcmp(job, 'quit'))
            return;
        elseif (strcmp(job, 'help'))

            % display commands to the user when 'help' is entered
            fprintf(['\n\nThe following commands are recognised by CPiME:', ...
            '\n\nedit_model\nview_odes\nanalyse_solutions', ...
            '\nsimulate_process\ncompare_processes', ...
            '\nparameter_scans\nquit\n\nEnter ', ...
            '''help <command>'' for further details on a specific command.']);

        elseif (length(job) > 4 && strcmp(job(1:5), 'help '))

            % search command documentation for a suitable description
            % ignoring the first five characters, 'help '
            input_length = length(job);
            command_docs(job(6:input_length));

        elseif (strcmp(job, 'view_odes'))

            view_odes();
            clear view_odes;

        elseif (strcmp(job, 'simulate_process'))

            simulate_single_process();
            clear simulate_single_process;

        elseif (strcmp(job, 'edit_model'))

            % open a dialog to select an existing .cpi file
            [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

            if ((file_name))
                % open the chosen file inside Matlab
                edit([file_path, '/', file_name]);
            end

        elseif (strcmp(job, 'compare_processes'))

            compare_cpi_processes();

        elseif (strcmp(job, 'parameter_scans'))

            parameter_scan();

        elseif (strcmp(job, 'analyse_solutions'))

            analyse_ode_solutions();

        elseif (not(strcmp(job, '')))

            fprintf(['\nError: ', job, ' command not recognised.']);

            i = 1;
            num_commands = length(commands);
            best_match = 'help';
            highest_match_count = 0;
            confirmation = [];

            % determine which existing command best matches the user's input
            while (i <= num_commands)
                char_matches = 0;
                max_len = max(length(commands{i}), length(job));

                % trim the longer of the existing and entered commands
                % working only with partial commands to find best match
                % potential to make more sophisticated help algorithm here

                if (max_len == length(commands{i}))
                    trimmed_command = commands{i}(1:length(job));
                    trimmed_job = job;
                else
                    trimmed_command = commands{i};
                    trimmed_job = job(1:length(commands{i}));
                end

                ascii_job = double(trimmed_job);
                ascii_command = double(trimmed_command);

                for j = 1:length(ascii_job)
                    if (ascii_job(j) == ascii_command(j))
                        char_matches = char_matches + 1;
                    end
                end

                if (highest_match_count < char_matches)
                    highest_match_count = char_matches;
                    best_match = commands{i};
                end

                i = i + 1;
            end

            % suggest the existing command which best matches the user input
            % as long as the suggestion is at most four characters difference
            if (highest_match_count > (length(best_match) - 4))

                prompt = (['\n\nDid you mean ''', best_match, '''? (Y/n)\nCPiME:> ']);

                while (isempty(confirmation))
                    confirmation = strtrim(input(prompt, 's'));

                    if (confirmation == 'Y')
                        suggestion_followed = 1;
                        job = best_match;
                    elseif (not(confirmation == 'n'))
                        fprintf('\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
                        confirmation = [];
                    end
                end
            end
        end
    end

    clearvars;

end
