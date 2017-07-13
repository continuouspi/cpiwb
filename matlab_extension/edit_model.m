function varargout = edit_model(varargin)
% EDIT_MODEL MATLAB code for edit_model.fig
%      EDIT_MODEL, by itself, creates a new EDIT_MODEL or raises the existing
%      singleton*.
%
%      H = EDIT_MODEL returns the handle to a new EDIT_MODEL or the handle to
%      the existing singleton*.
%
%      EDIT_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDIT_MODEL.M with the given input arguments.
%
%      EDIT_MODEL('Property','Value',...) creates a new EDIT_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edit_model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edit_model

% Last Modified by GUIDE v2.5 12-Jul-2017 22:18:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edit_model_OpeningFcn, ...
                   'gui_OutputFcn',  @edit_model_OutputFcn, ...
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


% --- Executes just before edit_model is made visible.
function edit_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edit_model (see VARARGIN)

% Choose default command line output for edit_model
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Show Edit Models Panel when opening application
global current_panel;
current_panel = change_panel('~','uipanel2',handles);

% UIWAIT makes edit_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = edit_model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in editmodelButton.
function editmodelButton_Callback(hObject, eventdata, handles)
% hObject    handle to editmodelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel2',handles);
%file = fullfile('icons','pencil-64.gif');
%[x,map]=imread(file);

%I2=imresize(x,[42 113]);

%f = figure;
%imagesc(x);


% --- Executes on button press in viewodesButton.
function viewodesButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewodesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel3',handles);

% --- Executes on button press in pushbutton4.
function simulateprocessButton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel4',handles);

% --- Executes on button press in compareprocesses.
function compareprocesses_Callback(hObject, eventdata, handles)
% hObject    handle to compareprocesses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel6',handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel5',handles);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_panel;
current_panel = change_panel(current_panel,'uipanel7',handles);

function current_panel = change_panel(old_panel, new_panel, handles)

if old_panel ~= '~'
    set(handles.(old_panel),'visible','off');
end 

set(handles.(new_panel),'visible','on'); 

current_panel = new_panel;


% --- Executes on key press with focus on editmodelButton and none of its controls.
function editmodelButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editmodelButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
