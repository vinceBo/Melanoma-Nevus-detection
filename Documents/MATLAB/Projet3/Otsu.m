I = imread('nevusVincent01.jpg');
I_gray = rgb2gray(I);
%figure,imshow(I);
figure,imhist(I_gray);
T=160;
It=im2bw(I,T/255);
%figure,imshow(It);

Ic = histeq(I_gray);
%figure,imshow(Ic);

Ig = rgb2gray(I);
figure,imshow(Ig);

figure,imhist(Ic);

se = strel('disk',100);
background = imopen(It,se);
figure,imshow(background);

