clc
clear all

path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';
I1 = fetchData(path,'sm007.jpg');
I = imresize(I1,[538 720], 'bilinear');

iGray = rgb2gray(I1);
gilettedI = Gillette(iGray);
homoFiltered = preprocessing(I1);

imshowpair(iGray,im2uint8(homoFiltered),'montage');

%%
%Ishaved = rasoir(I);
%figure,imshow(Ishaved);

AdtyreaTot = length(I1(:,1,1))*length(I1(1,:,1)); 
%imageCropped = cropper(I1);
%imageRetour = CircleSegmentation1(imageCropped);

[imageRetour,boundary,stats,boundMatrix] = CircleSegmentation1(I1);

features = featureExtractor(boundary,stats,I1,boundMatrix);

