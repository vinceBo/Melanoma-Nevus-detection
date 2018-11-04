function [ featureVector ] = featureExtractor( Image, segmentationInformation )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    numberOfCurvaturePoints = 200;
    imageF = Image;
    imageGray = rgb2gray(imageF);
    imageHsv = rgb2hsv(imageF);
    
    Boundary = segmentationInformation.BoundaryMatrix;
    NumberOfBoundaryPoints = size(Boundary);
    stats = segmentationInformation.Stats;
    L = segmentationInformation.LabelMatrix;
    indexOfRegion = segmentationInformation.Index;
    imageName = segmentationInformation.Name;
    
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
    featureVector(5) = stats.Solidity;
    featureVector(6) = stats.Extent;
    featureVector(7) = stats.Area / ((stats.EquivDiameter)/2)^2; 
    featureVector(8) = stats.MinorAxisLength/stats.MajorAxisLength;
    featureVector(9) = abs(stats.BoundingBox(2) / stats.BoundingBox(3))
    % Distance from centroid
    for i = 1:8
        distanceCentroidToExtrema(i) = norm(stats.Extrema(i) - stats.Centroid);
    end
    sortedDistances = sort(distanceCentroidToExtrema);
    featureVector(8) = std(distanceCentroidToExtrema);
    featureVector(9) = distanceCentroidToExtrema(end) / distanceCentroidToExtrema(end-1);
    
    % Curvature Analysis
    
    inc = floor(NumberOfBoundaryPoints(1) / numberOfCurvaturePoints);
    incrementer = 1;
    for i = 1:inc:NumberOfBoundaryPoints(1)
        matrixForCurvature(incrementer,:) = Boundary(i,:); 
        incrementer = incrementer + 1;
    end
    kurvs=LineCurvature2D(matrixForCurvature);
    
    featureVector(10) = mean(kurvs);
    featureVector(11) = std(kurvs);
    featureVector(12) = max(kurvs);
    featureVector(13) = min(kurvs);
    featureVector(14) = mean(abs(kurvs));
    featureVector(15) = std(abs(kurvs));
    featureVector(16) = max(abs(kurvs));
    featureVector(17) = min(abs(kurvs));
    
    % Bending Energy
    featureVector(18) = sum(kurvs.^2);
    
    %Absolute Curvature
    featureVector(19) = sum(kurvs);
    
    
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
    featureVector(5) = redstats(indexOfRegion).MeanIntensity;
    featureVector(6) = greenstats(indexOfRegion).MeanIntensity;
    featureVector(7) = bluestats(indexOfRegion).MeanIntensity;
    featureVector(8) = graystats(indexOfRegion).MeanIntensity;
    featureVector(8) = hstats(indexOfRegion).MeanIntensity;
    featureVector(8) = vstats(indexOfRegion).MeanIntensity;
    
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
    hr = histogram(double(redstats(indexOfRegion).PixelValues),25);
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
    [glcm2,SI] = graycomatrix(imageGray,'Offset',[2 0],'Symmetric',true);
    textureFeatures = GLCM_Features(glcm2);
    
    featureVector(40) = textureFeatures.contr;
    featureVector(40) = textureFeatures.energ;
    featureVector(40) = textureFeatures.sosvh;
    featureVector(40) = textureFeatures.entro;
    featureVector(40) = textureFeatures.homop;
    featureVector(40) = textureFeatures.savgh;
    featureVector(40) = textureFeatures.senth;
    featureVector(40) = textureFeatures.svarh;
    featureVector(40) = textureFeatures.denth;
    featureVector(40) = textureFeatures.dvarh;
    featureVector(40) = textureFeatures.inf1h;
    featureVector(40) = textureFeatures.inf2h;
    featureVector(40) = textureFeatures.corrp;

    
    
    

end

