clc
clear all

path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';
im = fetchData(path, 'sm014.jpg');
figure, imshow(im);

imLab = rgb2lab(im);
figure, imshow(imLab(:,:,1),[0 100]);

imGray = rgb2gray(im);
figure, imshow(imGray);

[J,T]=histeq(imGray);
imshow(J)

Jpr = adapthisteq(imGray);
figure,imshow(Jpr);

sharp = imsharpen(im);
figure,imshow(sharp);

%%
I = imGray;
se = strel('disk',3);
hairs = imbothat(I,se);
BW = hairs > 15;
BW2 = imdilate(BW,strel('disk',1));

figure(1)
subplot(1,2,1)
imshow(BW)
subplot(1,2,2)
imshow(BW2)

replacedImage = roifill(I,BW2);
figure(2)
subplot(1,2,1)
imshow(I)
subplot(1,2,2)

imshow(replacedImage)
ll = edge (replacedImage,'canny');
figure(3)
imshow(ll)