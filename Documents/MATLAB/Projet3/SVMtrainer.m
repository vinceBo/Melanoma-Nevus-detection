function [ output_args ] = SVMtrainer( definedVector, featureMatrix )
%SVMtrainer trains the classification algorithm, returns % of successful classification (accuracy)
%   Input: definedVector = vector containing the defining attributes (nevus, melanoma) featureMatrix = corresponding features
%   Output: Accuracy (%)
    idVector = definedVector;
    features = featureMatrix;

    %change nevus/melanoma to 1/2
    grp2idx(definedVector);


end

