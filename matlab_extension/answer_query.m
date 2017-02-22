% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function answer_query(tokenised_query, species, t, solutions)

answer = 0;
eventually_flag = 0;

i = 1;

while(not(answer) & i <= length(tokenised_query))
    conjunction_answer = 1;
    j = 1;
    
    while (conjunction_answer & j <= length(tokenised_query{i}))
        tokenised_clause = tokenised_query{i}{j};
        equation = [];
        vars = {};
        species_index = {};
        k = 1;
        start_index = -1;
        end_index = -1;
        
        if (length(tokenised_clause) > 2 & strcmp(tokenised_clause(1:3), 'F(G'))
            query_start = 3;
            eventually_flag = 1;
        else
            query_start = 1;
        end
        
        if (strcmp(tokenised_clause{query_start + 1}, '{'))
            
            beginning_flag = query_start + 5;
            q = 1;
            
            while (start_index == -1 & q < length(t))
                if (str2num(tokenised_clause{query_start + 2}) <= t(q + 1) & t(q) <= str2num(tokenised_clause{query_start + 2}))
                    start_index = q;
                else
                    q = q + 1;
                end
            end
            
            while (end_index == -1 & q < length(t))
                if (str2num(tokenised_clause{query_start + 3}) <= t(q + 1) & t(q) <= str2num(tokenised_clause{query_start + 3}))
                    end_index = q;
                end

                q = q + 1;
            end

        else
            beginning_flag = query_start + 1;
            start_index = 1;
            end_index = length(t);
        end
        
        while (k <= length(species))
            if (strcmp(species{k}, tokenised_clause{beginning_flag}))
                species_index{end + 1} = k;
                equation = [equation species{k}];
                vars{end + 1} = sym(species{k});
            end

            k = k + 1;
        end
        
        if (strcmp(tokenised_clause{beginning_flag + 1}, '!='))
            equation = ['not(' equation '=='];
        else
            equation = [equation tokenised_clause{beginning_flag + 1}];
        end
        
        for l = (beginning_flag + 2):length(tokenised_clause)
            if (sum(strcmp(tokenised_clause{l}, {'+', '-', '*', '/'})) || not(isempty(str2num(tokenised_clause{l}))))
                equation = [equation tokenised_clause{l}];
            else
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
        end
        
        if (strcmp(tokenised_clause{beginning_flag + 1}, '!='))
            equation = [equation ')'];
        end
            
        answered = 0;
        m = start_index;

        sym_eq = sym(equation);
        eventually_commenced = 0;

        while(not(answered) & m <= end_index)
            
            new_sym_eq = sym_eq;
            
            for n = 1:length(vars)
                new_sym_eq = subs(new_sym_eq, vars{n}, solutions(m, species_index{n}));
            end 
            
            if (eval(new_sym_eq) & strcmp(tokenised_clause{1}, 'F'))
                
                if (eventually_flag)
                    eventually_commenced = 1;
                else
                    answered = 1;
                end
                
            elseif (eventually_commenced & not(eval(new_sym_eq)))
                conjunction_answer = 0;
                answered = 1;
            elseif(not(eval(new_sym_eq)) & strcmp(tokenised_clause{1}, 'G'))
                conjunction_answer = 0;
                answered = 1;
            end

            m = m + 1;
        end
        
        if (not(answered) & (strcmp(tokenised_clause{1}, 'F')))
            conjunction_answer = 0;
        end        

        j = j + 1;
    end
    
    if (conjunction_answer)
        answer = 1;
    end
    
    i = i + 1;
end
    
if (answer)
    fprintf('\nTrue.');
else
    fprintf('\nFalse.');
end

end