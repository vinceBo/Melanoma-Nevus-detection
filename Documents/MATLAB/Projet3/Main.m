
clc
clear all
%%
path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';
%%
for i=53:53
    imName = 'sm';
    if i<10
        imName = strcat(imName,'00',int2str(i),'.jpg');
    elseif i>=10 && i<100
        imName = strcat(imName,'0',int2str(i),'.jpg');
    else
        imName = strcat(imName,int2str(i),'.jpg');
    end

    I1 = fetchData(path,imName);
    iGray = rgb2gray(I1);
    
    I1 = newRazor(I1);
    %figure, imshow(razoredddd);
    %imshow(I1);
    %%
    figure,imshow(I1);
    I = imresize(I1,[538 720], 'bilinear');

    %iGray = rgb2gray(I1);
   
    homoFiltered = preprocessing(I1);
    gilettedI = Gillette(homoFiltered);

    % Canny edge detection
    ICanny = edge(homoFiltered,'canny');

    %imshowpair(iGray,im2uint8(homoFiltered),'montage');
    
    %%

    %Ishaved = rasoir(I);
    %figure,imshow(Ishaved);

    AdtyreaTot = length(I1(:,1,1))*length(I1(1,:,1)); 
    %imageCropped = cropper(I1);
    %imageRetour = CircleSegmentation1(imageCropped);

    [imageRetour,boundary,stats,boundMatrix,index ] = CircleSegmentation1(I1);
    imshow(boundMatrix)
    %%
    features = featureExtractor(boundary,stats,I1,boundMatrix, index);
end

%% testing SVM
%load fisheriris
%binaryData = grp2idx(species);
%dataInput = binaryData(1:100);
%featureInput = meas(1:100,:);
%accuracy = SVMtrainer(dataInput, featureInput);


%% testing Texture
[glcm2,SI] = graycomatrix(gilettedI,'Offset',[2 0],'Symmetric',true);
figure,
imshow(uint8(10*SI))
figure,
imshow(gilettedI)

stats = GLCM_Features(glcm2);

%% testing razor
%Itest = imread('allo.jpg');
%razoredI = newRazor(Itest);
%imshow(razoredI)