function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-Jul-2017 16:40:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Reset the value of the global file name and path
global fname;
global pname;
global definitions;
fname=0;
pname=0;
definitions = '';

%Show Edit Models Panel when opening application
global current_panel;
current_panel = change_panel('~','uipanel6',handles);
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;
global pname;
global current_panel;
current_panel = change_panel(current_panel,'uipanel6',handles);

if(~isequal(fname,0));
    %Making the filepath persistent across screens
    filepath = fullfile(pname, fname);
    set(handles.edit2,'string',filepath);
    
    %Opening the file
    openfile_editmodel(handles);
end 

%file = fullfile('icons','pencil-64.gif');
%[x,map]=imread(file);

%I2=imresize(x,[42 113]);

%f = figure;
%imagesc(x);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
global fname;
global pname;

current_panel = change_panel(current_panel,'uipanel1',handles);

if(~isequal(fname,0));
    %Making the filepath persistent across screens
    filepath = fullfile(pname, fname);
    set(handles.edit3,'string',filepath);
    
    %Opening the file
    openfile_viewodes(handles);
else(isequal(fname,0));
    %Resetting screen
    reset_viewodes(handles);
end 

%Reset View ODEs screen
function reset_viewodes(handles)
 set(handles.edit3,'string','');
 set(handles.edit4,'string','','enable','off');
 set(handles.edit5,'string','','enable','off');
 set(handles.popupmenu1,'String','Process List');

%Reset View ODEs screen
function reset_simulate(handles)
 set(handles.edit6,'string','');
 set(handles.edit7,'string','','enable','off');
 set(handles.popupmenu2,'String','Process List');
 
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel4',handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel3',handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel5',handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
global fname;
global pname;
current_panel = change_panel(current_panel,'uipanel2',handles);

if(~isequal(fname,0));
    %Making the filepath persistent across screens
    filepath = fullfile(pname, fname);
    set(handles.edit6,'string',filepath);
    
    %Opening the file
    openfile_simulate(handles);
else(isequal(fname,0));
    %Resetting screen
    reset_simulate(handles);
end 

function current_panel = change_panel(old_panel, new_panel, handles)
%TODO: do not allow panel to change if the new panel is the old panel
if old_panel ~= '~'
    set(handles.(old_panel),'visible','off');
    
end 
    
