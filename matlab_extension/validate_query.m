% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function tokenised_query = validate_query(input_query, species)

tokenised_query = {};

% remove all whitespace from the query
lbc_query = strrep(input_query, ' ', '');

% split the query's conjunctions and parse sequentially
conjunctions = strsplit(lbc_query, 'and');

conjunctions{1}

for i = 1:length(conjunctions)
    
    % per conjunction, split the disjunctions and parse sequentially
    disjunctions = strsplit(conjunctions{i}, 'or');
    
    tokenised_disjunction = {};
    
    for j = 1:length(disjunctions)
        
        index = 1;
        disjunction_size = length(disjunctions{j});
        tokenised_clause = {};

        % determine if clause begins with F or G
        if (sum(strcmp(disjunctions{j}(index), {'F', 'G'})))

            tokenised_clause{end + 1} = disjunctions{j}(index);
            index = index + 1;
            
            if (not(strcmp(disjunctions{j}(index), '(')))
                fprintf(['\nError: Parenthesis missing in clause ', disjunctions{j}, '.']);
                tokenised_query = {};
                return;
            end
            
            index = index + 1;

            % parse bounds on time (inside braces) if one exists
            if (strcmp(disjunctions{j}(index), '{'))
                tokenised_clause{end + 1} = '{';
                index = index + 1;

                end_cond = strfind(disjunctions{j}, '}');

                if (isempty(end_cond))
                    fprintf(['\nError: End brace missing for time bounds in clause ', disjunctions{j}, '.']);
                    tokenised_query = {};
                    return;
                end

                % retrieve the time bounds and confirm they are appropriate
                bounds = strsplit(disjunctions{j}(index:end_cond), ',');

                if (length(bounds) > 2)
                    fprintf(['\nError: Clause ', disjunctions{j}, ' holds too many time bounds in the braces. Only two permitted.']);
                    tokenised_query = {};
                    return;
                else
                    k = 1;

                    for k = 1:2
                        if (not(str2num(bounds{k})) || str2num(bounds{k}) < 0)
                            fprintf(['\nError: Clause ', disjunctions{j}, ' holds invalid time bounds.']);
                            tokenised_query = {};
                            return;
                        end
                    end
                end

                tokenised_clause{end + 1} = bounds{1};
                tokenised_clause{end + 1} = bounds{2};
                tokenised_clause{end + 1} = '}';

                index = end_cond + 1;
            end
        end
        
        % identify the square brackets for species concentration
        if (not(strcmp(disjunctions{j}(index), '[')))
            fprintf(['\nError: Clause ', disjunctions{j}, ' missing square brackets around the species name.']);
            tokenised_query = {};
            return;
        end
        
        index = index + 1;
        
        max_species_length = 0;
        
        for p = 1:length(species)
            if (length(species{p}) > max_species_length)
                max_species_length = length(species{p});
            end
        end
               
        end_bracket = strfind(disjunctions{j}(index:index + max(max_species_length)), ']');
        
        if (isempty(end_bracket))
            fprintf(['\nError: End bracket missing for concentration in clause ', disjunctions{j}, '.']);
            tokenised_query = {};
            return;
        end
        
        % confirm the species name in the bracket exists for this model
        species_found = 0;
        m = 1;
        
        while (not(species_found) & m <= length(species))
            if (strcmp(species{m}, disjunctions{j}(index:(index + end_bracket - 2))))
                species_found = 1;
                tokenised_clause{end + 1} = species{m};
            end
            m = m + 1;
        end
        
        
        if (not(species_found))
            fprintf(['\nError: Invalid species named in clause ', disjunctions{j}, '.']);
            tokenised_query = {};
            return;
        end

        index = index + end_bracket;
        
        % confirm there exists a comparison sign for the clause    
        if (sum(strcmp(disjunctions{j}(index:index + 1), {'<=', '>=', '!='})))
            tokenised_clause{end + 1} = disjunctions{j}(index:index + 1);
            index = index + 2;
        elseif (strcmp(disjunctions{j}(index), '='))
            tokenised_clause{end + 1} = '==';
            index = index + 1;
        elseif (sum(strcmp(disjunctions{j}(index), {'<', '>'})))
            tokenised_clause{end + 1} = disjunctions{j}(index);
            index = index + 1;
        else
           fprintf(['\nError: Comparison sign missing from clause ', disjunctions{j}, '.']);
           tokenised_query = {};
           return;
        end
        
        % parse the right hand side expression of the equality
        if (isempty(str2num(disjunctions{j}(index:disjunction_size - 1))) && not(strcmp(disjunctions{j}(index), '(')))
            fprintf(['\nError: Invalid expression after the comparison sign in clause ', disjunctions{j}, '.']);
            tokenised_query = {};
            return;
        elseif(strcmp(disjunctions{j}(index), '('))
            tokenised_clause{end + 1} = '(';
            index = index + 1;
            
            % strip operators away and work with terms in the expression
            equality_expression = strsplit(disjunctions{index:disjunction_size}, {'+', '-', '*', '/'});
            operator_locations = strfind(disjunctions{index:disjunction_size}, {'+', '-', '*', '/'});
            
            p = 1;
            
            % parse each term in the expression sequentially
            while (p <= length(equality_expression))
                index = 1;
                
                % confirm that nonumeric terms are species concentrations
                if (not(str2num(equality_expression{p})))
                   if (not(strcmp(equality_expression{p}(index), '[')))
                        fprintf(['\nError: Clause ', disjunctions{j}, ' missing square brackets around the species name.']);
                        tokenised_query = {};
                        return;
                    end

                    index = index + 1;

                    end_bracket = strfind(equality_expression(p, index:max(length(species))), ']');

                    if (isempty(end_bracket))
                        fprintf(['\nError: End bracket missing for concentration in clause ', disjunctions{j}, '.']);
                        tokenised_query = {};
                        return;
                    end

                    species_found = 0;
                    m = 1;

                    while (not(species_found) & m <= length(species))
                        if (strcmp(species{m}, equality_expression{p}(index:end_bracket-1)))
                            tokenised_clause{end + 1} = species{m};
                            species_found = 1;
                        end
                        m = m + 1;
                    end

                    if (not(species_found))
                        fprintf(['\nError: Invalid species named in clause ', disjunctions{j}, '.']);
                        tokenised_query = {};
                        return;
                    end
                    
                elseif (str2num(equality_expression{p}) <= 0)
                    
                   fprintf(['\nError: Nonpositive concentration constraint detected in clause ', disjunctions{j}, '.']);
                   tokenised_query = {};
                   return;
                   
                else
      
                    tokenised_clause{end + 1} = equality_expression{p};
                end
                
                if (p < length(equality_expression))
                    tokenised_clause{end + 1} = disjunctions{j}(operator_locations(p));
                end
            end
        elseif (strcmp(disjunctions{j}(disjunction_size), ')'))
            tokenised_clause{end + 1} = disjunctions{j}(index:disjunction_size - 1);
        else
            tokenised_clause{end + 1} = disjunctions{j}(index:disjunction_size);
        end
        
        tokenised_disjunction{end + 1} = tokenised_clause;
    end
   
    tokenised_query{end + 1} = tokenised_disjunction;
end

end