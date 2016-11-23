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
disp(['\n', cpi_defs]);

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

% temporary return statement until CPiWB side completed
return;

% call CPiWB to construct ODEs for the chosen process
result = calllib('libOdeConstruction', 'callCPiWB', [cpi_defs, ',', process]);

return;

% free the library loaded at the start
unloadlibrary('libOdeConstruction');
