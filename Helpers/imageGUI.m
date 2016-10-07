function varargout = imageGUI(varargin)
% IMAGEGUI MATLAB code for imageGUI.fig
%      IMAGEGUI, by itself, creates a new IMAGEGUI or raises the existing
%      singleton*.
%
%      H = IMAGEGUI returns the handle to a new IMAGEGUI or the handle to
%      the existing singleton*.
%
%      IMAGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEGUI.M with the given input arguments.
%
%      IMAGEGUI('Property','Value',...) creates a new IMAGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageGUI

% Last Modified by GUIDE v2.5 13-Jan-2016 17:51:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @imageGUI_OutputFcn, ...
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


% --- Executes just before imageGUI is made visible.
function imageGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageGUI (see VARARGIN)

% Choose default command line output for imageGUI
handles.output = hObject;

% Update handles structure

handles.S = varargin{1};%evalin('base','S');%
handles.MergeBuff = handles.S.MergeBuff;
handles.sz = size(handles.MergeBuff{1});
handles.image = reshape([handles.MergeBuff{:}], handles.sz(1), handles.sz(2), length(handles.MergeBuff));
handles.numImages = length(handles.MergeBuff);
updateSlider(handles);
guidata(hObject, handles);
handles.S.plot_segmentations(1, { 'MIDPOINT', 'IMAGE', 'CORR'});
% UIWAIT makes imageGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function numImages_Callback(hObject, eventdata, handles)
% hObject    handle to numImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numImages as text
%        str2double(get(hObject,'String')) returns contents of numImages as a double

updateSlider(handles);

function updateSlider(handles)
% This function updates the slider to have the correct min, max, value, and
%   step size

%get the current slice number which were stored in the figure axes
sliceNum = getappdata(handles.imageAxes,'sliceNum');
if isempty(sliceNum) %may be empty if the figure has not been initialized
    sliceNum = 1;    %set it to a default
end

%get the number written in the text box which is the maximum number of
%images to be viewed
NumImageslice = handles.numImages;
%there are only NumImageslice - 1 images total, because we start at 1
step = 1/(NumImageslice - 1);
if step == Inf; step = 1; end
%set values for the slider bar
set(handles.imageSlider, 'Max',        NumImageslice);
set(handles.imageSlider, 'Min',        1);
set(handles.imageSlider, 'SliderStep', [step step]);

%set current value to the slice we are viewing
set(handles.imageSlider, 'Value', sliceNum);

% --- Executes during object creation, after setting all properties.
function numImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function imageSlider_Callback(hObject, eventdata, handles)
% hObject    handle to imageSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the current value on the slider
imageSlider_value = get(hObject,'Value');

%get the current max value from the slider
numImages = get(handles.imageSlider, 'Max');

%calculate the image number to display
imageNum = floor(imageSlider_value);
handles.imNumDisp.String = num2str(imageNum);
%read in image data
image = handles.image(:, :, imageNum);

%bring current axes in focus and show image
axes(handles.imageAxes);
% handles.S.plot_segmentations(imageNum, { 'MIDPOINT', 'IMAGE', 'DIFF', 'DIFFC', 'FINAL'});
handles.S.plot_segmentations(imageNum, { 'MIDPOINT', 'IMAGE', 'CORR'});

%store image data and slice number in axes
setappdata(handles.imageAxes, 'image',     image);
setappdata(handles.imageAxes, 'sliceNum',  imageSlider_value);

% --- Executes during object creation, after setting all properties.
function imageSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in correctSegmentation.
function correctSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to correctSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliceNum = getappdata(handles.imageAxes, 'sliceNum');
handles.S.correct_segmentation(sliceNum, 0);
guidata(hObject, handles)


% --- Executes on button press in correctPropagate.
function correctPropagate_Callback(hObject, eventdata, handles)
% hObject    handle to correctPropagate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliceNum = getappdata(handles.imageAxes, 'sliceNum');
handles.S.correct_segmentation(sliceNum, 1);
guidata(hObject, handles)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sliceNum = getappdata(handles.imageAxes, 'sliceNum');
handles.S.correct_segmentation(sliceNum, 2);
guidata(hObject, handles)
