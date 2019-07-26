function [wtmodmax] = maxwavlet(fimg,  a, epsilon, k0, step)

[r c] = size(fimg);


largelins = r + 1 + mod(r, 2);
largecols = c + 1 + mod(c, 2);

%%variable to store max response
wtmodmax = - Inf * ones(r,c);

for t = 0:step:179
 
  theta= t * (pi/180);
  
  % Calculates wavelet 
  wvlt = wavlet([largelins largecols], theta, a, epsilon, k0);
  wvlt = wvlt(1:r, 1:c);
%wvlt=wvlt-min(min(abs(wvlt)));
%wvlt=wvlt/max(max(abs(wvlt)));
%wvlt=wvlt-mean(mean(abs(wvlt)));
  % Takes the complex conjugate.
  cwvlt = conj(wvlt);
  
%   figure; imshow(cwvlt);
  % Shifts.
  cwvlt = fftshift (cwvlt);
   
  % Transfers to the frequency domain.
  fcwvlt = fft2 (cwvlt);

  % Multiplies image by wavelet conjugate in frequency domain.  The
  % conjugate below indicates correlation in space, instead of
  % convolution.
  fimgwv = fimg .* conj (fcwvlt);

  % Back to space domain.
  imgwv = ifft2 (fimgwv);

  % Normalization (only by scale a)
  imgwv = imgwv / a;

  % Get the modulus of the result.
  modimgwv = abs (imgwv);
%   var2 = ;
  
  % Updates the maximum.
  wtmodmax = max( modimgwv, wtmodmax );

end
