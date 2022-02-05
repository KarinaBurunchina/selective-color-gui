# selective-color-gui
The GUI for selective color effect. To be particular, the user can select any image from his computer, choose any pixel whose color will be dominant, and vary the radius of the enclosing the pixel sphere.

The output picture appears along with the concrete selected radius from the slider. As the bonus feature, I have implemented the toggle bar which has 2 values: 1 and 0. By pushing the toggle button 2 image changes sequentially. The task for users is to find the difference between them. In order to complicate it, I took a compliment of the image, so that the user will not find it on the internet with a solution.

# Implementation

1. In the GUI the axes1 has been designed. It is signed as ‘Input Image’. The push button called ‘Select Image’ has been introduced to execute the following code when the user presses it:

```Matlab
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
```
Here the program asks the user to browse the image. The global variable ‘img’ is introduced to use it also in another function. The selected image is assigned to the axes1 block in GUI.

2. The button to choose pixel from the image was declared:

```Matlab
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
```
The pushbutton asks the user to input the pixel by clicking on the image.

3. The slider is used to input the value for the radius of the sphere which enclothes the colors of interest. I have set the values for the minimum to 10 and the maximum to 240, since at this range the picture varies from the grayscale to the original. In conclusion, I have noticed that the smaller the radius of the sphere, the less is the color range selected. However, the user has to wait a bit for an output image.

```Matlab
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
```
The size of the input image is obtained to clarify the number of rows and columns. Then the RGB triplet of the chosen pixel is defined by impixel() function. The image converted to double in order to easily work with matrixes. Iterating through every pixel, the system decided whether to assign the grayscale value to it by the following formula:

![image](https://user-images.githubusercontent.com/82153653/152657948-327efb1f-2600-4d58-80a4-68b29a5122e5.png)

But instead of 0.5, I converted the pixel, which is not in the range of interest, to its gray-scale value by using the NTSC formula: 0.299 ∙ Red + 0.587 ∙ Green + 0.114 ∙ Blue. The obtained image was assigned to the axes2 block in GUI. The value chosen in the slider is displayed under the output image.

4. The Bonus Feature button is not directly connected to the input image. I used it to entertain the user by ‘Find the Difference’ game. However, the user could find the photo with a solution on the internet. So, I used the complement of the image to overcome this situation. There are 7 differences between the photos. By pushing the toggle button the user can easily switch between the photos. This technique facilitates the searches. Both images are assigned to the axes3.

```Matlab
% --- Executes on button press in Surprise.
function Surprise_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of Surprise
Tog_value = get(hObject, 'Value');
if Tog_value == 1 %if pressed once/3/5 times and so on
    Tog_value = imread('Find_spot.jpg'); 
else %if pressed twice/4/6 times and so on
    Tog_value = imread('Find_spot2.jpg');
end
axes(handles.axes3);
imshow(imcomplement(Tog_value)); %show compliment of images 
```

5. The input camera mode was introduced. However, it is not tested. The reason is the lack of cameras at home. Before moving to this part make sure that the camera is connected to the computer by USB. Typing ‘imaqtool’ the user can find the name and ID of the connected device. And then write it down to the code:

```Matlab
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

```

The GUI applied:

![image](https://user-images.githubusercontent.com/82153653/152658036-44019d31-fe7e-4b73-9d54-1ca3597f2734.png)









