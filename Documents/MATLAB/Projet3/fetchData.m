function [ image ] = fetchData( path,name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    type = name(1:2);
    
    if find(strcmp(type,'sm'))
        realType='melanoma';
    end
    
    if find(strcmp(realType,'melanoma'))
        finalPath1 = strcat(path,'SuperficialMelanoma/');
        finalPath2 = strcat(finalPath1,name);
    end
    
    image = imread(finalPath2);


end

