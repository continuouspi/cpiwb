% This Matlab script forms part of the Continuous Pi Workbench, CPiWB
% Author: Ross Rhodes

% Select an existing .cpi file
[file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Pick a file');

if (file_name == 0)
    return;
end

cpi_defs = fileread(strcat(file_path, '/', file_name));
disp(cpi_defs);

% allow user to choose a process to model
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

% Load the CPiWB shared library
if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end

% call CPiWB to construct ODEs for the chosen process
modelODEs = {};

[cpiwb_result, ~] = calllib('libOdeConstruction', 'callCPiWB', cpi_defs, process);

% free the library loaded at the start
unloadlibrary('libOdeConstruction');

% terminate if CPiWB encountered an error
if (strcmp(cpiwb_result, 'parse error'))
    disp('The CPi Workbench failed to parse your .cpi file. Please try again.');
    return;
end

tokens = strsplit(cpiwb_result, '\n');
token_num = length(tokens);
ode_num = 0;

% retrieve the odes from the output script
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
    char_vars{end + 1} = ode_tokens(2);
    sym_vars(i) = sym(char_vars{i});
end

% prepare the odes to be solved
sym_odes = sym([ode_num 1]);

for i = 1:ode_num
    sym_odes(i) = sym(modelODEs{i});
end

odes = transpose(sym_odes);
vars = transpose(sym_vars);

[M, F] = massMatrixForm(odes, vars);

% retrieve the initial conditions from the output script
init_conditions = [ode_num 1];

init_cond_tokens = strsplit(char(tokens(1)), {'[', ']', ';'});

for i = 1:ode_num
    init_conditions(i) = str2num(init_cond_tokens{i + 1});
end

inits = transpose(init_conditions);

% determine how long to simulate the model for
prompt = '\nPlease enter the desired duration of the simulation, or enter ''quit'' to quit.\n> ';
duration = input(prompt);

if (strcmp(duration, '') == 1 || strcmp(duration, 'quit') == 1 || strcmp(duration, 'exit') == 1)
    return;
end

% simulate the behaviour of the system
F = odeFunction(F, vars);

figure
ode15s(F, [0 duration], inits);
title(file_name)
ylabel('Species Concentration (units)');
xlabel('time (units)');

return;
