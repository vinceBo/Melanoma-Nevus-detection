function [ imageOut ] = newRazor( imageIn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    dilation_strength = 6;
    R = imclose(imageIn(:,:,1),strel('disk',dilation_strength));
    G = imclose(imageIn(:,:,2),strel('disk',dilation_strength));
    B = imclose(imageIn(:,:,3),strel('disk',dilation_strength));
    dilatedImage(:,:,1) = R;
    dilatedImage(:,:,2) = G;
    dilatedImage(:,:,3) = B;

    imageGray = rgb2gray(imageIn);

    % bottom hat to get hair
    se = strel('disk',1);
    imageGray = imadjust(imageGray);
    imageGray = imsharpen(imageGray);
    imageC = imbothat(imageGray,se);

    % invert image
    inverseImageC = 255 - imageC;
    figure, imshow(imageC);

    % to binary
    image_bw = imbinarize(inverseImageC,0.97);
    image_bw = imerode(image_bw,strel('disk',1));
    figure;
    imshow(image_bw);

    %use large median filter for pixels with darker background on the original image%
    [Row,Column] = size(image_bw);
    new_image = imageIn;
    for R = 1:Row
        for C = 1: Column
            pixel = image_bw(R,C);
            if pixel == 0
                for RGB = 1:3
                    new_image(R,C,RGB) = dilatedImage(R,C,RGB);
                end
            end    
        end
    end
    %figure;
    new_image=imsharpen(new_image);
    imshow(new_image)

    imageOut = new_image;


end

