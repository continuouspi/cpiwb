% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes

function [process_name_options, process_def_options, definitions, ...
    num_definitions] = retrieve_process_definitions(cpi_defs)

process_name_options = {};
process_def_options = {};

% strip comments away from file
file_lines = strsplit(cpi_defs, '\n');

for i = 1:length(file_lines)
    
    if (not(isempty(strfind(file_lines{i}, '--'))))
        file_lines{i} = '';
    end
    
end

commentless_cpi_defs = strjoin(file_lines);

% convert the CPi file content into a list of definitions
definitions = strsplit(commentless_cpi_defs, {';'});
num_definitions = length(definitions);

% find all process definitions in the file tokens
i = 1;

while(i <= num_definitions)
    def_token = char(definitions(i));
    process_found = strfind(def_token, 'process');
    
    if (process_found)
        process_tokens = strsplit(def_token, ' ');
        process_name_options{end + 1} = process_tokens{3};
        process_def_options{end + 1} = def_token;
    end
    
    i = i + 1;
end