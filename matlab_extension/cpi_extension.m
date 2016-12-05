% This Matlab script forms part of the Continuous Pi Workbench, CPiWB
% Author: Ross Rhodes

% Load the CPiWB shared library
if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end

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

% call CPiWB to construct ODEs for the chosen process
modelODEs = {};

cpiwb_result = calllib('libOdeConstruction', 'callCPiWB', [cpi_defs, ',', process]);

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

% simulate the model using the odes and initial conditions
F = odeFunction(F, vars);

ode15s(F, [0 100], inits);

% free the library loaded at the start
unloadlibrary('libOdeConstruction');

return;
