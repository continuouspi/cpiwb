% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [t, solutions] = solve_cpi_odes(modelODEs, ode_num, init_tokens, ...
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

prompt = (['\n\nDo you wish to see the numerical solutions? (Y/n)\nCPiME:> ']);
confirmation = [];

if (not(isempty(legend_strings)))
    while (isempty(confirmation))
        confirmation = strtrim(input(prompt, 's'));

        if (confirmation == 'Y')
            view_solutions = 1;
        elseif (not(confirmation == 'n'))
            fprintf('\nError: Invalid input provided. Please enter ''Y'' for yes, or ''n'' for no.');
            confirmation = [];
        end
    end
end

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
    
    % arbitrary limit set to guarantee all solutions will be visible
    if(view_solutions && size(solutions{end}, 1) <= 1500)
        fprintf(['\nSolutions for solver ', ode_name{1}, ':\n\n']);
        
        max_length = length('time (s)');
        
        for p = 1:length(legend_strings)
            if (length(legend_strings{p}) > max_length)
                max_length = length(legend_strings{p});
            end
            
            for q = 1:size(solutions{end}, 2)
                if (length(solutions{end}(p,q)) > max_length)
                    max_length = length(num2str(round(solutions{end}(p,q), 3)));
                end
            end
        end
        
        fprintf(['time (s)', blanks(max_length - length('time (s)') + 1),'| ']);
        for p = 1:length(legend_strings)
            fprintf([legend_strings{p}, blanks(max_length - length(legend_strings{p}) + 1),'| ']);
        end
        
        fprintf('\n');
        underscores = repmat('-', max_length + 1);
        
        for p = 1:length(legend_strings)
            fprintf([underscores(1, :), '|-']);
        end
        fprintf([underscores(1, :), '|']);
    
        for p = 1:size(solutions{end}, 1)
            fprintf('\n');
            fprintf([num2str(round(t{end}(p), 3)), ...
                    blanks(max_length - length(num2str(round(t{end}(p), 3))) + 1), '| ']);
            for q = 1:length(legend_strings)
                fprintf([num2str(round(solutions{end}(p, q), 3)), ...
                    blanks(max_length - length(num2str(round(solutions{end}(p, q), 3))) + 1), '| ']);
            end
        end
        
        fprintf('\n');
        
    elseif (view_solutions)
        
        fprintf('\nError: Too many solutions to display on terminal.');
        
    end
    
end

end