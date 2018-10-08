clc, clear all
Im = imread('U1.jpg');
ImGray = rgb2gray(Im);
[lenX,lenY] = size(ImGray);
maskSize = floor(5*sqrt((lenX/768)*(lenY/512)));
filteredIm = medfilt2(ImGray,[3 3]);

figure, imshow(ImGray);
figure, imshow(filteredIm);