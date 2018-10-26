nevus01RGB = imread('U6.jpg');


figure, imshow(nevus01RGB);

nevus01GRAY = rgb2gray(nevus01RGB);
%nevus01GRAYContrast = histeq(nevus01GRAY);
inverseGray = uint8(255)-nevus01GRAY;


%nevus01BW = imbinarize(inverseGray);
nevus01BW = im2bw(inverseGray,0.58);
figure, imshow(nevus01BW);

figure, imshow(inverseGray);

% remove all object containing fewer than 150 pixels
nevus01BW = bwareaopen(nevus01BW,150);
figure, imshow(nevus01BW);
% fill a gap in the pen's cap
se = strel('disk',2);
nevus01BW = imclose(nevus01BW,se);

figure,imshow(nevus01BW);


Bw_filled = imfill(nevus01BW,'holes');
figure,imshow(Bw_filled);
%%
% Finding boundaries:
[B,L] = bwboundaries(nevus01BW,'noholes');
figure,imshow(nevus01RGB);
% Display the label matrix and draw each boundary
figure,imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

%%
% Determining circularity index
stats = regionprops(L,'Area','Centroid');

threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  area_string = sprintf('%2.2f',area);
  disp(area);
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  
  % display the results
  metric_string = sprintf('%2.2f',metric);
  disp(metric_string);

  % mark objects above the threshold with a black circle
  if metric > threshold
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
  end
  
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold');
  
end

title(['Metrics closer to 1 indicate that ',...
       'the object is approximately round']);


