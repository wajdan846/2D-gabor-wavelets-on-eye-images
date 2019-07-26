






clc
clear all
close all
%%
for ii=1:100
    PathName = 'D:\2d_gabor_wavelets\after_preprocessing_resized\';
    FileName = strcat(num2str(ii),'.png');
    img1 = imread([PathName FileName]);
    img = uint8(255) - img1;
    
    baseFileName = strcat(num2str(ii),'.png'); % Whatever....
    fullFileName = fullfile('D:\2d_gabor_wavelets\after_preprocessing_resized_inverted', baseFileName);
    imwrite(img, fullFileName);
end