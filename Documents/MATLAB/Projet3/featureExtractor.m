function [ featureVector ] = featureExtractor( Boundary, stats, Image,L )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    imageF = Image;
    imageGray = rgb2gray(imageF);
    
    %%
    %%%%%%% Asymetry features %%%%%%%
   
    % Ratio convex hull area / total area
    featureVector(1) = stats.ConvexArea/stats.Area;
    
    % Circularity Index
    featureVector(2) = 4*pi*stats.Area/(stats.Perimeter)^2;
    
    %%
    %%%%%%% Border features %%%%%%%
    featureVector(3) = stats.Eccentricity;
    featureVector(4) = stats.Perimeter/stats.Area;
    
    
    
    %%
    %%%%%%% Color features %%%%%%%
    % TODO: Percentage of each instead
    redstats = regionprops(L,imageF(:,:,1),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    greenstats = regionprops(L,imageF(:,:,2),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    bluestats = regionprops(L,imageF(:,:,3),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    graystats = regionprops(L,imageGray(:,:),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');

    %% RGB and gray analysis
    % Levels of each color
    featureVector(5) = redstats.MeanIntensity;
    featureVector(6) = greenstats.MeanIntensity;
    featureVector(7) = bluestats.MeanIntensity;
    featureVector(8) = graystats.MeanIntensity;
    
    % Distances between weighted centroids
    redCentroid = (redstats.WeightedCentroid);
    greenCentroid = (greenstats.WeightedCentroid);
    blueCentroid = (bluestats.WeightedCentroid);
    
    side1 = sqrt( ( redCentroid(1)-greenCentroid(1) )^2 + ( redCentroid(2)-greenCentroid(2) )^2 );
    side2 = sqrt( ( redCentroid(1)-blueCentroid(1) )^2 + ( redCentroid(2)-blueCentroid(2) )^2 );
    side3 = sqrt( ( blueCentroid(1)-greenCentroid(1) )^2 + ( blueCentroid(2)-greenCentroid(2) )^2 );
    
    featureVector(9) = (side1 + side2 + side3 )/stats.Area;
    featureVector(10) = side1/stats.Area;
    featureVector(11) = side2/stats.Area;
    featureVector(12) = side3/stats.Area;

    % Maximum and minimum intensities
    featureVector(13) = redstats.MaxIntensity;
    featureVector(14) = greenstats.MaxIntensity;
    featureVector(15) = bluestats.MaxIntensity;
    featureVector(16) = graystats.MaxIntensity;

    % Standard deviation 
    featureVector(17) = std(redstats.PixelValues);
    featureVector(18) = std(greenstats.PixelValues);
    featureVector(19) = std(bluestats.PixelValues);
    featureVector(20) = std(graystats.PixelValues);

    % Skewness
    featureVector(17) = Skewness(redstats.PixelValues);
    featureVector(18) = Skewness(greenstats.PixelValues);
    featureVector(19) = Skewness(bluestats.PixelValues);
    featureVector(20) = Skewness(graystats.PixelValues);


    
    %%
    %%%%%%% Textures features %%%%%%%
    
    
    
    

end

