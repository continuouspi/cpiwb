% This Matlab script forms part of the Continuous Pi Workbench, CPiWB
% Author: Ross Rhodes

% Load the CPiWB shared library
if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end

% Select an existing .cpi file
[file_name, file_path, ~] = uigetfile;

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

try
    result = calllib('libOdeConstruction', 'callCPiWB', [cpi_defs, ',', process]);
catch
    disp('Error calling CPiWB. Please try again.');
    return;
end

tokens = strsplit(result, '\n');
token_num = length(tokens);

% retrieve the odes from the output script
for i = 1:token_num
    chars_token = char(tokens(i));
    ode_found = findstr(chars_token, 'xdot');
    if (ode_found == 1)
        modelODEs{end + 1} = chars_token;
        ode_found = 0;
    end
end

% extract equations from their string representation
ode_num = length(modelODEs);
X = sym('x', [ode_num 1]);

for i = 1:ode_num
    new_tokens = strsplit(char(modelODEs(i)), ' = ');
    X(i) = char(new_tokens(2));
end

% simplify the equations
for i = 1:ode_num
    X(i) = simplify(X(i));
end

% retrieve the initial conditions from the output script
init_conditions = [ode_num 1];

init_cond_tokens = strsplit(char(tokens(1)), {'[', ']', ';'});

for i = 1:ode_num
    init_conditions(i) = str2double(init_cond_tokens(i+1));
end

% solve the set of differential equations
syms t x
F = @(t,x) X;
[t, x] = ode45(F, [0.0 100.0], [0.0 0.0 0.0 0.0]);

% plot the solution for the given time interval
fplot(t, x);

% free the library loaded at the start
unloadlibrary('libOdeConstruction');

return;
