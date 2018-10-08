
clc
clear all
img2 = imread('nevus01.jpg');
img = cropper(img2);
   
    %figure;
    imshow(img);
    w=waitforbuttonpress;
    
    %conversion to grayscale images
    img_g = rgb2gray(img);
    
    dilation_strength = 10;
     R = imclose(img(:,:,1),strel('disk',dilation_strength));
     G = imclose(img(:,:,2),strel('disk',dilation_strength));
     B = imclose(img(:,:,3),strel('disk',dilation_strength));
     dilated_image(:,:,1) = R;
     dilated_image(:,:,2) = G;
     dilated_image(:,:,3) = B;
   
    
    %bot hat operation to obtain hairs%
    se = strel('disk',4);
    img_g = imadjust(img_g);
    img_g = imsharpen(img_g);
    img_c = imbothat(img_g,se);
  
    
    %invert the image to highlight hairs with a darker background%
    inverted_img_c = 255 - img_c;
    
    %fill unnecssary holes%
     inverted_img_c= imfill(inverted_img_c); 
   %  figure;
     figure,imshow(inverted_img_c);
    
    %convert to binary image%
    image_bw = imbinarize(inverted_img_c,0.97);
    image_bw = imerode(image_bw,strel('disk',2));
    %figure;
    figure,imshow(image_bw);
    
   %use large median filter for pixels with darker background on the original image%
    [Row,Column] = size(image_bw);
    new_image = img;
    for R = 1:Row
        for C = 1: Column
            pixel = image_bw(R,C);
            if pixel == 0
                for RGB = 1:3
                    new_image(R,C,RGB) = dilated_image(R,C,RGB);
                end
            end    
        end
    end
    %figure;
    new_image=imsharpen(new_image);
    figure,imshow(new_image)
    