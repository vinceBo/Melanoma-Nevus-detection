clc
clear all

path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';
I1 = fetchData(path,'sm025.jpg');

imageIn = imshow(I1);


AdtyreaTot = length(I1(:,1,1))*length(I1(1,:,1)); 
imageCropped = cropper(I1);
%imageRetour = CircleSegmentation1(imageCropped);
imageRetour = CircleSegmentation1(I1);