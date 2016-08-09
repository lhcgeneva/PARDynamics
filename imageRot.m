function varargout = imageRot(varargin)
% IMAGEROT MATLAB code for imageRot.fig
%      IMAGEROT, by itself, creates a new IMAGEROT or raises the existing
%      singleton*.
%
%      H = IMAGEROT returns the handle to a new IMAGEROT or the handle to
%      the existing singleton*.
%
%      IMAGEROT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEROT.M with the given input arguments.
%
%      IMAGEROT('Property','Value',...) creates a new IMAGEROT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageRot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageRot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageRot

% Last Modified by GUIDE v2.5 31-Jul-2015 14:08:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageRot_OpeningFcn, ...
                   'gui_OutputFcn',  @imageRot_OutputFcn, ...
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


% --- Executes just before imageRot is made visible.
function imageRot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageRot (see VARARGIN)

% Choose default command line output for imageRot
handles.output = hObject;

% Update handles structure
handles.Im = varargin{1};
handles.MergeBuff = mean(handles.Im(:, :, :),3);
handles.sz = size(handles.Im);
% handles.image = reshape(handles.MergeBuff, handles.sz(1), handles.sz(2), length(handles.MergeBuff));
updateSlider(handles);
guidata(hObject, handles);
% UIWAIT makes imageRot wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageRot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.image_stack;
delete(handles.figure1);

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
if(isempty(sliceNum))%may be empty if the figure has not been initialized
    sliceNum = 1;    %set it to a default
end

%get the number written in the text box which is the maximum number of
%images to be viewed
Angle = 360;
%there are only Angle - 1 images total, because we start at 1
step = 1/(Angle+1);
if step == Inf; step = 1; end
%set values for the slider bar
set(handles.imageSlider, 'Max',        Angle);
set(handles.imageSlider, 'Min',        0);
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
image = handles.MergeBuff;

%bring current axes in focus and show image
axes(handles.imageAxes);
imageRotated = imrotate(image, imageSlider_value);
imshow(imageRotated, []);
handles.ImRot = imageRotated;
%store image data and slice number in axes
handles.FinalRot = imrotate(handles.Im, imageSlider_value);
setappdata(handles.imageAxes, 'image',     image);
setappdata(handles.imageAxes, 'sliceNum',  imageSlider_value);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function imageSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end


% --- Executes on button press in CreateROI.
function CreateROI_Callback(hObject, eventdata, handles)
% hObject    handle to CreateROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.ROI = imrect(gca);
[image, rect] = imcrop(gca);
handles.image_stack = zeros(size(image));
for i = 1:handles.sz(3)
    handles.image_stack(:, :, i) = imcrop(handles.FinalRot(:, :, i), rect);
end
    
guidata(hObject, handles);
