function output = deblur_ADMM(input)

z = padarray(input,[20 20],'replicate');

%deblur parameters
method = 'BM3D';
lambda = 0.0001;

opts.rho     = 0.05;
opts.gamma   = 1;
opts.max_itr = 30;
opts.print   = false;
h = fspecial('gaussian',[15 15], 1.5);

z = PlugPlayADMM_deblur(z,h,lambda,method,opts);

output = z(21:size(input,1)+20,21:size(input,2)+20);