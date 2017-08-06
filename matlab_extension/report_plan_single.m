
function report_plan_single

  
report_content = struct('Code',1,'ODEs',0,'Plot',0,'Num',0,'toc',0);
chosen_solvers = {};
ode_solvers = {'ode15s (default)'; 'ode23s'; 'ode23t'; 'ode23tb'};
definition_tokens = [];
num_definitions = 0;
process_name_options = {};
process_def_options = {};
start_time = 0;
end_time = 0;
save_name = '';
saving_path = '';
file_name = '';
process_name = '';
process_def = '';
font = [];


% Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[600,600,600,500]);
f.MenuBar = 'none';
f.Color = [1,1,1];

%  Create panels.     
panel_content = uipanel('Parent',f,...
               'Title','Choose Report Content',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .62 .3 .3]);

panel_save = uipanel('Parent',f,...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .34 .3 .25]);
           
panel_option = uipanel('Parent',f,...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Title','More (optional)',...
               'Position',[.05 .15 .3 .17]);
           
panel_simulate = uipanel('Parent',f,...
               'Title','Simulation & Numerical Solutions',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.4 .15 .55 .8]);
           
panel_odes = uipanel('Parent',panel_simulate,...
               'Title','ODEs',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .5 .9 .5]);
           
panel_code = uipanel('Parent',panel_odes,...
               'Title','Code',...
               'BackgroundColor',[1,1,1],...
               'Visible','on',...
               'Position',[.05 .5 .9 .5]);

% Construct the components. 
rp_code = uicontrol('Parent',panel_content,...
        'Style','checkbox',...
        'String','Code',...
        'Position',[15,80,100,25],...
        'Value',1,...
        'BackgroundColor',[1,1,1],...
        'Callback',@report_code_Callback); 

rp_odes = uicontrol('Parent',panel_content,...
      'Style','checkbox','String','ODEs',...
      'Position',[15,60,100,25],...
      'BackgroundColor',[1,1,1],...
      'Callback',@report_odes_Callback); 

rp_plot = uicontrol('Parent',panel_content,...
      'Style','checkbox','String','Plot',...
      'Position',[15,40,100,25],...
      'BackgroundColor',[1,1,1],...
      'Callback',@report_plot_Callback);  

rp_num = uicontrol('Parent',panel_content,...
      'Style','checkbox','String','Numerical Solutions ',...
      'Position',[15,20,170,25],...
      'BackgroundColor',[1,1,1],...
      'Callback',@report_num_Callback);
  
  
save_path = uicontrol('Parent',panel_save,...
      'Style','pushbutton','String','Save to...',...
      'Position',[15,85,80,25],...
      'BackgroundColor',[1,1,1],...
      'Tag','save_path',...
      'Callback',@save_path_Callback);
  
%path will display after choosing a path 
save_text = uicontrol('Parent',panel_save,...
             'Style','text',...
             'String','',...
             'HorizontalAlignment','left',...
             'BackgroundColor',[1,1,1],...
             'Position',[15,15,150,60]);   
         
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
           'Position',[15, 35, 80 25],...
           'String','Font',...
           'BackgroundColor',[1,1,1],...
           'Callback',@font_option_Callback);   

rp_toc = uicontrol('Parent',panel_option,...
      'Style','checkbox','String','Table of Contents',...
      'Position',[15,5,170,25],...
      'BackgroundColor',[1,1,1],...
      'Callback',@report_toc_Callback);  
       
file_name_button = uicontrol(panel_code,'Style','pushbutton',...
                 'String','Choose a model',...
                 'Position',[15,40,130,25],...
                  'BackgroundColor',[1,1,1],...
                 'Tag','filename',...
                 'Callback',@file_name_Callback);

% model name will display after choosing a model             
file_text = uicontrol(panel_code,'Style','text',...
               'String','',...
               'BackgroundColor',[1,1,1],...
               'HorizontalAlignment','left',...
               'Position',[20,15,230,15]);


process_text = uicontrol(panel_odes,'Style','text',...
       'String','Select process',...
       'BackgroundColor',[1,1,1],...
       'HorizontalAlignment','left',...
       'Position',[30,60,100,15]);

%Get process option in file_name_callback 
process_popup = uicontrol(panel_odes,'Style','popupmenu',...
         'String','...',...
         'Tag','process_popup',...
          'BackgroundColor',[1,1,1],...
         'Position',[35,25,100,25],...
          'Enable', 'off',...
         'Callback',@process_popup_Callback);
     
solvertext = uicontrol(panel_simulate,'Style','text',...
      'String','Select solvers',...
      'BackgroundColor',[1,1,1],...
      'HorizontalAlignment','left',...
      'Position',[50,165,100,15]);

% could choose more than one solver
solvermeun = uicontrol(panel_simulate,'Style','listbox',...
      'String',ode_solvers,...
      'Position',[55,85,180,70],...
       'BackgroundColor',[1,1,1],...
      'Max',2,'Min',0,'Value',[],...
      'Enable','off' ,...
      'Callback',@solver_popup_Callback);   

