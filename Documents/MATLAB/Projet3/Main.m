clc
clear all

path = 'data/training'

imageIn = imread('ms03.jpg');
AdtyreaTot = length(imageIn(:,1,1))*length(imageIn(1,:,1)); 
imageCropped = cropper(imageIn);
%imageRetour = CircleSegmentation1(imageCropped);
imageRetour = CircleSegmentation1(imageIn);