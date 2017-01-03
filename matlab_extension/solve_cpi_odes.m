% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [t, Y] = solve_cpi_odes(modelODEs, ode_num, init_tokens, end_time)

t = [];
Y = [];
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

init_cond_tokens = strsplit(init_tokens, {'[', ']', ';'});

for i = 1:ode_num
    init_conditions(i) = str2num(init_cond_tokens{i + 1});
end

inits = transpose(init_conditions);

% solve the system of first order odes
sym_odes = sym([ode_num 1]);

for i = 1:ode_num
    sym_odes(i) = sym(modelODEs{i});
end

sym_odes = simplify(sym_odes);

odes = transpose(sym_odes);
vars = transpose(sym_vars);

[~, ode_exprs] = massMatrixForm(odes, vars);
ode_system = odeFunction(ode_exprs, vars);
[t Y] = ode15s(ode_system, [0 end_time], inits);

end