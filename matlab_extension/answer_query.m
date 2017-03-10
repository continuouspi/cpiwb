% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function answer_query(tokenised_query, species, t, solutions)

answer = 0;
satisfiability_flag = 0;
not_equal = 0;
denom_vars = {};
satifaction_time = 0;

i = 1;

while(not(answer) && i <= length(tokenised_query))
    
    conjunction_answer = 1;
    j = 1;
    
    while (conjunction_answer && j <= length(tokenised_query{i}))
        tokenised_clause = tokenised_query{i}{j};
        equation = [];
        vars = {};
        query_index = 1;
        species_index = {};
        
        clause_size = length(tokenised_clause);
        
        % determine clause type: F, G, or F(G
        if (clause_size > 2 && strcmp(tokenised_clause{1}, 'FG'))
            clause_type = 'FG';
        elseif (strcmp(tokenised_clause{1}, 'G') && ...
                isempty(strfind(tokenised_clause{1}, 'F')))
            clause_type = 'G';
        elseif (strcmp(tokenised_clause{1}, 'F') && ...
                isempty(strfind(tokenised_clause{1}, 'G')))
            clause_type = 'F';
        end
        
        query_index = query_index + 1;
        
        if (strcmp(tokenised_clause{query_index}, '{'))
            
            start_index = -1;
            q = 1;
            
            while (start_index == -1 && q < length(t{:}))
                if (str2double(tokenised_clause{query_index + 1}) <= ...
                        t{:}(q + 1) && t{:}(q) <= str2double(tokenised_clause{query_index + 1}))
                    start_index = q;
                else
                    q = q + 1;
                end
            end
            
            end_index = -1;
            
            while (end_index == -1 && q < length(t{:}))
                if (str2double(tokenised_clause{query_index + 2}) <= ...
                        t{:}(q + 1) && t{:}(q) <= str2double(tokenised_clause{query_index + 2}))
                    end_index = q;
                end

                q = q + 1;
            end
            
            query_index = query_index + 4;
        else
            end_index = length(t{:});
            start_index = 1;
        end
        
        k = 1;
        
        while (k <= length(species))
            if (strcmp(species{k}, tokenised_clause{query_index}))
                species_index{end + 1} = k;
                equation = [equation species{k}];
                vars{end + 1} = sym(species{k});
            end

            k = k + 1;
        end
        
        query_index = query_index + 1;
        
        if (strcmp(tokenised_clause{query_index}, '!='))
            equation = ['not(' equation '=='];
            not_equal = 1;
        else
            equation = [equation tokenised_clause{query_index}];
        end
        
        query_index = query_index + 1;
        
        for l = query_index:length(tokenised_clause)
            if (sum(strcmp(tokenised_clause{l}, {'+', '-', '*'})) || ...
                    not(isnan(str2double(tokenised_clause{l}))))
                equation = [equation tokenised_clause{l}];
            elseif (strcmp(tokenised_clause{l}, '/'))
                equation = [equation '/'];
                denom_vars{end + 1} = tokenised_clause{l + 1};
            else
                k = 1;
                
                while (k <= length(species))
                    if (strcmp(species{k}, tokenised_clause{l}))
                        species_index{end + 1} = k;
                        equation = [equation species{k}];
                        vars{end + 1} = sym(species{k});
                    end

                    k = k + 1;
                end
            end
            
            query_index = query_index + 1;
        end
        
        if (not_equal)
            equation = [equation ')'];
        end
            
        answered = 0;
        m = start_index;

        sym_eq = sym(equation);

        while(not(answered) && m <= end_index)
            
            new_sym_eq = sym_eq;
            
            for n = 1:length(vars)
                
                if (not(solutions{:}(m, species_index{n})) && sum(ismember(denom_vars, vars{n})))
                    return;
                else
                    new_sym_eq = subs(new_sym_eq, vars{n}, solutions{:}(m, species_index{n}));
                end
                
            end 
            
            if (eval(new_sym_eq) && strcmp(clause_type, 'F'))

                answered = 1;
                satisfaction_time = t{:}(m);
                
            elseif (eval(new_sym_eq) && strcmp(clause_type, 'FG') && not(satisfiability_flag))
                
                satisfiability_flag = 1;
                satisfaction_time = t{:}(m);
                
            elseif (not(eval(new_sym_eq)) && strcmp(clause_type, 'FG') && satisfiability_flag)
                
                answered = 1;
                conjunction_answer = 0;
                satisfaction_time = -1;
                
            elseif(not(eval(new_sym_eq)) && strcmp(clause_type, 'G'))
                conjunction_answer = 0;
                satisfaction_time = t{:}(m);
                answered = 1;
            end

            m = m + 1;
        end
        
        if ((not(answered) && (strcmp(tokenised_clause{1}, 'F'))) || ...
                (not(satisfiability_flag) && (strcmp(tokenised_clause{1}, 'FG'))))
            conjunction_answer = 0;
        end        

        j = j + 1;
    end
    
    if (conjunction_answer)
        answer = 1;
    end
    
    i = i + 1;
end
    
if (answer && strcmp(tokenised_clause{1}, 'F'))
    fprintf(['\nFirst satisfied at time ', num2str(satisfaction_time), 's.']);
elseif(not(answer) && strcmp(tokenised_clause{1}, 'F'))
    fprintf('\nFalse.');
elseif(answer && strcmp(tokenised_clause{1}, 'G'))
    fprintf('\nTrue.');    
elseif (not(answer) && strcmp(tokenised_clause{1}, 'G'))
    
     if (not(satisfaction_time))
        fprintf('\nNot satisfied at the beginning of the reaction.'); 
     else
        fprintf(['\nSatisfied until time ', num2str(satisfaction_time), 's.']);
     end
     
elseif(answer && strcmp(tokenised_clause{1}, 'FG'))
    fprintf(['\nTrue, starting at time ', num2str(satisfaction_time), 's.']);    
elseif (not(answer) && strcmp(tokenised_clause{1}, 'FG'))
     fprintf('\nFalse.');
end

end