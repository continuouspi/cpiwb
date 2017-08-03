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

% Last Modified by GUIDE v2.5 04-Aug-2017 00:22:12

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

%Reset the values of the global file name and path map
global definitions;
global curr_fname;
global curr_pname;
global file_map;
global process_map;

keys = {'fname1','pname1','fname2','pname2','fname3','pname3','fname4','pname4'};
values = {'','','','','','','',''};
values_num = {1,1,1,1,1,1,1,1};

file_map = containers.Map(keys,values);
process_map = containers.Map(keys,values_num);
curr_fname = 'fname1';
curr_pname = 'pname1';

definitions = '';

%Show Edit Models Panel when opening application
global current_panel;
current_panel = change_panel('~','uipanel6',handles);
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Preselect first radiobutton 
set(handles.uibuttongroup4,'selectedobject',handles.radiobutton1)


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
global curr_fname;
global curr_pname;
global file_map;
global current_panel;
current_panel = change_panel(current_panel,'uipanel6',handles);

if(isempty(file_map(curr_fname)) == 0);
    %Making the filepath persistent across screens
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
    set(handles.edit2,'string',filepath);
    
    %Opening the file
    openfile_editmodel(handles);
elseif(isempty(file_map(curr_fname)) == 1);
    %Resetting screen
    reset_edit(handles);
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
global curr_fname;
global curr_pname;
global file_map;

current_panel = change_panel(current_panel,'uipanel1',handles);

if(isempty(file_map(curr_fname)) == 0);
    %Making the filepath persistent across screens
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
    set(handles.edit3,'string',filepath);
    
    %Opening the file
    openfile_viewodes(handles);
elseif(isempty(file_map(curr_fname)) == 1);
    %Resetting screen
    reset_viewodes(handles);
end 

%Reset Edit Models screen
function reset_edit(handles)

 set(handles.edit2,'string','');
 set(handles.edit1,'string','','enable','off');

%Reset View ODEs screen
function reset_viewodes(handles)
 set(handles.edit3,'string','');
 set(handles.edit4,'string','','enable','off');
 set(handles.edit5,'string','','enable','off');
 set(handles.popupmenu1,'value',1);
 set(handles.popupmenu1,'String','Process List');

%Reset Simulation screen
function reset_simulate(handles)

 set(handles.edit6,'string','');
 set(handles.edit7,'string','','enable','off');
 set(handles.popupmenu2,'value',1);
 set(handles.popupmenu2,'String','Process List');
 set(handles.edit8,'string','0');
 set(handles.edit9,'string','1');
 set(handles.popupmenu3,'Value',1);
 
 reset_file_selection();
 
 % Reset file selection 
 function reset_file_selection()
 global file_map;
 global curr_pname;
 global curr_fname;
 global process_map;
 
 empty = '';
 file_map(curr_pname) = empty;
 file_map(curr_fname) = empty;
 process_map(curr_fname) = 1;
 
 %Reset Comparing screen
function reset_compare(handles)

 set(handles.edit10,'string','');
 set(handles.edit11,'string','','enable','off');
 set(handles.popupmenu4,'Value',1);
 set(handles.popupmenu4,'String','Process List');
 set(handles.edit12,'string','0');
 set(handles.edit13,'string','1');
 set(handles.popupmenu5,'Value',1);
 
 reset_file_selection();
 
 %Clear Comparing screen
 function clear_compare(handles)

 set(handles.edit10,'string','');
 set(handles.edit11,'string','','enable','off');
 set(handles.popupmenu4,'Value',1);
 set(handles.popupmenu4,'String','Process List');
 set(handles.edit12,'string','0');
 set(handles.edit13,'string','1');
 set(handles.popupmenu5,'Value',1);
 
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
global curr_fname;
global file_map;
current_panel = change_panel(current_panel,'uipanel4',handles);

update_processes(handles);

if(isempty(file_map(curr_fname)) == 0);
    %Making the filepath persistent across screens
    set(handles.edit10,'string',file_map(curr_fname));
    
    %Opening the file
    openfile_compare(handles);
elseif(isempty(file_map(curr_fname)) == 1);
    %Resetting screen
    reset_compare(handles);
end 

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
global curr_fname;
global curr_pname;
global file_map;
current_panel = change_panel(current_panel,'uipanel2',handles);

if(isempty(file_map(curr_fname)) == 0);
    %Making the filepath persistent across screens
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
    set(handles.edit6,'string',filepath);
    
    %Opening the file
    openfile_simulate(handles);
