% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [modelODEs, ode_num, init_tokens] = create_cpi_odes(cpi_defs, process)

init_tokens = [];
modelODEs = {};
ode_num = 0;
cpiwb_result = [];

fprintf('\nConstructing the ODEs ... ');

% load the CPiWB shared library
if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end

% call CPiWB to construct ODEs for the chosen process
[cpiwb_result, ~] = calllib('libOdeConstruction', 'callCPiWB', cpi_defs, process);
    
% free the shared library
unloadlibrary('libOdeConstruction');

if(isempty(cpiwb_result))
    fprintf('\n\nError encountered in the CPi Workbench. Check file definitions before trying again.');
    return;
end

% terminate if CPiWB encountered an error
if (strcmp(cpiwb_result, 'parse error'))
    fprintf('\n\nThe CPi Workbench failed to parse your .cpi file. Please try again.');
    ode_num = 0;
    return;
elseif (strcmp(cpiwb_result, 'process error'))
    fprintf(['\n\nThe CPi Workbench failed to to find process ', process, '. Please try again.']);
    ode_num = 0;
    return;
end

fprintf('Done.');

% tokenize the script from CPiWB
tokens = strsplit(cpiwb_result, '\n');
init_tokens = tokens{1};
token_num = length(tokens);

% retrieve the ODEs from the script
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
    fprintf(['\n\nThe Continuous Pi Workbench did not produce any differential equations for ', file_name]);
    ode_num = 0;
    return;
end

end