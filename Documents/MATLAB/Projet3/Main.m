clc
clear all
imageIn = imread('ms03.jpg');
AdtyreaTot = length(imageIn(:,1,1))*length(imageIn(1,:,1)); 
imageCropped = cropper(imageIn);
%imageRetour = CircleSegmentation1(imageCropped);
imageRetour = CircleSegmentation1(imageIn);

U2 = imread('ms02.jpg');

U2Gray = rgb2gray(imageCropped);
U2GrayDouble = im2double(U2Gray);

U4 = imread('U6.jpg');

U4Gray = rgb2gray(U4);

contraste=std(U2GrayDouble);
contrasteMean = mean (contraste);

%figure,imhist(U2Gray);
%title=('U2');
%figure,imhist(U4Gray);
disp('--------------------------------------------');
file = 'U';

%for j=1:6
 %   filename = strcat(file,int2str(j));
  %  filename = strcat(filename,'.jpg');
   % imageRetour = CircleSegmentation1(filename);
%end