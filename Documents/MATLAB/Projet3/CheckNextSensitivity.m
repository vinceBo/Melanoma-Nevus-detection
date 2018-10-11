function [ nextIsBetter ] = CheckNextSensitivity( metricPrevious,inverseGray,sensitivity,AreaTot )
%CheckNextSensitivity This function checks if increasing the sensitivity of
%segmentation gets better results than what we have now. Returns true if it
%is the case.
%   Detailed explanation goes here
    nextIsBetter = false;

    nevus01BW = im2bw(inverseGray,sensitivity);
    nevus01BW = bwareaopen(nevus01BW,150);
    se = strel('disk',2);
    nevus01BW = imclose(nevus01BW,se);

    Bw_filled = imfill(nevus01BW,'holes');

    outputImage = Bw_filled;
    %%
    % Finding boundaries:
    [B,L] = bwboundaries(nevus01BW,'noholes');
    % Display the label matrix and draw each boundary
    %figure,imshow(label2rgb(L, @jet, [.5 .5 .5]))

    %%
    % Determining circularity index
    stats = regionprops(L,'Area','Centroid','ConvexArea','Perimeter','Eccentricity');

    threshold = metricPrevious;

    % loop over the boundaries
    for k = 1:length(B)

        % obtain (X,Y) boundary coordinates corresponding to label 'k'
        boundary = B{k};

        % compute a simple estimate of the object's perimeter
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));

        % obtain the area calculation corresponding to label 'k'
        area = stats(k).Area;
        areaFactor = area/AreaTot;
        area_string = sprintf('%2.2f',area);
        disp(area);

        % compute the roundness metric
        metric = 4*pi*area/perimeter^2;

        % display the results
        metric_string = sprintf('%2.2f',metric);
        disp(metric_string);

        %check if border is part of this boundary
        isBorderDetected = ImBorderDetection(boundary);

        % mark objects above the threshold with a black circle
        if (metric >= threshold && areaFactor > 0.005 && areaFactor < 0.25 && isBorderDetected == false)
            nextIsBetter = true;
            break
        end

    end


end

