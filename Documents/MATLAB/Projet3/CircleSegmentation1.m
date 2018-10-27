function [ outputImage,keptBoundary,keptStats,boundMatrix ] = CircleSegmentation1( inputImage )
%UNTITLED2 Summary of this function goes here
%IDEA: USE ENTROPY
%   Detailed explanation goes here

    nevus01RGB = inputImage;
    
    AreaTot = length(nevus01RGB(:,1,1))*length(nevus01RGB(1,:,1)); 
    imshow(nevus01RGB);
    
    nevus01GRAY = rgb2gray(nevus01RGB);
    nevus01GRAY = preprocessing(nevus01GRAY);
    %nevus01GRAY = Gillette(nevus01GRAY);
    
    
    nevusGrayDouble = im2double(nevus01GRAY);
    contraste=std(nevusGrayDouble);
    contrasteMean = mean(contraste);
    
    %nevus01GRAYContrast = histeq(nevus01GRAY);
    inverseGray = uint8(255)-im2uint8(nevus01GRAY);
    %inverseGray = adapthisteq(inverseGray);
    [inverseGray,T] = histeq(inverseGray);
    %figure, imshow(nevus01BW);
    
    % TODO: Commencer la boucle ici
    outputImage = nevus01RGB;
    keptBoundary = -1;
    keptStats=0;
    boundMatrix=0;
    found = false;
    ended = false;
    sensitivity = 0.5;
    realMetricString = '';
    
    while found==false || ended==false
        lastMetric = 0.15;
        disp('we in')
        %replace hard-coded value with variable: sensitivity
        nevus01BW = im2bw(inverseGray,sensitivity);
        %nevus01BW = imbinarize(nevus01GRAY);

        %figure, imshow(inverseGray);

        % remove all object containing fewer than 30 pixels
        nevus01BW = bwareaopen(nevus01BW,150);
        %figure, imshow(nevus01BW);
        % fill a gap in the pen's cap
        se = strel('disk',2);
        nevus01BW = imclose(nevus01BW,se);

        %figure,imshow(nevus01BW);


        Bw_filled = imfill(nevus01BW,'holes');
        imshow(Bw_filled);
        pause(0.25);
        imshow(nevus01RGB);

        outputImage = Bw_filled;
        %%
        % Finding boundaries:
        [B,L] = bwboundaries(nevus01BW,'noholes');
        %imshow(nevus01RGB);
        % Display the label matrix and draw each boundary
        %figure,imshow(label2rgb(L, @jet, [.5 .5 .5]))
        hold on
        %for k = 1:length(B)
         % boundary = B{k};
          %plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
        %end

        %%
        % Determining circularity index
        stats = regionprops(L,'Area','Centroid','ConvexArea','Perimeter','Eccentricity');

        threshold = 0.15;

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
          isBorderDetected = ImBorderDetection(boundary,inverseGray);

          % mark objects above the threshold with a black circle
          if (metric > threshold && areaFactor > 0.008 && areaFactor < 0.25 && isBorderDetected == false)
              disp('in threshold');
              if found==true
                  disp('in found == true');
                  if metric > lastMetric
                      disp('in metric >');
                      realMetricString = sprintf('%2.2f',metric);
                      lastMetric = metric;
                      lastAreaFactor = areaFactor;
                      keptBoundary = B{k};
                      keptStats = stats(k);
                      boundMatrix = L;
                  end
              else
                  disp('found is false');
                  found = true;
                  realMetricString = sprintf('%2.2f',metric);
                  lastMetric = metric;
                  lastAreaFactor = areaFactor;
                  keptBoundary = B{k};
                  keptStats = stats(k);
                  boundMatrix = L;
              end
          end

        end

        if (found == true)
            ended = true;
        end
        
        sensitivity = sensitivity + 0.02;
        
        isNextBetter = CheckNextSensitivity(lastMetric,inverseGray,sensitivity,AreaTot);
        if (isNextBetter == true)
            ended = false;
            found = false;
        end
    end
    
    if keptBoundary~=-1
        
        plot(keptBoundary(:,2), keptBoundary(:,1), 'w', 'LineWidth', 2)
        centroid = keptStats.Centroid;
        plot(centroid(1),centroid(2),'ko');
        text(boundary(1,2)-35,boundary(1,1)+13,realMetricString,'Color','y',...
        'FontSize',14,'FontWeight','bold')
        title(['Metrics closer to 1 indicate that ',...
               'the object is approximately round']);
    end
    
end

