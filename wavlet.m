function out = wavlet(dims, theta, a, epsilon, k0)

rows = dims(1);
cols = dims(2);

% X values
x = (0:(cols - 1)) - (cols - 1)/2;
x = ones(rows,1) * x;

% Y values
y = (0:(rows - 1))' - (rows - 1)/2;
y = - y * ones(1,cols);

% Rotation by -theta
rotx = x * cos(-theta) - y * sin(-theta);
roty = x * sin(-theta) + y * cos(-theta);
scaledrotx = rotx / a;
scaledroty = roty / a;

% The complex exponential. equation(1) from paper
comp_exp = exp( j * (k0(1) * scaledrotx + k0(2) * scaledroty));

%equation # 2 2-D Gabor wavelet
epsilonx = scaledrotx * (epsilon^(-0.5));
gaussian2d = exp( (-0.5) * (epsilonx.^2 + scaledroty.^2));
out = comp_exp .* gaussian2d;
