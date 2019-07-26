clc
clear all
close all
%%
for ii=1:100
    %[FileName,PathName] = uigetfile('nonmydriatic1\*.*','Select A Fundus Image');
    PathName = 'D:\2d_gabor_wavelets\label\';
    FileName = strcat(num2str(ii),'.jpg');
    img1 = imread([PathName FileName]);
    [rr cc v] = size(img1);
    if(cc < 1600)
        cameraModel = 1;
    else
        cameraModel = 2;
    end
    img = imresize(img1,[1024 1024]);
    
    baseFileName = strcat(num2str(ii),'.png'); % Whatever....
    fullFileName = fullfile('D:\2d_gabor_wavelets\labels_after_resized_greyscale', baseFileName);
    imwrite(img(:,:,1), fullFileName);
end