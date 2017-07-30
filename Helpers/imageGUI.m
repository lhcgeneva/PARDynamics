function varargout = imageGUI(varargin)
% IMAGEGUI MATLAB code for imageGUI.fig
%      IMAGEGUI, by itself, creates a new IMAGEGUI or raises the existing
%      singleton*.
%
%      H = IMAGEGUI returns the handle to a new IMAGEGUI or the handle to
%      the existing singleton*.
%
%      IMAGEGUI('CALLBACK',hObject,~,handles,...) calls the local
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

% Last Modified by GUIDE v2.5 30-Jul-2017 14:20:18

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
function imageGUI_OpeningFcn(hObject, ~, handles, varargin)
% Choose default command line output for imageGUI
handles.output = hObject;
% Update handles structure
handles.S = varargin{1};
handles.MergeBuff = handles.S.MergeBuff;
handles.sz = size(handles.MergeBuff{1});
handles.image = reshape([handles.MergeBuff{:}], handles.sz(1),...
                        handles.sz(2), length(handles.MergeBuff));
handles.numImages = length(handles.MergeBuff);
updateSlider(handles);
guidata(hObject, handles);
handles.S.plot_segmentations(1, { 'MIDPOINT', 'IMAGE', 'CORR'});


% --- Outputs from this function are returned to the command line.
function varargout = imageGUI_OutputFcn(hObject, ~, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


function updateSlider(handles)
% This function updates the slider to have the correct min, max, value, and
% step size
% Get the current slice number which was stored in the figure axes, may be
% empty if the figure has not been initialized, in this case default to 1
if isempty(getappdata(handles.imageAxes, 'sliceNum'))
    setappdata(handles.imageAxes, 'sliceNum', 1);
end
% there are only handles.numImages - 1 images total, because we start at 1
step = 1/(handles.numImages - 1);
if step == Inf; step = 1; end
% set values for the slider bar
set(handles.imageSlider, 'Max', handles.numImages);
set(handles.imageSlider, 'Min', 1);
set(handles.imageSlider, 'SliderStep', [step step]);
% set current value to the slice we are viewing
set(handles.imageSlider, 'Value', getappdata(handles.imageAxes, 'sliceNum'));
handles.imNumDisp.String = [num2str(floor(get(handles.imageSlider, 'Value'))),...
                            '/', num2str(handles.numImages)];


% --- Executes during object creation, after setting all properties.
function numImages_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
                   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function imageSlider_Callback(hObject, ~, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Get current value of the slider
imageNum = floor(get(hObject,'Value'));
handles.imNumDisp.String = [num2str(imageNum),...
                            '/', num2str(handles.numImages)];
% read in image data
image = handles.image(:, :, imageNum);
% bring current axes in focus and show image
axes(handles.imageAxes);
% handles.S.plot_segmentations(imageNum, { 'MIDPOINT', 'IMAGE', 'DIFF', 'DIFFC', 'FINAL'});
handles.S.plot_segmentations(imageNum, { 'MIDPOINT', 'IMAGE', 'CORR'});
%store image data and slice number in axes
setappdata(handles.imageAxes, 'image',     image);
setappdata(handles.imageAxes, 'sliceNum',  imageNum);


% --- Executes during object creation, after setting all properties.
function imageSlider_CreateFcn(hObject, ~, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in freehand_prop.
function freehand_prop_Callback(hObject, ~, handles)
sliceNum = getappdata(handles.imageAxes, 'sliceNum');
handles.S.correct_segmentation(sliceNum, 1);
guidata(hObject, handles)


% --- Executes on button press in freehand.
function freehand_Callback(hObject, ~, handles)
sliceNum = getappdata(handles.imageAxes, 'sliceNum');
handles.S.correct_segmentation(sliceNum, 0);
guidata(hObject, handles)


% --- Executes on button press in Difference.
function Difference_Callback(hObject, ~, handles)
% Hint: get(hObject,'Value') returns toggle state of Difference


% --- Executes on button press in Maximum.
function Maximum_Callback(hObject, ~, handles)
% Hint: get(hObject,'Value') returns toggle state of Maximum


% --- Executes on button press in Corrected.
function Corrected_Callback(hObject, ~, handles)
% Hint: get(hObject,'Value') returns toggle state of Corrected