starttimetext = uicontrol(panel_simulate,'Style','text',...
        'String','start time: ',...
      'Position',[50,50,70,15],...
      'HorizontalAlignment','left',...
      'BackgroundColor',[1,1,1]);

starttime = uicontrol(panel_simulate,'Style','edit',...
      'Position',[125,50,70,25],...
      'String',start_time,...
      'Enable','off' ,...
      'Callback',@start_time_Callback);
  

endtimetext = uicontrol(panel_simulate,'Style','text',...
         'String','end time: ',...
         'BackgroundColor',[1,1,1],...
         'HorizontalAlignment','left',...
         'Position',[50,15,70,15]);

endtime = uicontrol(panel_simulate,'Style','edit',...
      'Position',[125,15,70,25],...
      'String',end_time,...
      'Enable','off' ,...
      'Callback',@end_time_Callback);
 

% Initialize the GUI.
% Change units to normalized so components resize 
% automatically.
f.Units = 'normalized';
rp_code.Units = 'normalized';
rp_odes.Units = 'normalized';
rp_plot.Units = 'normalized';
rp_num.Units = 'normalized';
starttimetext.Units = 'normalized';
starttime.Units = 'normalized';
endtimetext.Units = 'normalized';
endtime.Units = 'normalized';
solvertext.Units = 'normalized';
solvermeun.Units = 'normalized';
process_text.Units = 'normalized';
process_popup.Units = 'normalized';
file_name_button.Units = 'normalized';
file_text.Units = 'normalized';
btn.Units = 'normalized';
reset.Units = 'normalized';
generaterp.Units = 'normalized';
save_path.Units = 'normalized';
save_text.Units = 'normalized';


f.Name = 'Report Plan: Simulate Single Process';
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
f.Visible = 'on';

   function reset_Callback(source,eventdata) 
      delete(gcf);
      report_plan_single;
   end
    
   function back_Callback(source,eventdata) 
      delete(gcf);
      report_plan;
   end

   function font_option_Callback(source,eventdata) 
        font = uisetfont();
   end
 
   function file_name_Callback(source,eventdata) 
       
      process_name = '';  
      [file_name, file_path, ~] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

      if (not(file_name))
         return;
      end      
      
      %definitions = display_definitions(file_name, file_path);
      %definitions = strtrim(definitions);
      
      filename_tokens = strsplit(file_name, '.cpi');
      model_name = strrep(filename_tokens(1),'_',' ');
      model_name = regexprep(model_name,'(\<[a-z])','${upper($1)}');
      
      file_text.String = model_name;
      cpi_defs = fileread(strcat(file_path, '/', file_name));  
     
      if(isempty(cpi_defs))
         errordlg('No definitions. Please choose another model');
         return
      end
      source.UserData = struct('cpi_Defs',cpi_defs, 'model_Name',model_name);
      [process_name_options, process_def_options, definition_tokens, ...
                       num_definitions] = retrieve_process_definitions(cpi_defs);                
      process_popup.String = process_name_options;    
      %process_popup.Value = 1; 
   end

 

   function process_popup_Callback(source,eventdata) 
         % Determine the process 
          if strcmp(file_name,'')
             errordlg('Please choose a model');
             return
          end
         
          selection = source.Value;
          process_name = process_name_options{selection};
          process_def = process_def_options{selection};
          
          if strcmp(process_name,'')
             return;
          end
      
          %source.UserData = struct('proc_name',process_name,'proc_def',process_def);
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


   function solver_popup_Callback(source,eventdata) 
       index_selection = get(source,'Value');
       chosen_solvers = {};
       for i = 1:length(index_selection)
           ode_name = strsplit(ode_solvers{index_selection(i)}, ' ');
           chosen_solvers{end + 1} = ode_name{1};
       end 
   end


   function report_toc_Callback(source,eventdata)
        report_content.toc = source.Value;       
   end

   function report_code_Callback(source,eventdata) 
        report_content.Code = source.Value;       
   end 

   function report_odes_Callback(source,eventdata) 
        report_content.ODEs = source.Value;   
        if report_content.ODEs == 1 || report_content.Plot ==1 || report_content.Num ==1
            process_popup.Enable = 'on';
        elseif report_content.ODEs == 0 && report_content.Plot ==0 && report_content.Num ==0
            process_popup.Enable = 'off';
        end
   end 


   function report_plot_Callback(source,eventdata)   
        report_content.Plot = source.Value;
        if report_content.Plot ==1 || report_content.Num ==1
            starttime.Enable = 'on';
            endtime.Enable = 'on';
            solvermeun.Enable = 'on';
        elseif report_content.Plot ==0 && report_content.Num ==0
            starttime.Enable = 'off';
            endtime.Enable = 'off';
            solvermeun.Enable = 'off';
        end
        
        if report_content.ODEs == 1 || report_content.Plot ==1 || report_content.Num ==1
            process_popup.Enable = 'on';
        elseif report_content.ODEs == 0 && report_content.Plot ==0 && report_content.Num ==0
            process_popup.Enable = 'off';
        end
   end 
    


   function report_num_Callback(source,eventdata)   
        report_content.Num = source.Value;  
        if report_content.Plot ==1 || report_content.Num ==1
            starttime.Enable = 'on';
            endtime.Enable = 'on';
            solvermeun.Enable = 'on';
        elseif report_content.Plot ==0 && report_content.Num ==0
            starttime.Enable = 'off';
            endtime.Enable = 'off';
            solvermeun.Enable = 'off';
        end
        
        if report_content.ODEs == 1 || report_content.Plot ==1 || report_content.Num ==1
            process_popup.Enable = 'on';
        elseif report_content.ODEs == 0 report_content.Plot ==0 && report_content.Num ==0
            process_popup.Enable = 'off';
        end
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


   function generate_report_Callback(source,eventdata) 
 
      
      if strcmp(file_name, '')
          errordlg('Please choose a Model.'); 
          return;
      end
      
      h1 = findobj('Tag','filename'); 
      data1 = h1.UserData; 
      cpi_defs = data1.cpi_Defs;
      model_name = data1.model_Name;
      
      if strcmp(saving_path, '')
          errordlg('Please choose a path to save your report.'); 
          return;
      end  
      
      if (report_content.Code==0 && report_content.ODEs==0 && report_content.Plot==0 && report_content.Num ==0)
            errordlg('No report content is added.');
            return;
      end
      % code
      if report_content.Code==1 && report_content.ODEs==0 && report_content.Plot==0 && report_content.Num==0
         report_generate_single(model_name, process_name,cpi_defs,save_name,saving_path,report_content,font); 
   
      % (code) + odes   
      elseif report_content.ODEs==1 && report_content.Plot==0 && report_content.Num==0
         
