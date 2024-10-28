% Demo code for CVPR submission #7690:
% "Diffeomorphic Template Registration for Atmospheric Turbulence Mitigation."
%
% Code tested in MatLab R2021b
% Please do not distribute.


clear; close all;
%% Loading data
addpath(genpath('toolbox'));
load('sample_data.mat')
for i = 1:100
    img{i} = im2double(image_stack(:,:, i));
end

%% Flow estimation
parfor i = 1:100
    % Flow Option 1:
    % For demonstration purposes, here we use simple Horn-Schunck Optical Flow
    % Horn and Schunck. "Determining optical flow."
    % Flow implementation by:
    % Sun et al. "Secrets of optical flow estimation and their principles."
    flow{i} = HS_optical_flow(img{1}, img{i}, 'hs-brightness');

%     % Flow Option 2 (with spatial pyramid), implementation by:
%     % Ce Liu, "Beyond pixels: exploring new representations and applications for motion analysis."
%     % Faster than vanilla Horn-Schunck Optical Flow
%     % Please ignore error message popped up from 3-rd party code.
%     [vx,vy,warpI2] = Coarse2FineTwoFrames(img{1},img{i},flow_parameters);
%     flow{i}(:,:,1) = vx;
%     flow{i}(:,:,2) = vy;
end

%% Flow aggregation and inversion
for i = 1:100
    flow_all(:,:,:,i) = flow{i};
end
flow_distortion = mean(flow_all,4);
flow_distortion_inv = invert_flow(flow_distortion);

%% Mapping all frames to the reference frame (frame 1 by default)
for i = 1:100
    aligned(:,:,:,i) = layer_interp(squeeze(img{i}), flow{i});
end
aligned_mean = nanmean(aligned, 4);

%% Alignment to the reference frame
template = layer_interp(aligned_mean, flow_distortion_inv, 1);

%% Bline Deconvotlution implementation by:
% Chan et al. "Plug-and-play ADMM for image restoration: Fixed-point convergence and applications."
clean = deblur_ADMM(template);

figure;
imshow(img{1});
title('Image 1');
figure;
imshow(mean(image_stack,3));
title('Naive Averaging');
figure;
imshow(template);
title('Our Template');
figure;
imshow(clean);
title('After Deconvolution');

