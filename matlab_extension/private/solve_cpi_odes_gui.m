% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes, adapted to GUI by Luke Paul Buttigieg

function [t, solutions] = solve_cpi_odes_gui(modelODEs, ode_num, init_tokens, ...
    end_time, solvers, legend_strings)

t = {};
solutions = {};
string_vars = {};
symbolic_vars = sym([ode_num 1]);
view_solutions = 0;

% retrieve the variable names
for i = 1:ode_num
    ode_tokens = strsplit(modelODEs{i}, {'diff(', ','});
    string_vars{end + 1} = char(ode_tokens(2));
    symbolic_vars(i) = sym(string_vars{i});
end

% retrieve the initial conditions from the output script
init_conditions_transpose = [ode_num 1];

init_cond_tokens = strsplit(init_tokens, {'[', ']', ';'});

for i = 1:ode_num
    init_conditions_transpose(i) = str2double(init_cond_tokens{i + 1});
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
vars = transpose(symbolic_vars);

% reformat the ODE RHS expressions to suit odeFunction
[~, ode_exprs] = massMatrixForm(odes, vars);

% solve the system of ODEs
ode_system = odeFunction(ode_exprs, vars);

if (not(isempty(legend_strings)))
    view_solutions = 1;
end

% returning solutions
for i = 1:length(solvers)
    
    ode_name = strsplit(solvers{i}, ' ');
    
    warning('off','all');
    
    if (strcmp(ode_name{1}, 'ode15s'))
        
        [t{end + 1}, solutions{end + 1}] = ode15s(ode_system, ...
            [0 end_time], init_conditions);
        
    elseif(strcmp(ode_name{1}, 'ode23s'))
        
        [t{end + 1}, solutions{end + 1}] = ode23s(ode_system, ...
            [0 end_time], init_conditions);
        
    elseif(strcmp(ode_name{1}, 'ode23t'))
        
        [t{end + 1}, solutions{end + 1}] = ode23t(ode_system, ...
            [0 end_time], init_conditions);
        
    elseif(strcmp(ode_name{1}, 'ode23tb'))
        
        [t{end + 1}, solutions{end + 1}] = ode23tb(ode_system, ...
            [0 end_time], init_conditions);
        
    end
    
    warning('on', 'all');
    max_length = 0;
    
    name = strcat('Numerical Solutions for solver ', ode_name{1});
    
    % plot the simulation, and construct a figure around it
    figu = figure('Name', name,'NumberTitle','on');
    parentPosition = get(figu, 'position');
    
    % setting table position
    uitablePosition = [1 1 parentPosition(3)-2 parentPosition(4)-2];
    
    tabl = uitable(figu, 'position', uitablePosition);
    
    % populating table headers
    tabl.ColumnName = ['Time' legend_strings];
    
    % generating table content - first column has the time,
    % the next columns are the values for each specie.
    first_column = t{1,1};
    solns = solutions{:};
    table_solutions = [first_column solns(:,1:length(legend_strings))];
    
    % rounding the values to four decimal places.
    tabl.Data = round(table_solutions,4);
    
    % moving the figure to the east.
    movegui(figu,'east');
    
end

end