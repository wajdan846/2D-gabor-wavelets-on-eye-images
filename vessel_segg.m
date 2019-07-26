function [imfnf]=vessel_segg (im,bgmsk)
% clc
% clear all
% close all
% %%
% msk = 7;
% [~, ~, v] = find(fspecial('disk',msk));
% m=min(min(v));
% msk = (fspecial('disk',msk)>0) - padarray( fspecial('disk',msk-2)>m ,[2 2]);
% [~, b] = find(msk);
% msk=double(msk)/length(b);
% msk=fspecial('disk',msk);
% imshow(msk,[])
%% 
% load img_wavelet;
% im=img_wavelet;
im=im-min(im(:));
im=im/max(im(:));
im=uint8(im*255);
% im=adapthisteq(im,'Distribution','uniform');
% imshow(im)

% a=190
% im2=(uint8(im>a)*(mean(mean(im)*1.7)))+im.*uint8(im<=a);
% figure; imshow(im2)
% imf=imfilter(im,msk);
[r c v]=size(im);
if (r >1100)
    imf = medfilt2(im,[35 35]);
%     imf2 = medfilt2(im,[35 3]);
%     imf = min(imf1,imf2);
    BndBox=200;
    MjrLn=55;
    T=4;
else
    imf = medfilt2(im,[21 21]);
    BndBox=120;
    MjrLn=40;
    T=3;
end
% figure; imshow(imf,[])
%% 
% % figure;
% imshow(im)
% figure;
vess=(im-imf)>T;
while (mean(mean(vess))<0.05)
    T=T-1
    vess=(im-imf)>T;
end
imo = (bwareaopen((imclose(vess.*imerode(bgmsk, strel('diamond',25)),strel('diamond',4))),160));
% [r c]=size(im);
% imfnf=zeros(r, c ,3,'uint8');
% imfnf(:,:,1)=im;
%  imfnf= vsl;

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

imfnf=imo;

% imshow(imfnf);
% end