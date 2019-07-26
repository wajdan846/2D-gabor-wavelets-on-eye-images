function bg_mask = BgSegmentation(im)
    img = im;
    [r, ~, v] = size(img);
    if(v == 3)
        im = double(im(:,:,2));
    end
    im = medfilt2(im,[11 11]);
    th = 10;  
    mask = im >= th;
    %figure,imshow(mask);
    % Removes spurious regions.
    mask = bwareaopen(mask, 200000);

    % Fills in holes.
    mask = ~bwareaopen(~mask, 100);

    % A minor erosion. 
    bg_mask = ~imerode(~mask, strel('disk', 5));  
    
    bw_fill = imfill(bg_mask,'holes');
    L = bwlabel(bw_fill);
    S = regionprops(L,bw_fill,'Area');        
    bg_mask = ismember(L, find([S.Area] > max([S.Area]-1)));
    if(sum(bg_mask(1,:)) > 0)
        bg_mask(1:10,:) = 0;
        bg_mask(r-10:r,:) = 0;
    end
    