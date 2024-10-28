function flow_inverted = invert_flow(flow)
[h, w, ~] = size(flow);

weight_all = zeros(h,w);

flow_inverted = zeros(h,w,2);
[x, y] = meshgrid(1:w, 1:h);
w_x=x+flow(:,:,1);
w_y=y+flow(:,:,2);
for i = 1:h
    for j = 1:w
        a = floor(w_x(i,j));
        b = floor(w_y(i,j));
        weight = 2 - abs(w_x(i,j) - a) - abs(w_y(i,j) - b);
        if a>0 && a<=w && b>0 && b <= h
            flow_inverted(b,a,1) = flow_inverted(b,a,1) - flow(i,j,1) * weight;
            flow_inverted(b,a,2) = flow_inverted(b,a,2) - flow(i,j,2) * weight;
            weight_all(b,a) = weight_all(b,a) + weight;
        end
        a = floor(w_x(i,j));
        b = ceil(w_y(i,j));
        weight = 2 - abs(w_x(i,j) - a) - abs(w_y(i,j) - b);
        if a>0 && a<=w && b>0 && b <= h
            flow_inverted(b,a,1) = flow_inverted(b,a,1) - flow(i,j,1) * weight;
            flow_inverted(b,a,2) = flow_inverted(b,a,2) - flow(i,j,2) * weight;
            weight_all(b,a) = weight_all(b,a) + weight;
        end
        a = ceil(w_x(i,j));
        b = floor(w_y(i,j));
        weight = 2 - abs(w_x(i,j) - a) - abs(w_y(i,j) - b);
        if a>0 && a<=w && b>0 && b <= h
            flow_inverted(b,a,1) = flow_inverted(b,a,1) - flow(i,j,1) * weight;
            flow_inverted(b,a,2) = flow_inverted(b,a,2) - flow(i,j,2) * weight;
            weight_all(b,a) = weight_all(b,a) + weight;
        end
        a = ceil(w_x(i,j));
        b = ceil(w_y(i,j));
        weight = 2 - abs(w_x(i,j) - a) - abs(w_y(i,j) - b);
        if a>0 && a<=w && b>0 && b <= h
            flow_inverted(b,a,1) = flow_inverted(b,a,1) - flow(i,j,1) * weight;
            flow_inverted(b,a,2) = flow_inverted(b,a,2) - flow(i,j,2) * weight;
            weight_all(b,a) = weight_all(b,a) + weight;
        end
    end
end

for i = 1:2
    flow_inverted(:,:,i) = inpaint_nans(flow_inverted(:,:,i) ./ weight_all, 5);
end