%           if not(exist('process_name'))
%             errordlg('Please choose a process.'); 
%             return;
%          end
%           
%          h2 = findobj('Tag','process_popup');
%          data2 = h2.UserData; 
%          process_name = data2.proc_name;
%          
         if strcmp(process_name, '')
            errordlg('Please choose a process.'); 
            return;
         end
         
         fprintf('\n\nConstructing the ODEs ... ');   
         [odes, ode_num, ~] = create_cpi_odes(cpi_defs, process_name);         
         
         if (not(ode_num))
             errordlg('No ODEs.'); 
             return;
         end
         
         fprintf('Done.');
         report_generate_single(model_name, process_name,cpi_defs,save_name,saving_path,report_content,font,odes); 
        
      % (code) + (odes) + (plot) + (numeritic)
      elseif  report_content.Plot==1 || report_content.Num==1
%          h2 = findobj('Tag','process_popup');
%          data2 = h2.UserData; 
%          process_name = data2.proc_name;
%          process_def = data2.proc_def; 
          
         if start_time >= end_time
          errordlg('End time must exceed the start time.');
          return
         end
         
         if strcmp(process_name, '')
            errordlg('Please choose a process.'); 
            return;
         end
         
         fprintf('\n\nConstructing the ODEs ... ');   
         [odes, ode_num, initial_concentrations] = create_cpi_odes(cpi_defs, process_name);         
         if (not(ode_num))
             errordlg('No ODEs.'); 
             return;
         end
         fprintf('Done.');
         
         if (not(length(chosen_solvers)))
             errordlg('Please choose a solve.');
            return;
         end
         
         
         [legend_strings, species_num] = prepare_legend(process_def, ...
            definition_tokens, num_definitions);

         fprintf('\nSolving the system ... ');
         
         isreport = 1;
         [t, Y] = solve_cpi_odes(odes, ode_num, initial_concentrations, end_time, ...
                 chosen_solvers, legend_strings,isreport);
         
         if (isempty(t)) 
              return;
         end
      
        if report_content.Num == 1 && (size(Y{1}, 1) > 1500)
             choice = questdlg('Too many numerical solutions. Are you sure present them in report?', ...
                                'Numerical Solutions...', ...
                                'Yes','No','cancel','No');
                            
             if strcmp(choice,'No')
                 report_content.Num = 0;
             elseif strcmp(choice,'cancel')
                 return
             end
        end
        

        
        create_process_simulation(t, Y, start_time, file_name, ...
            process_name, chosen_solvers, legend_strings, species_num);
                
         plot_path = [saving_path,'my.png'];
         saveas(gcf,plot_path);
              
         report_generate_single(model_name, process_name, cpi_defs, save_name, saving_path,...
                   report_content,font,odes,start_time,end_time,chosen_solvers,legend_strings,t,Y); 
         
         % delete plot figure window
         delete(plot_path);
         delete(gcf);

      else
          return    
      end
   
   end 
end 