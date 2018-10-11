clc
clear all

path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';
im = fetchData(path, 'sm014.jpg');
%figure, imshow(im);

imLab = rgb2lab(im);
figure, imshow(imLab(:,:,1),[0 100]);

imGray = rgb2gray(im);
figure, imshow(imGray);

[J,T]=histeq(imGray);
imshow(J)

Jpr = adapthisteq(imGray);
figure,imshow(Jpr);
