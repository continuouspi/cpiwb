function report_plan_multiple


process_names = {};
process_definitions = {};
definition_tokens = {};
num_definitions = {};
file_names = {};
ode_solvers = {'ode15s (default)'; 'ode23s'; 'ode23t'; 'ode23tb'};


chosen_solver='';
start_time = 0;
end_time = 0;
definations = {};
plot_type = '';
save_name= '';
saving_path='';
report_content = struct('Code',1,'Plot',1,'toc',0);
model_names = {};
font = [];
% Odes={}; 
% Ode_num={}; 
% Init_tokens={};

fig = findobj('Tag','figure_multi');
if not(isempty(fig))
     close(fig);   
end


f = figure('Visible','off','Tag','figure_multi','Position',[600,600,600,500]);
f.MenuBar = 'none';
f.Color = [1,1,1];


process_panel = uipanel('Parent',f,...
               'Title','Choose Processes',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.5 .15 .45 .8]);
           
setting_panel = uipanel('Parent',f,...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .59 .4 .35]);

panel_content = uipanel('Parent',f,...
               'Title','Choose Report Content',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .43 .4 .14]);

panel_save = uipanel('Parent',f,...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .26 .4 .15]);
           
panel_option = uipanel('Parent',f,...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Title','More (optional)',...
               'Position',[.05 .15 .4 .11]);
           
add_model = uicontrol(process_panel,'Style','pushbutton',...
          'String','Add Model (Max:4)',...
          'Position',[30,330,150,25],...
          'BackgroundColor',[1,1,1],...
          'Callback',@add_model_Callback); 
      
process_panel_1 = uipanel('Parent',process_panel,...
               'Title','Process 1',...
               'BackgroundColor',[1,1,1],...
               'Visible','off',...
               'Tag','panel1',...
               'Position',[.1 .65 .8 .19]);
           
proc_delete_1 = uicontrol('Parent',process_panel_1,...
          'Style','pushbutton',...
          'String','X',...
          'ForegroundColor','k',...
          'FontWeight','Bold',...
          'Position',[185,20,20,20],...
          'BackgroundColor',[1,1,1],...
          'Callback',@proc_delete_1_Callback); 
           %'CData',img1,...
file_text_1 = uicontrol('Parent',process_panel_1,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,32,170,15]);

proc_text_1 = uicontrol('Parent',process_panel_1,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,10,150,15]);
           
      
process_panel_2 = uipanel('Parent',process_panel,...
               'Title','Process 2',...
               'BackgroundColor',[1,1,1],...
               'Visible','off',...
               'Tag','panel2',...
               'Position',[.1 .45 .8 .19]);
           
proc_delete_2 = uicontrol('Parent',process_panel_2,...
          'Style','pushbutton',...
          'String','X',...
          'ForegroundColor','k',...
          'FontWeight','Bold',...
          'Position',[185,20,20,20],...
          'BackgroundColor',[1,1,1],...
          'Callback',@proc_delete_2_Callback); 
      
file_text_2 = uicontrol('Parent',process_panel_2,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,32,170,15]);

proc_text_2 = uicontrol('Parent',process_panel_2,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,10,150,15]);
  

process_panel_3 = uipanel('Parent',process_panel,...
               'Title','Process 3',...
               'BackgroundColor',[1,1,1],...
               'Visible','off',...
               'Tag','panel3',...
               'Position',[.1 .25 .8 .19]);
           
proc_delete_3 = uicontrol('Parent',process_panel_3,...
          'Style','pushbutton',...
          'String','X',...
          'ForegroundColor','k',...
          'FontWeight','Bold',...
          'Position',[185,20,20,20],...
          'BackgroundColor',[1,1,1],...
          'Callback',@proc_delete_3_Callback); 
      
file_text_3 = uicontrol('Parent',process_panel_3,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,32,170,15]);

proc_text_3 = uicontrol('Parent',process_panel_3,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,10,150,15]);  
  

