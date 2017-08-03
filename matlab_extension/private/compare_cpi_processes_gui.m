% this Matlab script collection extends the Continuous Pi Workbench, CPiWB
% author: Ross Rhodes, adapted to GUI by Luke Paul Buttigieg 
% description: A user can compare up to four CPi processes using this
% function. The CPi processes are simulated, and then plotted either 
% on seperate graphs or on one graph.

function compare_cpi_processes_gui(handles, process_map, file_map)

t = {};
solutions = {};
process_names = {};
process_definitions = {};
definition_tokens = {};
num_definitions = {};
file_names = {};

%Identify selected solver
selection=get(handles.popupmenu5,'value');
solver_names=get(handles.popupmenu5,'string');

chosen_solver = solver_names{selection,:};

% determine the number of processes to be modelled. Min 2, Max 4
selection2=get(handles.popupmenu6,'value');
process_nums=get(handles.popupmenu6,'string');

process_num = process_nums{selection2,:};
% Converting process number to double
process_num = str2double(process_num);

% Assert that files were selected for all the processes
for p = 1:process_num;
    curr_fname = strcat('fname',num2str(p));
    
    if(isempty(file_map(curr_fname)) == 1);
        errordlg(strcat('Process: ', num2str(p),' does not appear selected.'),'Process Not Selected');
        return;
    end 
end 

% determine the time frame to model for comparison
start_time = get(handles.edit12,'String'); 
end_time = get(handles.edit13,'String'); 

%Converting time inputs to double
start_time_db  = str2double(start_time);
end_time_db  = str2double(end_time);
    
if (start_time_db >= end_time_db);
    errordlg('Error: End time must exceed the start time.','Time Error');
    return;
end

i = 0;

while (i < process_num);
    
    [t, solutions, new_process_names, new_process_definitions, ...
        new_definition_tokens, new_num_definitions, new_file_name] = ...
        construct_new_system_for_comparison_gui(t, solutions, i, ...
        end_time_db, chosen_solver, process_map, file_map);

    if (isempty(new_process_names))
        return;
    end
    
    for m = 1:length(new_process_names)
        process_names{end + 1} = new_process_names{m};
        process_definitions{end + 1} = new_process_definitions{m};
        definition_tokens{end + 1} = new_definition_tokens{m};
        num_definitions{end + 1} = new_num_definitions{m};
        file_names{end + 1} = new_file_name;
    end
    
    i = i + length(new_process_names);
end

% determine whether to simulate on a single or multiple plots

selection3=get(handles.popupmenu7,'value');
plot_types=get(handles.popupmenu7,'string');

plot_type = plot_types{selection3,:};

if (strcmp(plot_type, 'Together'))
    single_plot_comparison_gui(process_names, process_definitions, ...
        definition_tokens, num_definitions, t, solutions, file_names, process_num, start_time_db);
else 
    separate_plot_comparison_gui(process_names, process_definitions, ...
        definition_tokens, num_definitions, t, solutions, file_names, process_num, start_time_db);
end

end
