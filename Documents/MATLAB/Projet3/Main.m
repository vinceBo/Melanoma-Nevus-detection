clc
clear all

path = '/Users/vincentbonnardeaux/Documents/MATLAB/Projet3/Database/';

for i=32:32
    imName = 'sm';
    if i<10
        imName = strcat(imName,'00',int2str(i),'.jpg');
    elseif i>=10 && i<100
        imName = strcat(imName,'0',int2str(i),'.jpg');
    else
        imName = strcat(imName,int2str(i),'.jpg');
    end

    I1 = fetchData(path,imName);
    figure,imshow(I1);
    I = imresize(I1,[538 720], 'bilinear');

    iGray = rgb2gray(I1);
    gilettedI = Gillette(iGray);
    homoFiltered = preprocessing(I1);

    %imshowpair(iGray,im2uint8(homoFiltered),'montage');

    %Ishaved = rasoir(I);
    %figure,imshow(Ishaved);

    AdtyreaTot = length(I1(:,1,1))*length(I1(1,:,1)); 
    %imageCropped = cropper(I1);
    %imageRetour = CircleSegmentation1(imageCropped);

    [imageRetour,boundary,stats,boundMatrix] = CircleSegmentation1(I1);

    features = featureExtractor(boundary,stats,I1,boundMatrix);
end

