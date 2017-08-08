% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes, adapted to GUI by Luke Paul Buttigieg

function answer_query_gui(tokenised_query, species, t, solutions)

query_answer = 0;
f_g_satisfiability_flag = 0;
inequality_expression_flag = 0;
denominator_vars = {};
notable_behaviour_time = 0;

i = 1;

% iterate over every clause until a final answer is reached
while(not(query_answer) && i <= length(tokenised_query))
    
    conjunction_answer = 1;
    j = 1;
    
    % iterate over every conjunction enclosed by disjunctions
    while (conjunction_answer && j <= length(tokenised_query{i}))
        tokenised_clause = tokenised_query{i}{j};
        equation = [];
        vars = {};
        clause_index = 1;
        species_indices = {};
        
        % determine clause type: F, G, or F(G currently supported
        if (strcmp(tokenised_clause{1}, 'FG'))
            query_type = 'FG';
        elseif (strcmp(tokenised_clause{1}, 'G') && ...
                isempty(strfind(tokenised_clause{1}, 'F')))
            query_type = 'G';
        elseif (strcmp(tokenised_clause{1}, 'F') && ...
                isempty(strfind(tokenised_clause{1}, 'G')))
            query_type = 'F';
        end
        
        % proceed to next component of the tokenised clause
        clause_index = clause_index + 1;
        
        % determine is a local time interval is specified
        if (strcmp(tokenised_clause{clause_index}, '{'))
            
            start_index = -1;
            q = 1;
            
            % set starting point of solution set to match interval given
            while (start_index == -1 && q < length(t{:}))
                if (str2double(tokenised_clause{clause_index + 1}) <= ...
                        t{:}(q + 1) && t{:}(q) <= str2double(tokenised_clause{clause_index + 1}))
                    start_index = q;
                else
                    q = q + 1;
                end
            end
            
            end_index = -1;
            
            % set end point of solution set to match interval given
            while (end_index == -1 && q < length(t{:}))
                if (str2double(tokenised_clause{clause_index + 2}) <= ...
                        t{:}(q + 1) && t{:}(q) <= str2double(tokenised_clause{clause_index + 2}))
                    end_index = q;
                end

                q = q + 1;
            end
            
            clause_index = clause_index + 4;
        else
            end_index = length(t{:});
            start_index = 1;
        end
        
        
        % determine which species appears prior to comparison operator
        k = 1;
        
        while (k <= length(species))
            if (strcmp(species{k}, tokenised_clause{clause_index}))
                species_indices{end + 1} = k;
                equation = [equation species{k}];
                vars{end + 1} = sym(species{k});
            end

            k = k + 1;
        end
        
        clause_index = clause_index + 1;
        
        % set equation for the operator provided
        if (strcmp(tokenised_clause{clause_index}, '!='))
            equation = ['not(' equation '=='];
            inequality_expression_flag = 1;
        else
            equation = [equation tokenised_clause{clause_index}];
        end
        
        clause_index = clause_index + 1;
        
        % iterate over remaining tokens and construct equation for eval
        for l = clause_index:length(tokenised_clause)
            
            if (sum(strcmp(tokenised_clause{l}, {'+', '-', '*'})) || ...
                    not(isnan(str2double(tokenised_clause{l}))))
                
                equation = [equation tokenised_clause{l}];
                
            elseif (strcmp(tokenised_clause{l}, '/'))
                
                % identify denominator vars to avoid division by zero
                equation = [equation '/'];
                denominator_vars{end + 1} = tokenised_clause{l + 1};
                
            else
                
                k = 1;
                
                % take note of each species name for value substitution
                while (k <= length(species))
                    if (strcmp(species{k}, tokenised_clause{l}))
                        species_indices{end + 1} = k;
                        equation = [equation species{k}];
                        vars{end + 1} = sym(species{k});
                    end

                    k = k + 1;
                end
            end
            
            clause_index = clause_index + 1;
        end
        
        % add required parenthesis in cases where not operator is used
        if (inequality_expression_flag)
            equation = [equation ')'];
        end
            
        answered = 0;
        m = start_index;

        % convert string equation to a symbolic expression for eval
        sym_eq = sym(equation);

        % iterate over solution set and determine the answer to query
        while(not(answered) && m <= end_index)
            
            new_sym_eq = sym_eq;
            
            for n = 1:length(vars)
                
                % avoid division by zero
                if (not(solutions{:}(m, species_indices{n})) && sum(ismember(denominator_vars, vars{n})))
                    errordlg(sprintf('\nError: Division by zero in this query.'));
                    return;
                else
                    new_sym_eq = subs(new_sym_eq, vars{n}, solutions{:}(m, species_indices{n}));
                end
                
            end 
            
            if (eval(new_sym_eq) && strcmp(query_type, 'F'))

                answered = 1;
                
                if (length(tokenised_query{i}) == 1 && length(tokenised_query) == 1)
                    notable_behaviour_time = t{:}(m);
                else
                    notable_behaviour_time = -1;
                end
                
            elseif (eval(new_sym_eq) && strcmp(query_type, 'FG') && not(f_g_satisfiability_flag))
                
                f_g_satisfiability_flag = 1;
                if (length(tokenised_query{i}) == 1 && length(tokenised_query) == 1)
                    notable_behaviour_time = t{:}(m);
                else
                    notable_behaviour_time = -1;
                end
                
            elseif (not(eval(new_sym_eq)) && strcmp(query_type, 'FG') && f_g_satisfiability_flag)
                
                f_g_satisfiability_flag = 0;
                if (length(tokenised_query{i}) == 1 && length(tokenised_query) == 1)
                    notable_behaviour_time = -1;
                end
                
            elseif(not(eval(new_sym_eq)) && strcmp(query_type, 'G'))
                conjunction_answer = 0;
                if (length(tokenised_query{i}) == 1 && length(tokenised_query) == 1)
                    notable_behaviour_time = t{:}(m);
                else
                    notable_behaviour_time = -1;
                end
                answered = 1;
            end

            m = m + 1;
        end
        
        if ((not(answered) && (strcmp(tokenised_clause{1}, 'F'))) || ...
                (not(f_g_satisfiability_flag) && (strcmp(tokenised_clause{1}, 'FG'))))
            conjunction_answer = 0;
        end        

        j = j + 1;
    end
    
    % if one set of conjunctions is answered, then whole query is true
    if (conjunction_answer)
        query_answer = 1;
    end
    
    i = i + 1;
end

% present answer to the user, dependent on the query_type
if (query_answer && strcmp(query_type, 'F') && not(notable_behaviour_time == -1))
    
    msgbox(sprintf(['\nFirst satisfied at time ', num2str(round(notable_behaviour_time, 2)), 's.']));
    
elseif (not(query_answer) && strcmp(query_type, 'G') && not(notable_behaviour_time == -1))
    
     if (not(notable_behaviour_time))
        msgbox(sprintf('\nNot satisfied at the beginning of the reaction.')); 
     else
        msgbox(sprintf(['\nSatisfied until time ', num2str(round(notable_behaviour_time, 2)), 's.']));
     end
     
elseif(query_answer && strcmp(query_type, 'FG') && not(notable_behaviour_time == -1))
    
    msgbox(sprintf(['\nTrue, starting at time ', num2str(round(notable_behaviour_time, 2)), 's.']));   
    
elseif (not(query_answer))
    
     msgbox(sprintf('\nFalse.'));

else
    
    msgbox(sprintf('\nTrue.'));
    
end

end