function varargout = burunchina_gui(varargin)
% BURUNCHINA_GUI MATLAB code for burunchina_gui.fig
%      BURUNCHINA_GUI, by itself, creates a new BURUNCHINA_GUI or raises the existing
%      singleton*.
%
%      H = BURUNCHINA_GUI returns the handle to a new BURUNCHINA_GUI or the handle to
%      the existing singleton*.
%
%      BURUNCHINA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BURUNCHINA_GUI.M with the given input arguments.
%
%      BURUNCHINA_GUI('Property','Value',...) creates a new BURUNCHINA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before burunchina_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to burunchina_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help burunchina_gui

% Last Modified by GUIDE v2.5 20-Mar-2021 06:05:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @burunchina_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @burunchina_gui_OutputFcn, ...
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


% --- Executes just before burunchina_gui is made visible.
function burunchina_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to burunchina_gui (see VARARGIN)

% Choose default command line output for burunchina_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes burunchina_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = burunchina_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectImage.
function SelectImage_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Pick an image file'); %browse image
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel') %in case user will not choose any image
    else
       file = strcat(pathname, filename);
       global img; %declare global img variable to use in Radius_Callback function
       img = imread (file);
       axes(handles.axes1); %assign to axes1 from gui
       imshow(img);
    end

% --- Executes on button press in Pixel.
function Pixel_Callback(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ind1; %declare global variable to use them in Radius_Callback function
global ind2;
[ind1, ind2] = ginput(1); %Take input pixel from user
handles.X = ind1 ; 
handles.Y =  ind2 ;
guidata(handles.Pixel,handles) %reference to the pushbutton


% --- Executes on slider movement.
function Radius_Callback(hObject, eventdata, handles)
% hObject    handle to Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global ind1; global ind2;
[R C Ch] = size(img); %get number of columns and rows
Pixel = impixel(img, ind1, ind2); %get chosen Pixel rgb triplet
radius = get(hObject, 'Value'); %get radius from slidebar
img_doub = double(img); %image to double

%Sphere color-slicing transformation
for Row = 1:R %iterating through each row
    for Col = 1:C %interating through each column
        if sqrt(sum( (squeeze( img_doub(Row, Col, :))' - Pixel).^2 ) ) > radius 
            img_doub(Row,Col,:) = 0.2989*img_doub(Row,Col,1) + 0.5870*img_doub(Row,Col,2) + 0.1140*img_doub(Row,Col,3);
            %If the value is not in the range of chosen color -> convert to
            %grayscale using standard formula
        end
    end
end
set(handles.Radius_Text, 'String', num2str(radius));
axes(handles.axes2)
imshow(uint8(img_doub));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function Radius_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Radius_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Radius_Text as text
%        str2double(get(hObject,'String')) returns contents of Radius_Text as a double


% --- Executes during object creation, after setting all properties.
function Radius_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radius_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Surprise.
function Surprise_Callback(hObject, eventdata, handles)
% hObject    handle to Surprise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Surprise
Tog_value = get(hObject, 'Value');
if Tog_value == 1 %if pressed once/3/5 times and so on
    Tog_value = imread('Find_spot.jpg'); 
else %if pressed twice/4/6 times and so on
    Tog_value = imread('Find_spot2.jpg');
end
axes(handles.axes3);
imshow(imcomplement(Tog_value)); %show compliment of images 


% --- Executes on button press in Camera.
function Camera_Callback(hObject, eventdata, handles)
% hObject    handle to Camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axis1);
%{
global img
DeviceName = '';
DeviceID = ;
video = videoinput(DeviceName, DeviceID);
img = image(zeros(resolution, 3), 'parent', handles.axes1)
img = preview(vid, img);
%}
