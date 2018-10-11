function [ featureVector ] = featureExtractor( Boundary, stats, Image,L )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    imageF = Image;
    
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
    redstats = regionprops(L,imageF(:,:,1),'MeanIntensity','WeightedCentroid');
    greenstats = regionprops(L,imageF(:,:,2),'MeanIntensity','WeightedCentroid');
    bluestats = regionprops(L,imageF(:,:,3),'MeanIntensity','WeightedCentroid');
    
    % Levels of each color
    featureVector(5) = redstats.MeanIntensity;
    featureVector(6) = greenstats.MeanIntensity;
    featureVector(7) = bluestats.MeanIntensity;
    
    % Distances between weighted centroids
    redCentroid = (redstats.WeightedCentroid);
    greenCentroid = (greenstats.WeightedCentroid);
    blueCentroid = (bluestats.WeightedCentroid);
    
    side1 = sqrt( ( redCentroid(1)-greenCentroid(1) )^2 + ( redCentroid(2)-greenCentroid(2) )^2 );
    side2 = sqrt( ( redCentroid(1)-blueCentroid(1) )^2 + ( redCentroid(2)-blueCentroid(2) )^2 );
    side3 = sqrt( ( blueCentroid(1)-greenCentroid(1) )^2 + ( blueCentroid(2)-greenCentroid(2) )^2 );
    
    featureVector(8) = (side1 + side2 + side3 )/stats.Area;
    
    %%
    %%%%%%% Textures features %%%%%%%
    
    
    
    

end

