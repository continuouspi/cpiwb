% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function tokenised_query = validate_query(input_query, species)

tokenised_query = {};
max_species_length = 0;
clause_type = {};

% remove all whitespace from the query
lbc_query = strrep(input_query, ' ', '');

% split the query's conjunctions and parse sequentially
disjunctions = strsplit(lbc_query, 'or');

% determine the length of the longest species name for later evaluation
for i = 1:length(species)
    if (length(species{i}) > max_species_length)
        max_species_length = length(species{i});
    end
end
    
for i = 1:length(disjunctions)
    
    % per conjunction, split the disjunctions and parse sequentially
    conjunctions = strsplit(disjunctions{i}, 'and');
    
    tokenised_conjunction = {};
    
    for j = 1:length(conjunctions)
        
        conjunction_size = length(conjunctions{j});
        tokenised_clause = {};
        
        % determine clause type: F, G, or F(G
        if (conjunction_size > 2 && strcmp(conjunctions{j}(1:3), 'F(G'))
            clause_type = 'FG';
            current_index = 4;
        elseif (strcmp(conjunctions{j}(1), 'G') && ...
                isempty(strfind(conjunctions{j}(3:conjunction_size), 'F')))
            clause_type = 'G';
            current_index = 2;
        elseif (strcmp(conjunctions{j}(1), 'F') && ...
                isempty(strfind(conjunctions{j}(3:conjunction_size), 'G')))
            clause_type = 'F';
            current_index = 2;
        else
            fprintf(['\nError: Clause ', conjunctions{j}, ' missing prefix F, G or F(G.']);
            tokenised_query = {};
            return;
        end

        tokenised_clause{end + 1} = clause_type;

        % parse bounds on time (inside braces) if one exists
        if (strcmp(conjunctions{j}(current_index), '{'))
            tokenised_clause{end + 1} = '{';
            current_index = current_index + 1;

            end_cond = strfind(conjunctions{j}, '}');

            if (isempty(end_cond))
                fprintf(['\nError: End brace missing for time bounds in clause ', conjunctions{j}, '.']);
                tokenised_query = {};
                return;
            end

            % retrieve the time bounds and confirm they are appropriate
            bounds = strsplit(conjunctions{j}(current_index:end_cond - 1), ',');

            if (length(bounds) > 2)
                fprintf(['\nError: Clause ', conjunctions{j}, ' holds too many time bounds in the braces. Only two permitted.']);
                tokenised_query = {};
                return;
            else

                for k = 1:2
                    if (isnan(str2double(bounds{k})) || str2double(bounds{k}) < 0)
                        fprintf(['\nError: Clause ', conjunctions{j}, ' holds invalid time bounds.']);
                        tokenised_query = {};
                        return;
                    end
                end
                
            end

            tokenised_clause{end + 1} = bounds{1};
            tokenised_clause{end + 1} = bounds{2};
            tokenised_clause{end + 1} = '}';

            current_index = end_cond + 1;
        end

        if (not(strcmp(conjunctions{j}(current_index), '(') & strcmp(conjunctions{j}(length(conjunctions{j})), ')')))
            fprintf(['\nError: Parenthesis missing in clause ', conjunctions{j}, '.']);
            tokenised_query = {};
            return;
        end

        current_index = current_index + 1;
        
        % identify the square brackets for species concentration
        if (not(strcmp(conjunctions{j}(current_index), '[')))
            fprintf(['\nError: Clause ', conjunctions{j}, ' missing square brackets around the species name.']);
            tokenised_query = {};
            return;
        end
        
        current_index = current_index + 1;
               
        end_bracket = strfind(conjunctions{j}(current_index:current_index + max(max_species_length)), ']');
        
        if (isempty(end_bracket))
            fprintf(['\nError: Invalid species named in clause ', conjunctions{j}, '.']);
            tokenised_query = {};
            return;
        end
        
        % confirm the species name in the bracket exists for this model
        species_found = 0;
        m = 1;
        
        while (not(species_found) && m <= length(species))
            if (strcmp(species{m}, conjunctions{j}(current_index:(current_index + end_bracket - 2))))
                species_found = 1;
                tokenised_clause{end + 1} = species{m};
            end
            m = m + 1;
        end
        
        
        if (not(species_found))
            fprintf(['\nError: Invalid species named in clause ', conjunctions{j}, '.']);
            tokenised_query = {};
            return;
        end

        current_index = current_index + end_bracket;
        
        % confirm there exists a comparison sign for the clause    
        if (sum(strcmp(conjunctions{j}(current_index:current_index + 1), {'<=', '>=', '!='})))
            
            tokenised_clause{end + 1} = conjunctions{j}(current_index:current_index + 1);
            current_index = current_index + 2;
            
        elseif (strcmp(conjunctions{j}(current_index), '=') && not(strcmp(conjunctions{j}(current_index + 1), '=')));
            
            tokenised_clause{end + 1} = '==';
            current_index = current_index + 1;
            
        elseif (sum(strcmp(conjunctions{j}(current_index), {'<', '>'})))
            
            tokenised_clause{end + 1} = conjunctions{j}(current_index);
            current_index = current_index + 1;
            
        else
           fprintf(['\nError: No valid comparison sign for clause ', conjunctions{j}, ' detected.']);
           tokenised_query = {};
           return;
        end
        
        % parse the right hand side expression of the equality
        if (strcmp(clause_type, 'FG'))
            rhs_expression = conjunctions{j}(current_index:conjunction_size - 2);
        else
            rhs_expression = conjunctions{j}(current_index:conjunction_size - 1);
        end
        
        if (strcmp(rhs_expression(1), '(') && strcmp(rhs_expression(length(rhs_expression)), ')'))
            rhs_expression = rhs_expression(2:length(rhs_expression)-1);
        end
        
        if (isnan(str2double(rhs_expression)) && ...
                not(strcmp(conjunctions{j}(current_index), '(')))
            
            fprintf(['\nError: Invalid expression after the comparison sign in clause ', conjunctions{j}, '.']);
            tokenised_query = {};
            
            return;
            
        else
            
            % strip operators away and work with terms in the expression
            equality_expression = strsplit(rhs_expression, {'+', '-', '*', '/'});
            operator_locations = regexp(rhs_expression, {'+', '-', '*', '/'});

            p = 1;
            
            % parse each term in the expression sequentially
            while (p <= length(equality_expression))
                current_index = 1;
                
                % confirm that nonumeric terms are species concentrations
                if(isnan(str2double(equality_expression{p})))
                    
                   if (not(strcmp(equality_expression{p}(current_index), '[')))
                        fprintf(['\nError: Clause ', conjunctions{j}, ...
                            ' missing square brackets around the species name.']);
                        tokenised_query = {};
                        return;
                    end

                    current_index = current_index + 1;

                    end_bracket = strfind(equality_expression{p}(current_index:length(equality_expression{p})), ']');

                    if (isempty(end_bracket))
                        fprintf(['\nError: End bracket missing for concentration in clause ', conjunctions{j}, '.']);
                        tokenised_query = {};
                        return;
                    end

                    species_found = 0;
                    m = 1;

                    while (not(species_found) && m <= length(species))
                        if (strcmp(species{m}, equality_expression{p}(current_index:end_bracket)))
                            tokenised_clause{end + 1} = species{m};
                            species_found = 1;
                        end
                        m = m + 1;
                    end

                    if (not(species_found))
                        fprintf(['\nError: Invalid species named in clause ', ...
                            conjunctions{j}, '.']);
                        tokenised_query = {};
                        return;
                    end
                    
                elseif (str2double(equality_expression{p}) <= 0)
                    
                   fprintf(['\nError: Nonpositive concentration constraint detected in clause ', conjunctions{j}, '.']);
                   tokenised_query = {};
                   return;
                   
                else
      
                    tokenised_clause{end + 1} = equality_expression{p};
                end
                
                if (p < length(equality_expression))
                    tokenised_clause{end + 1} = rhs_expression(operator_locations{p});
                    
                    if (strcmp(tokenised_clause{end}, ''))
                        tokenised_clause{end} = '/';
                    end
                end
                
                p = p + 1;
            end

        end
        
        tokenised_conjunction{end + 1} = tokenised_clause;
    end
   
    tokenised_query{end + 1} = tokenised_conjunction;
    tokenised_conjunction{:}
end

end