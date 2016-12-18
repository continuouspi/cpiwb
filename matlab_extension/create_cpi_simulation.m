modelODEs = {};
ode_num = 0;
process_found = [];

% ask user to select a process to simulate
% tokenize the CPi file line for line and retrieve process def
while(isempty(process_found))
    prompt = '\nPlease select a process from your chosen model.\nEnter ''quit'' to quit.\n> ';
    process = input(prompt, 's');

    if (strcmp(process, '') == 1 || strcmp(process, 'quit') == 1 || strcmp(process, 'exit') == 1)
        return;
    end

    process_name = ['process ', process];

    def_tokens = strsplit(cpi_defs, ';');
    def_token_num = length(def_tokens);
    species = {};
    i = 1;

    while((i <= def_token_num) & (isempty(process_found))) 
        def_token = char(def_tokens(i));
        process_found = findstr(def_token, process_name);
        if (not(isempty(process_found)))
            process_def = def_token;
        end
        i = i + 1;
    end

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

% tokenize the script from CPi
tokens = strsplit(cpiwb_result, '\n');
token_num = length(tokens);

% retrieve the odes from the script
for i = 1:token_num
    chars_token = char(tokens(i));
    ode_found = findstr(chars_token, 'diff');
    if (ode_found == 1)
        ode_num = ode_num + 1;
        modelODEs{end + 1} = char(chars_token);
        ode_found = 0;
    end
end

% terminate if no ODEs were generated by CPiWB
if (isempty(modelODEs))
    disp(['The Continuous Pi Workbench did not produce any differential equations for ', file_name]);
    return;
end

i = 1;

while(i < def_token_num) 
    def_token = char(def_tokens(i));
    species_found = findstr(def_token, 'species ');
    if (not(isempty(species_found)))
        species_tokens = strsplit(def_token, {'species ', '('});
        species_token = species_tokens(2);
        species_in_process = findstr(process_def, char(species_token));
        if (not(isempty(species_in_process)))
            species{end + 1} = char(species_token);
        end
    end
    i = i + 1;
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
G = odeFunction(F, vars);

filename_tokens = strsplit(file_name, '.cpi');
model_name = strrep(filename_tokens(1),'_',' ');

model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');

% prepare variables for inclusion in legend
species_num = length(species);
legendString = cell(1, species_num);

species = sort(species);

for i = 1:species_num
    legendString{i} = sprintf(char(species{i}));
end

[t Y] = ode15s(G, [0.01 duration], inits);

% display the simulation
figure
plot(t, Y(:, 1:species_num), '-o') 
title(model_name);
ylabel('Species Concentration (units)');
xlabel('Time (units)');
legend('show');
legend(legendString, 'Location', 'EastOutside');

return;