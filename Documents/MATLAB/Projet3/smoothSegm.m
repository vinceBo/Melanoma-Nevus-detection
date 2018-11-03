function [ smoothedBound ] = smoothSegm( Boundary )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    nbOfPixels = size(Boundary);
    
    for k = 1:nbOfPixels(1);
        if k == 1 || k == nbOfPixels(1)
            smoothedBound(k,:) = Boundary(k,:);
        else
            smoothedBound(k,:) = (Boundary(k-1,:) + Boundary(k+1,:)) / 2;
        end
    end
    

end

