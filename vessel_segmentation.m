function [img_wavelet img_seg] = vessel_segmentation(img,bg_mask);
[r c v] = size(img);
if (r>1100); ... for Shifa Images.
    scales = 9;
else
    scales = 5;
end

    
epsi = 5; 
k_y  = 2.5;
k_x  = 0;
img_seg=0;

img = double(img) / 255;

green = img(:,:,2);
green=imcomplement(green);

im = green;
img_gr = im;
se = strel('disk',5);
img_gr = imclose(img_gr,se);
fimg = fft2(img_gr);
k0x = k_x;
k0y = k_y;
a = scales;
epsilon = epsi;

[img_wavelet]= maxwavlet(fimg, a, epsilon, [k0x k0y], 10);
% figure; imshow(img_wavelet); figure;
img_wavelet = (img_wavelet.*bg_mask(:,:,1)) 
im = img_wavelet;
im=im-min(im(:));
im=im/max(im(:));
im=uint8(im*255);
if (r > 1100)
    imf = medfilt2(im,[35 35]);
    BndBox=200;
    MjrLn=55;
    T=2.5;
else
    imf = medfilt2(im,[21 21]);
    BndBox=120;
    MjrLn=40;
    T=3;
end
vess=(im-imf)>T;
while (mean(mean(vess))<0.05)
    T=T-1;
    vess=(im-imf)>T;
end
imo = (bwareaopen((imclose(vess.*imerode(bg_mask, strel('diamond',25)),strel('diamond',4))),160));
%figure,imshow(imo)
lbl=bwlabel(imo);
prps=regionprops(imo,'BoundingBox','MajorAxisLength','MinorAxisLength');
v=zeros(1,length(prps));
for i=1:length(prps)
    if (max(prps(i).BoundingBox(3:4))<BndBox)
        if(prps(i).MajorAxisLength/prps(i).MinorAxisLength<3 || prps(i).MajorAxisLength<MjrLn);
        v(i)=i;
        end
    end
end
[~, ~ ,objs] = find(v);
imo = (~ismember(lbl,objs).*imo) > 0;
% L = bwlabel(imo);
% prps=regionprops(imo,img(:,:,2), 'MeanIntensity','MaxIntensity','MinIntensity');
% imo = ismember(L, find([prps.MeanIntensity] < 0.36));
img_seg = imo;