process_panel_4 = uipanel('Parent',process_panel,...
               'Title','Process 4',...
               'BackgroundColor',[1,1,1],...
               'Visible','off',...               
               'Tag','panel4',...
               'Position',[.1 .05 .8 .19]);
           
proc_delete_4 = uicontrol('Parent',process_panel_4,...
          'Style','pushbutton',...
          'String','X',...
          'ForegroundColor','k',...
          'FontWeight','Bold',...
          'Position',[185,20,20,20],...
          'BackgroundColor',[1,1,1],...
          'Callback',@proc_delete_4_Callback); 
      
file_text_4 = uicontrol('Parent',process_panel_4,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,32,170,15]);

proc_text_4 = uicontrol('Parent',process_panel_4,...
      'Style','text',...
      'String','',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[10,10,150,15]);  
     
solver_text = uicontrol(setting_panel,'Style','text',...
          'String','Solver:',...
          'BackgroundColor',[1,1,1],...
          'HorizontalAlignment','left',...
          'Position',[20,130,70,20]);
              %  'FontWeight','Bold',...
solver_popup = uicontrol(setting_panel,'Style','popupmenu',...
          'String',ode_solvers,...
          'Position',[80,135,120,20],...
          'BackgroundColor',[1,1,1],...
          'Value',1,...
          'Callback',@solver_popup_Callback);  

plot_text = uicontrol(setting_panel,'Style','text',...
          'String','Plot:',...
          'BackgroundColor',[1,1,1],...
          'HorizontalAlignment','left',...
          'Position',[20,90,70,20]);
      
plot_popup = uicontrol(setting_panel,'Style','popupmenu',...
          'String',{'single','separate'},...
          'Position',[80,95,120,20],...
          'BackgroundColor',[1,1,1],...
          'Value',1,...
          'Callback',@plot_popup_Callback);

starttimetext = uicontrol(setting_panel,'Style','text',...
        'String','Start Time: ',...
      'Position',[20,50,75,15],...
      'HorizontalAlignment','left',...
      'BackgroundColor',[1,1,1]);

starttime = uicontrol(setting_panel,'Style','edit',...
      'Position',[100,50,70,25],...
      'String',start_time,...
      'Callback',@start_time_Callback);

endtimetext = uicontrol(setting_panel,'Style','text',...
         'String','End   Time: ',...
         'BackgroundColor',[1,1,1],...
         'HorizontalAlignment','left',...
         'Position',[20,15,75,15]);

endtime = uicontrol(setting_panel,'Style','edit',...
      'Position',[100,15,70,25],...
      'String',end_time,...
      'Callback',@end_time_Callback);

save_path = uicontrol('Parent',panel_save,...
      'Style','pushbutton','String','Save to...',...
      'Position',[15,43,80,25],...
      'BackgroundColor',[1,1,1],...
      'Tag','save_path',...
      'Callback',@save_path_Callback);
  
%path will display after choosing a path 
save_text = uicontrol('Parent',panel_save,...
             'Style','text',...
             'String','',...
             'HorizontalAlignment','left',...
             'BackgroundColor',[1,1,1],...
             'Position',[15,5,210,35]); 

rp_code = uicontrol('Parent',panel_content,...
        'Style','checkbox',...
        'String','Code',...
        'Position',[15,25,100,25],...
        'Value',1,...
        'BackgroundColor',[1,1,1],...
        'Callback',@report_code_Callback); 

rp_plot = uicontrol('Parent',panel_content,...
      'Style','checkbox','String','Plot',...
      'Position',[15,5,100,25],...
      'BackgroundColor',[1,1,1],...
      'Value',1,...
      'Callback',@report_plot_Callback);  
  
back = uicontrol('Style','pushbutton',...
           'Position',[100, 20, 60 25],...
           'String','Back',...
           'BackgroundColor',[1,1,1],...
           'Callback',@back_Callback);  

btn = uicontrol('Style','pushbutton',...
           'Position',[185, 20, 60 25],...
           'String','Close',...
           'BackgroundColor',[1,1,1],...
           'Callback','delete(gcf)');   
       
