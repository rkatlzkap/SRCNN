function im_SRCNN = SRCNN(I, model)

% load SRCNN parameters
load(model);
[conv1_patchsize2_,conv1_filters] = size(weights_conv1);
conv1_patchsize = sqrt(conv1_patchsize2_);
[conv2_channels,conv2_patchsize_2,conv2_filters] = size(weights_conv2);
conv2_patchsize = sqrt(conv2_patchsize_2);
[conv3_channels,conv3_patchsize_2] = size(weights_conv3);
conv3_patchsize = sqrt(conv3_patchsize_2);
[height, width] = size(I);


% 1st convolution layer - Patch extraction and representation
weights_conv1 = reshape(weights_conv1, conv1_patchsize, conv1_patchsize, conv1_filters); % convolution ?—°?‚°?„ ?ˆ˜?–‰?•  ?ˆ˜ ?ˆ?„ë¡? convoluition filter?˜ ?¬ê¸°ë?? reshape?•˜ê³?, patchë³„ë¡œ ?‚˜?ˆˆ?‹¤
conv1_featuremap = zeros(height, width, conv1_filters);
for i = 1 : conv1_filters
    conv1_featuremap(:,:,i) = imfilter(I, weights_conv1(:,:,i), 'same', 'replicate'); % convolution ?—°?‚°?„ ?ˆ˜?–‰?•˜?—¬ featuremap?„ ì¶”ì¶œ?•œ?‹¤
    conv1_featuremap(:,:,i) = max(conv1_featuremap(:,:,i) + biases_conv1(i), 0); % ReLU?—°?‚°?„ ?†µ?•´?„œ resize?•˜?—¬, ?œ ?š©?•œ ê²°ê³¼ë§? ì¶”ì¶œ?•´?‚¸?‹¤ = ê¸°ìš¸ê¸? ?†Œë©? ë¬¸ì œ ë°©ì?
end


% 2nd convolution layer - Non-linear mapping
conv2_featuremap = zeros(height, width, conv2_filters);
for i = 1 : conv2_filters
    for j = 1 : conv2_channels
        conv2_subfilter = reshape(weights_conv2(j,:,i), conv2_patchsize, conv2_patchsize); % convolution ?—°?‚°?„ ?ˆ˜?–‰?•  ?ˆ˜ ?ˆ?„ë¡? convoluition filter?˜ ?¬ê¸°ë?? reshape?•˜ê³?, patchë³„ë¡œ ?‚˜?ˆˆ?‹¤
        conv2_featuremap(:,:,i) = conv2_featuremap(:,:,i) + imfilter(conv1_featuremap(:,:,j), conv2_subfilter, 'same', 'replicate'); % ì¶”ì¶œ?œ featuremap?? inputê³? output ?˜?ƒ?˜ nonlinear?•œ ê´?ê³?(feature)ë¥? ì¶”ì¶œ?•˜ê²? ?œ?‹¤
    end
    conv2_featuremap(:,:,i) = max(conv2_featuremap(:,:,i) + biases_conv2(i), 0); % ReLU?—°?‚°
end


% 3rd convolution layer - concatenation
conv3_featuremap = zeros(height, width);
for i = 1 : conv3_channels
    conv3_subfilter = reshape(weights_conv3(i,:), conv3_patchsize, conv3_patchsize); % convolution ?—°?‚°?„ ?ˆ˜?–‰?•  ?ˆ˜ ?ˆ?„ë¡? convoluition filter?˜ ?¬ê¸°ë?? reshape?•˜ê³?, patchë³„ë¡œ ?‚˜?ˆˆ?‹¤
    conv3_featuremap(:,:) = conv3_featuremap(:,:) + imfilter(conv2_featuremap(:,:,i), conv3_subfilter, 'same', 'replicate'); % 2nd layer?—?„œ ì¶”ì¶œ?•œ featuremap?„ ?•œ ?˜?ƒ?— ?•©ì¹˜ê¸° ?œ„?•´, ê²¹ì¹˜?Š” ?˜?—­?´ ?—†?„ë¡? convolution?•˜?—¬ feature?“¤?„ ëª¨ì??‹¤
end


% Reconstruction
im_SRCNN = conv3_featuremap(:,:) + biases_conv3;