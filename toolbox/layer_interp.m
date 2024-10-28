function [layer, time] = layer_interp(img,flow,inpaint,mode)

if nargin < 4
    mode = 'bilinear';
end

[h, w, n] = size(img);
[x, y] = meshgrid(1:w, 1:h);
w_x=x+flow(:,:,1);
w_y=y+flow(:,:,2);
layer = img;
for i = 1:n
layer(:,:,i)=interp2(img(:,:,i), w_x, w_y, mode);
end
mask = ones(h, w);
time=interp2(double(mask), w_x, w_y);
time(isnan(time)) = 0;

if nargin > 2
    for i = 1:n
    layer(:,:,i) = inpaint_nans(layer(:,:,i));
    end
end
