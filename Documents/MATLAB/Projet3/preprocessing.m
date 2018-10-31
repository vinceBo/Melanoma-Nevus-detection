function [ imageFiltree ] = preprocessing( imageOriginale )
%preprocessing Prepares image for segmentation stage
%   Input: Original Image Output: Image filtered with HP, homomorphic
    %Homomorphic filtering to improve lighting
    doubleOi = im2double(imageOriginale);
    doubleOi = log(1 + doubleOi);
    M = 2*size(doubleOi,1);
    N = 2*size(doubleOi,2);
    sigma =1;

    %HP filtering
    [X,Y] = meshgrid(1:N,1:M);
    centerX = ceil(N/2);
    centerY = ceil(M/2);
    gaussianNumerator = (X - centerX).^2 + (X - centerY).^2;
    H = exp(-gaussianNumerator./(2*sigma.^2));
    H = 1-H;

    H = fftshift(H);
    If = fft2(doubleOi,M,N);
    Iout = real(ifft2(H.*If));
    Iout = Iout(1:size(doubleOi,1),1:size(doubleOi,2));
    
    %Returning homomorphic filtered
    imageFiltree = exp(Iout) - 1;
    
    %[x,y] = size(imageFiltree);
    %n = floor(5*sqrt((x/768)*(y/512)));
    %imageFiltree = medfilt2(imageFiltree,[n n]);
    
    %imageFiltree = imgaussfilt(imageFiltree,0.1);

end

