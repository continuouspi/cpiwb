% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function answer_query(tokenised_query, species, solutions)

answer = 1;
vars = {};

i = 1;

while(answer & i <= length(tokenised_query))
    disjunction_answer = 0;
    j = 1;
    
    while (not(disjunction_answer) & j <= length(tokenised_query(i)))
        tokenised_clause = tokenised_query{i}{j};
        equation = [];
        vars = {};
        species_index = {};
        k = 1;
        
        while (k <= length(species))
            if (strcmp(species{k}, tokenised_clause{2}))
                species_index{end + 1} = k;
                equation = [equation species{k}];
                vars{end + 1} = sym(species{k});
            end

            k = k + 1;
        end
        
        equation = [equation tokenised_clause{3}];
        
        if (strcmp(tokenised_clause{4}, '{'))
            beginning_flag = 8;
        else
            beginning_flag = 4;
        end
        
        for l = beginning_flag:length(tokenised_clause)
            if (sum(strcmp(tokenised_clause{l}, {'+', '-', '*', '/'})) || not(isempty(str2num(tokenised_clause{l}))))
                equation = [equation tokenised_clause{l}];
            elseif n
                k = 1;
                
                while (k < length(species))
                    if (strcmp(species{k}, tokenised_clause{l}))
                        species_index{end + 1} = k;
                        equation = [equation species{k}];
                        vars{end + 1} = sym(species{k});
                    end

                    k = k + 1;
                end
            end
            
            % deal with specific time intervals
            answered = 0;
            m = 1;
            
            sym_eq = sym(equation);
            
            while(not(answered) & m <= size(solutions, 1))
                
                for n = 1:length(vars)
                    sol = subs(sym_eq, vars{n}, solutions(m, species_index{n}));
                end
                
                if (sol & strcmp(tokenised_clause{1}, 'F'))
                    disjunction_answer = 1;
                    answered = 1;
                elseif(not(sol) & strcmp(tokenised_clause{1}, 'G'))
                    disjunction_answer = 0;
                    answered = 1;
                end
                
                m = m + 1;
            end
            
            if (strcmp(tokenised_clause{1}, 'G') & not(answered))
                disjunction_answer = 1;
            end
        end
        
        j = j + 1;
    end
    
    if (not(disjunction_answer))
        answer = 0;
    end
    
    i = i + 1;
end
    
if (answer)
    fprintf('\nTrue.\n');
else
    fprintf('\nFalse.\n');
end

end