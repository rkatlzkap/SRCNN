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
weights_conv1 = reshape(weights_conv1, conv1_patchsize, conv1_patchsize, conv1_filters); % convolution ?��?��?�� ?��?��?�� ?�� ?��?���? convoluition filter?�� ?��기�?? reshape?���?, patch별로 ?��?��?��
conv1_featuremap = zeros(height, width, conv1_filters);
for i = 1 : conv1_filters
    conv1_featuremap(:,:,i) = imfilter(I, weights_conv1(:,:,i), 'same', 'replicate'); % convolution ?��?��?�� ?��?��?��?�� featuremap?�� 추출?��?��
    conv1_featuremap(:,:,i) = max(conv1_featuremap(:,:,i) + biases_conv1(i), 0); % ReLU?��?��?�� ?��?��?�� resize?��?��, ?��?��?�� 결과�? 추출?��?��?�� = 기울�? ?���? 문제 방�?
end


% 2nd convolution layer - Non-linear mapping
conv2_featuremap = zeros(height, width, conv2_filters);
for i = 1 : conv2_filters
    for j = 1 : conv2_channels
        conv2_subfilter = reshape(weights_conv2(j,:,i), conv2_patchsize, conv2_patchsize); % convolution ?��?��?�� ?��?��?�� ?�� ?��?���? convoluition filter?�� ?��기�?? reshape?���?, patch별로 ?��?��?��
        conv2_featuremap(:,:,i) = conv2_featuremap(:,:,i) + imfilter(conv1_featuremap(:,:,j), conv2_subfilter, 'same', 'replicate'); % 추출?�� featuremap?? input�? output ?��?��?�� nonlinear?�� �?�?(feature)�? 추출?���? ?��?��
    end
    conv2_featuremap(:,:,i) = max(conv2_featuremap(:,:,i) + biases_conv2(i), 0); % ReLU?��?��
end


% 3rd convolution layer - concatenation
conv3_featuremap = zeros(height, width);
for i = 1 : conv3_channels
    conv3_subfilter = reshape(weights_conv3(i,:), conv3_patchsize, conv3_patchsize); % convolution ?��?��?�� ?��?��?�� ?�� ?��?���? convoluition filter?�� ?��기�?? reshape?���?, patch별로 ?��?��?��
    conv3_featuremap(:,:) = conv3_featuremap(:,:) + imfilter(conv2_featuremap(:,:,i), conv3_subfilter, 'same', 'replicate'); % 2nd layer?��?�� 추출?�� featuremap?�� ?�� ?��?��?�� ?��치기 ?��?��, 겹치?�� ?��?��?�� ?��?���? convolution?��?�� feature?��?�� 모�??��
end


% Reconstruction
im_SRCNN = conv3_featuremap(:,:) + biases_conv3;