reset = uicontrol('Style','pushbutton',...
         'String','Reset',...
         'BackgroundColor',[1,1,1],...
         'Position',[270,20,60,25],...
         'Callback',@reset_Callback);   
     
generaterp = uicontrol('Style','pushbutton',...
         'String','Generate Report',...
         'BackgroundColor',[1,1,1],...
         'Position',[355,20,150,25],...
         'Callback',@generate_report_Callback);   
     
fontoption = uicontrol(panel_option,'Style','pushbutton',...
           'Position',[20, 10, 50 25],...
           'String','Font',...
           'BackgroundColor',[1,1,1],...
           'Callback',@font_option_Callback);     
       
rp_toc = uicontrol('Parent',panel_option,...
      'Style','checkbox','String','Table of Contents',...
      'Position',[90,10,170,25],...
      'BackgroundColor',[1,1,1],...
      'Callback',@report_toc_Callback);  
     
f.Name = 'Report Plan: Compare Processes';
movegui(f,'center')
f.Visible = 'on';

    function back_Callback(source,eventdata) 
      delete(gcf);
      report_plan;
   end

    function font_option_Callback(source,eventdata) 
        font = uisetfont();
    end

    function reset_Callback(source,eventdata) 
          delete(gcf);
          report_plan_multiple;
    end

    function solver_popup_Callback(source,eventdata) 
         % Determine the number of processes           
          selection = source.Value;
          chosen_solver = ode_solvers(selection);
    end
    
    function plot_popup_Callback(source,eventdata) 
          selection = source.Value;
          if selection == 1
            plot_type = 'single';
          elseif selection == 2
            plot_type = 'separate';
          end
    end

    function start_time_Callback(source,eventdata)   
       
      start_time = str2double(get(source,'String'));
      
      %check if the strat_time is positive or digit or empty
          if isnan(start_time)
              errordlg('Start time entered is nonnumeric.')          
              uicontrol(source)
              return
          elseif start_time < 0           
                errordlg('Negative start time entered.');
                return
          end
    end 
   
    function end_time_Callback(source,eventdata) 
 
       end_time = str2double(get(source,'String'));
      
      %check if the strat_time is positive or digit or empty
      if isnan(end_time)
          errordlg('End time entered is nonnumeric.')          
          uicontrol(source)
          return
      elseif end_time < 0          
          errordlg('Negative End time entered.');
          return
      elseif start_time >= end_time
          errordlg('End time must exceed the start time.');
          return
      end
    end

    function report_code_Callback(source,eventdata) 
        report_content.Code = source.Value;       
    end 

    function report_plot_Callback(source,eventdata)   
            report_content.Plot = source.Value;  
    end 

   function report_toc_Callback(source,eventdata)
        report_content.toc = source.Value;       
   end

    function save_path_Callback(source,eventdata)   
        [save_name,saving_path] = uiputfile({'*.html';'*.pdf';'*.docx'},'Save Report As');
        
        if (not(saving_path))
            save_name = '';
            saving_path = '';
        end
        save_text.String = [saving_path,save_name];
        %source.UserData = struct('s_name',save_name,'s_path',saving_path);  
    end


    function add_model_Callback(source,eventdata) 
       
      [new_file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');
      
      if (not(new_file_name))
         return;
      end      
      
      
      cpi_defs = fileread(strcat(file_path, '/', new_file_name));  
     
      if(isempty(cpi_defs))
         errordlg('No definitions. Please choose another model');
         return
      end
      
      
      
      [new_process_names, new_process_defs, new_def_tokens, new_def_token_nums] = ...
              select_multiple_processes(cpi_defs, process_names);
      
      if (not(length(new_process_names)))
          return;
      end
      
      duplicates = {};
      for m = 1:length(new_process_names)
    % confirm the new process is not a duplicate from previous choices            
         j = 1;
         duplicate = 0;
    
         while(j <= length(process_names) && not(duplicate))
        
            if (strcmp(new_process_names{m}, process_names{j}) && strcmp(new_file_name, file_names{j}))
                %errordlg(['Process ', new_process_names{m}, ' is already selected for modelling.']);
                duplicates{end+1} = new_process_names{m};
                duplicate = 1;
                %return
                %fprintf(['\nError: Process ', new_process_names{m}, ' is already selected for modelling.']);
            end
            
            if (duplicate)
                continue;
            end
            j = j + 1;
         end
%          if (duplicate)
%              continue;
%          end
      end
     

      if  (duplicate)
          if length(duplicates)==1
                errormsg = ['Process ', duplicates{1}, ' is already selected for modelling.'];
          else
              errormsg=['Process ',duplicates{1}];
              for i=2:length(duplicates)
                 errormsg = [errormsg, ' and ', duplicates{i}];
              end
              errormsg = [errormsg, ' is already selected for modelling.'];
          end
          errordlg(errormsg);
          return
      end
      
      if (not(duplicate))

        for m = 1:length(new_process_names)
         %construct and solve the system of ODEs for the selected process
             fprintf('\n\nChecking ODEs ... ');
             [~,ode_num,~] = create_cpi_odes(cpi_defs, new_process_names{m});
             
             if (ode_num)
                fprintf('Done.');
                process_names{end + 1} = new_process_names{m};
                file_names{end + 1} = new_file_name;
                process_definitions{end + 1} = new_process_defs{m};
                num_definitions{end + 1} = new_def_token_nums;
                definition_tokens{end + 1} = new_def_tokens;
                definations{end+1} = cpi_defs;
%                 Odes{end+1}=odes; 
%                 Ode_num= ode_num;
%                 Init_tokens{end+1}=init_tokens;
             else
                 return
             end
        end
      end

      
      for m = 1:length(new_process_names)
          panelth = length(process_names)-length(new_process_names)+m;
          h = findobj('Tag',['panel',num2str(panelth)]); 
          %h=h(1)
          h.Visible = 'on';
          model_name = get_model_name(new_file_name);
          model_names{end+1}= model_name;
          h.Children(2).String = ['Model: ',model_name];
          h.Children(1).String = ['Process: ',new_process_names{m}];
      end
      
    end

    function proc_delete_1_Callback(source,eventdata) 
        
          process_names(1) = [];
          file_names(1) = [];
          process_definitions(1) = [];
          num_definitions(1) = [];
          definition_tokens(1) = [];
          definations(1) = [];
          
          model_names = update_processes_disp(file_names,process_names);
    end

    
    
    function proc_delete_2_Callback(source,eventdata) 
        
          process_names(2) = [];
          file_names(2) = [];
          process_definitions(2) = [];
          num_definitions(2) = [];
          definition_tokens(2) = [];
          definations(2) = [];
          model_names = update_processes_disp(file_names,process_names);
    end


    
    function proc_delete_3_Callback(source,eventdata) 
      process_names(3) = [];
      file_names(3) = [];
      process_definitions(3) = [];
      num_definitions(3) = [];
      definition_tokens(3) = [];
      definations(3) = [];
      model_names = update_processes_disp(file_names,process_names);
    end


    
    function proc_delete_4_Callback(source,eventdata) 
      process_names(4) = [];
      file_names(4) = [];
      process_definitions(4) = [];
      num_definitions(4) = [];
      definition_tokens(4) = [];
      definations(4) = [];
      model_names = update_processes_disp(file_names,process_names);
    end



    function generate_report_Callback(source,eventdata) 
        t = {};
        solutions = {};
         if start_time >= end_time
            errordlg('End time must exceed the start time.');
            return
         end
         
         if strcmp(chosen_solver, '')
            errordlg('Please choose a solver.'); 
            return;
         end
         
         if strcmp(plot_type, '')
            errordlg('Please choose a plot type.'); 
            return;
         end
         
         if not(length(process_names))
            errordlg('Please choose a process.'); 
            return;
         end
         
         if (length(process_names)) == 1
            errordlg('Please choose at least one more process.'); 
            return;
         end
         
         if strcmp(saving_path, '')
          errordlg('Please choose a path to save your report.'); 
          return;
         end 

       for m = 1:length(process_names)

            % construct and solve the system of ODEs for the selected process
            fprintf('\n\nConstructing the ODEs ... ');
            [odes, ode_num, init_tokens] = create_cpi_odes(definations{m}, process_names{m});
            fprintf('Done.');

            fprintf('\nSolving the system ... ');
            [t{end + 1}, solutions{end + 1}] = solve_cpi_odes(odes, ode_num, init_tokens, end_time, chosen_solver, []);

             if (isempty(t{end}))
                 fprintf(['empty t.',num2str(m)]);
                return;
             end

             fprintf('Done.');
             m = m + 1;
       end

       num_processes = length(process_names);
       if (strcmp(plot_type, 'single'))
            single_plot_comparison(process_names, process_definitions, ...
                     definition_tokens, num_definitions, t, solutions, file_names, num_processes, start_time);
       else  
            separate_plot_comparison(process_names, process_definitions, ...
                        definition_tokens, num_definitions, t, solutions, file_names, num_processes, start_time);   
       end
       
       plot_path = [saving_path,'my_plot.png'];
       saveas(gcf,plot_path);
       report_generate_multiple(model_names, process_names, definations, save_name, saving_path,...
           start_time, end_time, report_content,font)
       delete(gcf);
       
    end
%Main function end
end




function [new_process_names, new_process_defs, definitions, num_definitions] = ...
    select_multiple_processes(cpi_defs, process_names)

new_process_names = {};
new_process_defs = {};
num_total=4;

[process_name_options, process_def_options, definitions, ...
    num_definitions] = retrieve_process_definitions(cpi_defs);

% request, from the user, the process to model
selection = [];

while(isempty(selection))
    [selection,ok] = listdlg('Name', 'Select Parameter(s)', ...
        'PromptString', 'Param, Line, Column', 'SelectionMode', ...
        'multiple', 'ListString', process_name_options);

    % if user requests to leave then return to main script
    if (not(ok) || not(length(selection)))
        
        return;
        
    elseif (length(selection) > num_total || (length(selection) + ...
            length(process_names)) > num_total)
        
        avail_spaces = num_total - length(process_names);
        
        if(avail_spaces == 0)
            
            errordlg('Too many processes selected. You could choose a maximum of 4 processes to simulate.');
            return
        elseif(avail_spaces == 1)
            
            h = errordlg('Too many processes selected. You may choose one more process to simulate.');
            uiwait(h);
%             fprintf(['\nError: Too many processes selected. ', ...
%                 'You may choose one more process to simulate.']);
        else
            h = errordlg(['Too many processes selected. You may choose ',...
                            num2str(avail_spaces), ' more processes to simulate.']);
            uiwait(h);
%             fprintf(['\nError: Too many processes selected. You may choose ', ...
%                 num2str(avail_spaces), ' more processes to simulate.']);
        end
        
        selection = [];
         
    else      
        
        for i = 1:length(selection)
            new_process_names{end + 1} = process_name_options{selection(i)};
            new_process_defs{end + 1} = process_def_options{selection(i)};
        end
        
    end
end

end



function model_names = update_processes_disp(file_names,process_names)
      model_names = {};  
      for m = 1:length(process_names)
          h = findobj('Tag',['panel',num2str(m)]); 
          %h=h(1)
          model_name = get_model_name(file_names{m});
          model_names{end+1} = model_name;
          h.Children(2).String = ['Model: ',model_name];
          h.Children(1).String = ['Process: ',process_names{m}];
      end
      
      h = findobj('Tag',['panel',num2str(length(process_names)+1)]);  
      %h=h(1)
      h.Children(2).String = '';
      h.Children(1).String = '';
      h.Visible = 'off';
end


function model_name = get_model_name(file_name)
      filename_tokens = strsplit(file_name, '.cpi');
      model_name = strrep(filename_tokens(1),'_',' ');
      model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
      model_name = model_name{1};

end