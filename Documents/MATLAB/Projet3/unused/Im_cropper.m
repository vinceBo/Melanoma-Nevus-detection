II = imread('U2.jpg')
[p3, p4] = size(II);
p4real = floor(p4/3);
qx = floor(p3/2.5); 
qy = floor(p4real/2.5);

i3_start = floor((p3-qx)/2); % or round instead of floor; using neither gives warning
i3_stop = i3_start + qx;

i4_start = floor((p4real-qy)/2);
i4_stop = i4_start + qy;

II2 = II(i3_start:i3_stop, i4_start:i4_stop, :);
figure ,imshow(II);
figure , imshow(II2);