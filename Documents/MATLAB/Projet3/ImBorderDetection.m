function [ isImageBorder ] = ImBorderDetection( boundary, image )
%UNTITLED This function checks if the border of the image is part of the
%boundary region (happens from time to time and is quite annoying).
%   returns true if more than 5 border elements in the boundary matrix (10 pixels 
%   are part image boundary).
    [maxX,maxY] = size(image);
    isImageBorder = false;
    %Checking ones
    vectorOfOnes = sum(boundary == 1);
    numberOfOnes = sum(vectorOfOnes);
    %Checking max in X
    vectorOfX = sum(boundary == maxX);
    numberOfX = sum(vectorOfX);
    %Checking max in Y
    vectorOfY = sum(boundary == maxY);
    numberOfY = sum(vectorOfY);

    if (numberOfOnes > 5 || numberOfX > 5 || numberOfY >5)
        isImageBorder = true;
    end
   

end

