if not(libisloaded('libOdeConstruction'))
    hsffi_path = '/usr/lib64/ghc-7.8.4/include';
    loadlibrary('libOdeConstruction', 'odeConstruction.h', 'includepath', hsffi_path);
end
libfunctions libOdeConstruction;
param = 'test';
result = calllib('libOdeConstruction', 'callMatlab', param);
fprintf('%s\n', result);
unloadlibrary('libOdeConstruction');