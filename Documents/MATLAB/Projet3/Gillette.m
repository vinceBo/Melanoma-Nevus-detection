function [ shavedImage ] = Gillette( I )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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
    
    shavedImage = replacedImage;

end

