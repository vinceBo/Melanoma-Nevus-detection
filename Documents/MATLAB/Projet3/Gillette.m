function [ shavedImage ] = Gillette( I )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    se = strel('disk',5);
    hairs = imbothat(I,se);
    BW = hairs > 15;
    BW2 = imdilate(BW,strel('disk',2));

    replacedImage = roifill(I,BW2);
    
    ll = edge (replacedImage,'canny');
    %figure(3)
    %imshow(ll)
    
    [x,y] = size(I);
    n = floor(5*sqrt((x/768)*(y/512)));
    shavedImage = medfilt2(replacedImage,[n n]);
    
    %shavedImage = imgaussfilt(replacedImage,0.3);
    
   

end

