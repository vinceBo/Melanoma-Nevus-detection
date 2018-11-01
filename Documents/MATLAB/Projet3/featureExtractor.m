function [ featureVector ] = featureExtractor( Boundary, stats, Image,L, indexOfRegion )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    imageF = Image;
    imageGray = rgb2gray(imageF);
    imageHsv = rgb2hsv(imageF);
    
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Color features %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % TODO: Percentage of each instead
    redstats = regionprops(L,imageF(:,:,1),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    greenstats = regionprops(L,imageF(:,:,2),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    bluestats = regionprops(L,imageF(:,:,3),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    graystats = regionprops(L,imageGray(:,:),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    hstats = regionprops(L,imageHsv(:,:,1),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    vstats = regionprops(L,imageHsv(:,:,3),'MeanIntensity','WeightedCentroid','MaxIntensity','PixelValues');
    
    %% RGB and gray analysis hsv
    % Levels of each color
    featureVector(5) = redstats.MeanIntensity;
    featureVector(6) = greenstats.MeanIntensity;
    featureVector(7) = bluestats.MeanIntensity;
    featureVector(8) = graystats.MeanIntensity;
    featureVector(8) = hstats.MeanIntensity;
    featureVector(8) = vstats.MeanIntensity;
    
    % Distances between weighted centroids
    redCentroid = (redstats(indexOfRegion).WeightedCentroid);
    greenCentroid = (greenstats(indexOfRegion).WeightedCentroid);
    blueCentroid = (bluestats(indexOfRegion).WeightedCentroid);
    
    side1 = sqrt( ( redCentroid(1)-greenCentroid(1) )^2 + ( redCentroid(2)-greenCentroid(2) )^2 );
    side2 = sqrt( ( redCentroid(1)-blueCentroid(1) )^2 + ( redCentroid(2)-blueCentroid(2) )^2 );
    side3 = sqrt( ( blueCentroid(1)-greenCentroid(1) )^2 + ( blueCentroid(2)-greenCentroid(2) )^2 );
    
    featureVector(9) = (side1 + side2 + side3 )/stats.Area;
    featureVector(10) = side1/stats.Area;
    featureVector(11) = side2/stats.Area;
    featureVector(12) = side3/stats.Area;

    % Maximum and minimum intensities
    featureVector(13) = redstats(indexOfRegion).MaxIntensity;
    featureVector(14) = greenstats(indexOfRegion).MaxIntensity;
    featureVector(15) = bluestats(indexOfRegion).MaxIntensity;
    featureVector(16) = graystats(indexOfRegion).MaxIntensity;
    featureVector(16) = hstats(indexOfRegion).MaxIntensity;
    featureVector(16) = vstats(indexOfRegion).MaxIntensity;

    % Standard deviation 
   
    featureVector(17) = std(double(redstats(indexOfRegion).PixelValues));
    featureVector(18) = std(double(greenstats(indexOfRegion).PixelValues));
    featureVector(19) = std(double(bluestats(indexOfRegion).PixelValues));
    featureVector(20) = std(double(graystats(indexOfRegion).PixelValues));
    featureVector(20) = std(double(hstats(indexOfRegion).PixelValues));
    featureVector(20) = std(double(vstats(indexOfRegion).PixelValues));
    
    % Skewness
    
    featureVector(17) = skewness(double(redstats(indexOfRegion).PixelValues));
    featureVector(18) = skewness(double(greenstats(indexOfRegion).PixelValues));
    featureVector(19) = skewness(double(bluestats(indexOfRegion).PixelValues));
    featureVector(20) = skewness(double(graystats(indexOfRegion).PixelValues));
    featureVector(20) = skewness(double(hstats(indexOfRegion).PixelValues));
    featureVector(20) = skewness(double(vstats(indexOfRegion).PixelValues));
    
    % number of non-zero histogram bins (out of 25)
    figure,
    hr = histogram(double(redstats(2).PixelValues),25);
    featureVector(17) = sum(hr.BinCounts > max(hr.BinCounts)/100);
    hg = histogram(double(greenstats(indexOfRegion).PixelValues),25);
    featureVector(18) = sum(hg.BinCounts > max(hg.BinCounts)/100);
    hb = histogram(double(bluestats(indexOfRegion).PixelValues),25);
    featureVector(19) = sum(hb.BinCounts > max(hb.BinCounts)/100);
    hgr = histogram(double(graystats(indexOfRegion).PixelValues),25);
    featureVector(20) = sum(hgr.BinCounts > max(hgr.BinCounts)/100);
    hh = histogram(double(hstats(indexOfRegion).PixelValues),25);
    featureVector(21) = sum(hh.BinCounts > max(hh.BinCounts)/100);
    hv = histogram(double(vstats(indexOfRegion).PixelValues),25);
    featureVector(17) = sum(hv.BinCounts > max(hv.BinCounts)/100);


    


    
    %%
    %%%%%%% Textures features %%%%%%%
    
    
    
    

end

