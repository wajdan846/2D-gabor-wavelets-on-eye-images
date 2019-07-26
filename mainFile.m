clc
clear all
close all
%%
for ii=1:100
    %[FileName,PathName] = uigetfile('nonmydriatic1\*.*','Select A Fundus Image');
    PathName = 'D:\2d_gabor_wavelets\images\';
    FileName = strcat(num2str(ii),'.jpg');
    img1 = imread([PathName FileName]);
    [rr cc v] = size(img1);
    if(cc < 1600)
        cameraModel = 1;
    else
        cameraModel = 2;
    end
    img = imresize(img1,[round((rr/cc)*1600) 1600]);
    %figure,imshow(img);
    %% Background
    BgMask = BgSegmentation(img);
    %figure,imshow(BgMask)
    %% Vessel
    [vessel_wavelet, vessel_seg] = vessel_segmentation(img,BgMask);
    se =  strel('diamond',25);
    eroded_filter = imerode(BgMask,se);
    dilated_filter = imdilate(BgMask,se); 
    cropped = eroded_filter .* vessel_wavelet;
    baseFileName = strcat(num2str(ii),'.png'); % Whatever....
    fullFileName = fullfile('D:\2d_gabor_wavelets\after_pre_processing', baseFileName);
    norm_grey = uint8(255*mat2gray(cropped));
    imwrite(norm_grey, fullFileName);
    %inverseGrayImage = uint8(255) - norm_grey;
    
    %minValue = min(min(cropped));
    %maxValue = max(max(cropped));
    %figure, imshow(cropped,[minValue maxValue]);
end


