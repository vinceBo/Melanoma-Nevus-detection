function [ isImageBorder ] = ImBorderDetection( boundary )
%UNTITLED This function checks if the border of the image is part of the
%boundary region (happens from time to time and is quite annoying).
%   returns true if more than 10 ones in the boundary matrix (10 pixels 
%   are part image boundary).
    isImageBorder = false;
    vectorOfOnes = sum(boundary == 1);
    numberOfOnes = sum(vectorOfOnes);
    if (numberOfOnes > 5)
        isImageBorder = true;
    end
   

end

