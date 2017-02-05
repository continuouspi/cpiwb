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
init_conditions_transpose = [ode_num 1];

init_cond_tokens = strsplit(init_tokens, {'[', ']', ';'});

for i = 1:ode_num
    init_conditions_transpose(i) = str2num(init_cond_tokens{i + 1});
end

init_conditions = transpose(init_conditions_transpose);

% convert string ODE RHS expressions to Matlab symbolic expressions
sym_odes = sym([ode_num 1]);

for i = 1:ode_num
    sym_odes(i) = sym(modelODEs{i});
end

% simplify the expressions prior to solving
sym_odes = simplify(sym_odes);

odes = transpose(sym_odes);
vars = transpose(sym_vars);

% reformat the ODE RHS expressions to suit odeFunction
[~, ode_exprs] = massMatrixForm(odes, vars);

% solve the system of ODEs
ode_system = odeFunction(ode_exprs, vars);

fprintf('\nSolving the system of ODEs ... ');

[t Y] = ode15s(ode_system, [0 end_time], init_conditions);

% confirm Y holds valid concentration values
num_neg_values = sum(sum([Y(:, 1:length(init_conditions)) < 0]));

% if this fails, attempt alternative solver
if (num_neg_values)
    fprintf('\nDefault solver failed. Applying auxiliary solver to the system.');
    
    % produces warnings about matrices close to singularity. Ignore
    warning('off','all');
    [t Y] = ode23s(ode_system, [0 end_time], init_conditions);
    warning('on', 'all');
end

fprintf('Done.');

end