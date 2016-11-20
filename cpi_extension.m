if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end

filepath = 'test';
process = 'Pi';
result = calllib('libOdeConstruction', 'callCPiWB', strcat(filepath, ',', process));
fprintf('%s\n', filepath);
fprintf('%s\n', process);
fprintf('%s\n', result);
unloadlibrary('libOdeConstruction');