elseif(isempty(file_map(curr_fname)) == 1);
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
global curr_fname;
global curr_pname; global file_map;
[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

if(~isequal(Ifname,0));
    
    %Setting global variables
    file_map(curr_fname) = Ifname;
    file_map(curr_pname) = Ipname;
    
    openfile_editmodel(handles);
    
end

%Function to open file in the Edit Model screen
function openfile_editmodel(handles)
    global curr_pname; global file_map;
    global curr_fname;
    
    %Create the file path and populate the text field
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
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
   
   set(handles.text2,'string','Status: File saved.');
   set(handles.text2,'Position',[2.2 0.5 17.333 1.083]);
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

%Confirm user wants to close the file
 file_path = get(handles.edit2,'String'); 
 
if (~isempty(file_path))
choice = questdlg('Are you sure you want to close the file?', ...
	'Close Button Confirmation', ...
	'Yes','Cancel','Cancel');
% Handle response
    if(isequal(choice,'Yes'));
        set(handles.edit1,'String',''); 
        set(handles.edit1,'Enable','off'); 
        set(handles.edit2,'String',''); 
        set(handles.text2,'string','Status: Ready');
        set(handles.text2,'Position',[0.833 0.5 17.333 1.083]);
          
        reset_file_selection();
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
global curr_fname;
global curr_pname; global file_map;
[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

%Ensuring a file was selected
if(~isequal(Ifname,0));
    
    %Setting global variables
    file_map(curr_fname) = Ifname;
    file_map(curr_pname) = Ipname;
    
    %Open file
    openfile_viewodes(handles);
    
end

%Open file in View ODEs screen
function openfile_viewodes(handles)
    global curr_pname; global file_map;
    global curr_fname;
    global definitions;
    global process_map;
    
    %Creating the file path string
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
    set(handles.edit3,'string',filepath);
    
    %Reading the file
    definitions = fileread(strcat(file_map(curr_pname), '/', file_map(curr_fname)));
    set(handles.edit4,'string',definitions, 'enable','inactive');
     
    %Populating the process list dialog box
    [process_name_options, ~, ~, ...
    ~] = retrieve_process_definitions(definitions);
    set(handles.popupmenu1,'String',process_name_options);
    
    %Recalling selection of process list dialog box
    set(handles.popupmenu1,'value',process_map(curr_fname));

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_fname;
global file_map;

if(isempty(file_map(curr_fname)) == 0);
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
global curr_fname;
global process_map;

process_map(curr_fname)=get(handles.popupmenu1,'value');

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
global curr_fname;
global definitions;
global file_map;

if(isempty(file_map(curr_fname)) == 0);
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
global curr_fname;
global process_map;

process_map(curr_fname)=get(handles.popupmenu2,'value');

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
global curr_fname;
global file_map;

%Simulating the process after getting the selected parameters
if(isempty(file_map(curr_fname)) == 0);
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

    %Solve CPi ODEs and display numerical solutions in a table.
    [t, Y] = solve_cpi_odes_gui(odes, ode_num, initial_concentrations, end_time_db, ...
    solver_name(selection2,:), legend_strings, 1);

    pause(0.1);

    if (isempty(t));
        return;
    end
        
    % simulate the solution set for the specified time period
    % and display a graph of it
    create_process_simulation(t, Y, start_time_db, file_map(curr_fname), ...
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
global curr_fname;
global curr_pname; 
global file_map;

[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

%Ensuring a file was selected
if(~isequal(Ifname,0));
    
    %Setting global variables
    file_map(curr_fname) = Ifname;
    file_map(curr_pname) = Ipname;
    
    %Open file
    openfile_simulate(handles);
    
end

%Open file in the Simulate screen
function openfile_simulate(handles)
    global curr_pname; 
    global curr_fname; 
    global definitions;
    global file_map;
    global process_map;
    
    %Creating the file path string
    filepath = fullfile(file_map(curr_pname), file_map(curr_fname));
    set(handles.edit6,'string',filepath);
    
    %Reading the file
    definitions = fileread(strcat(file_map(curr_pname), '/', file_map(curr_fname)));
    set(handles.edit7,'string',definitions, 'enable','inactive');
     
    %Populating the process list dialog box
    [process_name_options, ~, ~, ...
    ~] = retrieve_process_definitions(definitions);
    set(handles.popupmenu2,'String',process_name_options);
    
    %Recalling selection of process list dialog box
    set(handles.popupmenu2,'value',process_map(curr_fname));
    
%Open file in the Compare screen
function openfile_compare(handles)
    global curr_pname; 
    global curr_fname;
    global definitions;
    global file_map;
    global process_map;
    
    %Creating the file path string
    set(handles.edit10,'string',file_map(curr_fname));
    
    %Reading the file
    definitions = fileread(strcat(file_map(curr_pname), '/', file_map(curr_fname)));
    set(handles.edit11,'string',definitions, 'enable','inactive');
     
    %Populating the process list dialog box
    [process_name_options, ~, ~, ...
    ~] = retrieve_process_definitions(definitions);
    set(handles.popupmenu4,'String',process_name_options);
    
    %Recalling selection of process list dialog box
    set(handles.popupmenu4,'value',process_map(curr_fname));

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_fname;
global file_map;
if(isempty(file_map(curr_fname)) == 0);
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


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Are you sure you want to reset this process'' settings?', ...
	'Close Button Confirmation', ...
	'Yes','Cancel','Cancel');
% Handle response
if(isequal(choice,'Yes'));      
    reset_simulate(handles)  
end





function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global curr_fname;
global process_map;

process_map(curr_fname)=get(handles.popupmenu4,'value');

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global process_map;
global file_map;


% Setting Status string
set(handles.text16,'string','Status: Creating comparison...');
set(handles.text16,'Position',[2.2 0.5 25 1.083]);

pause(0.1);

compare_cpi_processes_gui(handles, process_map, file_map);

% Resetting Status string
set(handles.text16,'string','Status: Ready');
set(handles.text16,'Position',[2.333 0.5 17.333 1.083]);

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles);

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_fname;
global curr_pname; 
global file_map;

[Ifname, Ipname] = uigetfile({'*.cpi', 'CPi Models (*.cpi)'}, 'Select a .cpi file');

%Ensuring a file was selected
if(~isequal(Ifname,0));
    
    %Setting global variables
    file_map(curr_fname) = Ifname;
    file_map(curr_pname) = Ipname;
    
    %Open file
    openfile_compare(handles);
    
end

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_fname;
global file_map;
if(isempty(file_map(curr_fname)) == 0);
    %Open file again
    openfile_compare(handles);
end


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Are you sure you want to reset the settings?', ...
	'Close Button Confirmation', ...
	'Yes','Cancel','Cancel');
% Handle response
if(isequal(choice,'Yes'));      
    reset_compare(handles)  
end

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
update_processes(handles);

function update_processes(handles)
selection=get(handles.popupmenu6,'value');
name=get(handles.popupmenu6,'string');

% Get the currently selected object
curr_selection = get(handles.uibuttongroup4,'selectedobject');
curr_selection_tag = get(curr_selection, 'Tag');

% Updates the number of radio buttons displayed when selecting a new
% number of processes 

if(name{selection,:} == '2');
    
    set(handles.radiobutton3, 'Visible', 'Off');
    set(handles.radiobutton4, 'Visible', 'Off');
    
    if(curr_selection == handles.radiobutton3 || curr_selection == handles.radiobutton4);
        set(handles.uibuttongroup4,'selectedobject',handles.radiobutton1);
    end 
    
elseif(name{selection,:} == '3');  
        
    set(handles.radiobutton3, 'Visible', 'On');
    set(handles.radiobutton4, 'Visible', 'Off');
    
    if(curr_selection == handles.radiobutton4);
        set(handles.uibuttongroup4,'selectedobject',handles.radiobutton1);
    end 
    
elseif(name{selection,:} == '4');  
        
    set(handles.radiobutton3, 'Visible', 'On');
    set(handles.radiobutton4, 'Visible', 'On');
    
end 

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uibuttongroup4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Preselecting radiobutton 1 the first time it's created.


% --- Executes during object creation, after setting all properties.
function radiobutton4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
global curr_fname;
global curr_pname;
global file_map;

curr_fname = 'fname1';
curr_pname = 'pname1';

clear_compare(handles);

if(isempty(file_map(curr_fname)) == 0);
    openfile_compare(handles);
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
global curr_fname;
global curr_pname;
global file_map;

curr_fname = 'fname2';
curr_pname = 'pname2';

clear_compare(handles);

if(isempty(file_map(curr_fname)) == 0);
    openfile_compare(handles);
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
global curr_fname;
global curr_pname;
global file_map;

curr_fname = 'fname3';
curr_pname = 'pname3';

clear_compare(handles);

if(isempty(file_map(curr_fname)) == 0);
    openfile_compare(handles);
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
global curr_fname;
global curr_pname;
global file_map;

curr_fname = 'fname4';
curr_pname = 'pname4';

clear_compare(handles);

if(isempty(file_map(curr_fname)) == 0);
    openfile_compare(handles);
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