set(handles.(new_panel),'visible','on'); 
current_panel = new_panel;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;
global pname;
[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if(~isequal(Ifname,0));
    
    %Setting global variables
    fname = Ifname;
    pname = Ipname;
    
    openfile_editmodel(handles);
    
end

%Function to open file in the Edit Model screen
function openfile_editmodel(handles)
    global pname;
    global fname;
    
    %Create the file path and populate the text field
    filepath = fullfile(pname, fname);
    set(handles.edit2,'string',filepath);
    
    %Read the text file
    M=textread(filepath,'%s','delimiter','\n');
    set(handles.edit1,'string',M);
    set(handles.edit1,'Enable','on'); 

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 file_path = get(handles.edit2,'String'); 
 file_content = get(handles.edit1,'String'); 
 if isempty(file_path)
   errordlg('Error: File Path cannot be empty');
 else
   fid=fopen(file_path,'w');

   fprintf(fid,'%s\n',file_content{:});
   
   fclose(fid);
 end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with three options
global pname;
global fname;

%Confirm user wants to close the file
 file_path = get(handles.edit2,'String'); 
 
if (~isempty(file_path))
choice = questdlg('Are you sure you want to close the file? Any unsaved changes will be lost.', ...
	'Close Button Confirmation', ...
	'Yes','Cancel','Cancel');
% Handle response
    if(isequal(choice,'Yes'));
        set(handles.edit1,'String',''); 
        set(handles.edit1,'Enable','off'); 
        set(handles.edit2,'String',''); 
        set(handles.text2,'string','Status: Ready');
        set(handles.text2,'Position',[0.833 0.5 17.333 1.083]);
        pname=0;
        fname=0;
    end
end



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit1.
function edit1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
enableString = get(handles.edit1, 'Enable');

if(isequal(lower(enableString), 'on'));
    set(handles.text2,'string','Status: Editing file contents');
    set(handles.text2,'Position',[2.5 0.5 17.333 1.083]);
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;
global pname;
[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

%Ensuring a file was selected
if(~isequal(Ifname,0));
    
    %Setting global variables
    fname = Ifname;
    pname = Ipname;
    
    %Open file
    openfile_viewodes(handles);
    
end

%Open file in View ODEs screen
function openfile_viewodes(handles)
    global pname;
    global fname;
    global definitions;

    %Clearing current data
    reset_viewodes(handles);
    
    %Creating the file path string
    filepath = fullfile(pname, fname);
    set(handles.edit3,'string',filepath);
    
    %Reading the file
    definitions = fileread(strcat(pname, '/', fname));
    set(handles.edit4,'string',definitions, 'enable','inactive');
     
    %Populating the process list dialog box
    [process_name_options, ~, ~, ...
    ~] = retrieve_process_definitions(definitions);
    set(handles.popupmenu1,'String',process_name_options);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;

if(~isequal(fname,0));
    %Open file again
    openfile_viewodes(handles);
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;
global definitions;

if(~isequal(fname,0));
    %Updating the status string
    set(handles.text6,'string','Status: Generating the ODEs');
    set(handles.text6,'Position',[0.8 0.5 30 1.0833333333333333]);
    pause(0.02);

    %Getting the currently selected process
    selection=get(handles.popupmenu1,'value');
    process_name=get(handles.popupmenu1,'string');
    
    %Obtaining the ODEs
    [modelODEs, ode_num, ~] = create_cpi_odes(definitions, process_name{selection,:});

    %Setting the ODEs to the text edit content
    set(handles.edit5,'string',modelODEs, 'enable','inactive');

    %Resetting the status string
    set(handles.text6,'string','Status: Ready');
    set(handles.text6,'Position',[0.833 0.5 17.333 1.083]);
end
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get generated ODEs
file_content = get(handles.edit5,'String'); 

if(~isequal(file_content,''));
    %Get file details
    [FileName,PathName,~] = uiputfile('*.txt','Text Files (*.txt)','ODE.txt');
    
    %Create file and export contents
    if(~isequal(FileName,0));
        
        %Updating the status field
        set(handles.text6,'string','Status: Saving the file...');
        set(handles.text6,'Position',[0.8 0.5 30 1.0833333333333333]);
        pause(0.02);
        
        %Create full filepath
        filepath = fullfile(PathName, FileName);

        %Open file
        fid=fopen(filepath,'wt');

        %Get content from text edit, and fprintf it
        fprintf(fid,'%s\n',file_content{:});

        %Close file
        fclose(fid);
        
        %Resetting the status string
        set(handles.text6,'string','Status: Ready');
        set(handles.text6,'Position',[0.833 0.5 17.333 1.083]);
    end 
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton10.
function pushbutton10_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global definitions;
global fname;

%Simulating the process after getting the selected parameters
if(~isequal(fname,0));
    %Getting start and end time
    start_time = get(handles.edit8,'String'); 
    end_time = get(handles.edit9,'String'); 
    
    if(not(isstrprop(start_time, 'digit')));
        errordlg('The start time is not a digit.','Start Time Error');
        return;
    elseif (not(isstrprop(end_time, 'digit')));
        errordlg('The end time is not a digit.','End Time Error');
        return;
    elseif (str2double(start_time) < 0);
        errordlg('The start time is negative.','Start Time Error');  
        return;
    elseif (str2double(end_time) < 0);
        errordlg('The end time is negative.','End Time Error'); 
        return;
    elseif (isempty(start_time));
        errordlg('The start time is blank.','Start Time Error'); 
        return;    
    elseif (isempty(end_time));
        errordlg('The end time is blank.','End Time Error'); 
        return;   
    end
    
    %Converting time inputs to double
    start_time_db  = str2double(start_time);
    end_time_db  = str2double(end_time);
    
    if (start_time_db >= end_time_db);
        errordlg('Error: End time must exceed the start time.','Time Error');
        return;
    end
    
    %Updating the status string
    set(handles.text10,'string','Status: Simulating the model...');
    set(handles.text10,'Position',[0.8 0.5 30 1.0833333333333333]);
    pause(0.02);

    %Getting the currently selected process
    selection=get(handles.popupmenu2,'value');
    process_name=get(handles.popupmenu2,'string');
    
    %Getting the currently selected solver
    selection2=get(handles.popupmenu3,'value');
    solver_name=get(handles.popupmenu3,'string');
    
    %Obtaining the ODEs
    [odes, ode_num, initial_concentrations] = create_cpi_odes(definitions, process_name{selection,:});

    % Creating the plot...
    % Setup the legend for the simulation
    [~, process_def_options, definition_tokens, ...
    num_definitions] = retrieve_process_definitions(definitions);

    [legend_strings, species_num] = prepare_legend(process_def_options{selection}, ...
    definition_tokens, num_definitions);

    %TODO: Adapt solve_cpi_odes to GUI
    [t, Y] = solve_cpi_odes_gui(odes, ode_num, initial_concentrations, end_time_db, ...
    solver_name(selection2,:), legend_strings);

    if (isempty(t))
        return;
    end
        
    % TODO: Adapt create_process_simulation to GUI
    % simulate the solution set for the specified time period
    create_process_simulation(t, Y, start_time_db, fname, ...
    process_name(selection,:), solver_name(selection2,:), legend_strings, species_num);
    
    % Resetting the status string
    set(handles.text10,'string','Status: Ready');
    set(handles.text10,'Position',[0.833 0.5 17.333 1.083]);
end 

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;
global pname;
[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

%Ensuring a file was selected
if(~isequal(Ifname,0));
    
    %Setting global variables
    fname = Ifname;
    pname = Ipname;
    
    %Open file
    openfile_simulate(handles);
    
end

%Open file in View ODEs screen
function openfile_simulate(handles)
    global pname;
    global fname;
    global definitions;

    %Clearing current data
    reset_simulate(handles);
    
    %Creating the file path string
    filepath = fullfile(pname, fname);
    set(handles.edit6,'string',filepath);
    
    %Reading the file
    definitions = fileread(strcat(pname, '/', fname));
    set(handles.edit7,'string',definitions, 'enable','inactive');
     
    %Populating the process list dialog box
    [process_name_options, ~, ~, ...
    ~] = retrieve_process_definitions(definitions);
    set(handles.popupmenu2,'String',process_name_options);

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fname;

if(~isequal(fname,0));
    %Open file again
    openfile_simulate(handles);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
