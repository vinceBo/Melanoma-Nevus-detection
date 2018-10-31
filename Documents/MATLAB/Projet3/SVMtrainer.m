function [ predictionAccuracy ] = SVMtrainer( definedVector, featureMatrix )
%SVMtrainer trains the classification algorithm, returns % of successful classification (accuracy)
%   Input: definedVector = vector containing the defining attributes (nevus, melanoma) featureMatrix = corresponding features
%   Output: Accuracy (%)
    Y = definedVector;

    [m,n] =size(featureMatrix);
    [nbData, garbage] = size(Y);

    for i=1:2*n
        if mod(i,2) ~= 0
            vectorFeatureDef((i+1)/2) = i; 
        end
    end

    % change nevus/melanoma to 1,2, create a 2n large matrix for feature selection

    grp2idx(definedVector);

    X = randn(nbData,2*n);
    X(:,vectorFeatureDef) = featureMatrix(1:nbData,:);

    % 80% for training, 20% for verification
    rand_num = randperm(nbData);
    numOfTrainees = uint16(nbData * 0.8);

    X_train = X(rand_num(1:numOfTrainees),:);
    Y_train = Y(rand_num(1:numOfTrainees),:);

    X_test = X(rand_num(numOfTrainees+1:end),:);
    Y_test = Y(rand_num(numOfTrainees+1:end),:);

    %% Cross validation (CV) partition (check what the 5 means)
    c = cvpartition(Y_train,'k',5);

    %% Feature selection
    opts = statset('display','iter');
    fun = @(train_data, train_labels, test_data, test_labels)...
        sum(predict(fitcsvm(train_data, train_labels, 'KernelFunction', 'rbf'), test_data) ~= test_labels);
    [fs, history] = sequentialfs(fun,X_train,Y_train,'cv',c,'options',opts,'nfeatures',3);

    %% Best hyperparameters
    X_train_w_best_features = X_train(:,fs);
    Md1 = fitcsvm(X_train_w_best_features,Y_train,'KernelFunction','rbf','OptimizeHyperparameters','auto',...
      'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
      'expected-improvement-plus','ShowPlots',true)); % Bayes' Optimization

    %% Test
    X_test_w_best_features = X_test(:,fs);
    accuracy = sum(predict(Md1, X_test_w_best_features) == Y_test)/length(Y_test) * 100;


    predictionAccuracy = accuracy;
end

