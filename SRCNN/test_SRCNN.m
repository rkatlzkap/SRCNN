% 'SRCNN.m'?�� ?��출하?��, SRCNN?�� ?��?�� super-resolution?�� ?��?��?��?�� ?��?��립트 %

% ?��?��미터 ?��?��
tic
im1 = imread('baby_small.png');
im2 = imread('baby.png');
times = 4; % up_scale parameter
model = 'x4.mat'; % loading SRCNN model


% SRCNN?? 채널?�� 1개인 ?��?���? 처리?�� ?�� ?��?�� / rgb image to gray image
if size(im1,3) > 1 % 채널?�� 2�? ?��?��?�� ?��?��?�� 경우 -> 1개로 �?경해?��?��
    im1_gnd_ycbcr = rgb2ycbcr(im1); % ycbcr모델?�� 채널 y?�� r,g,b?�� ?���? 결합 밝기 값을 ?��미함. SRCNN?? ?�� 채널 y값을 super-resolution?�� ?��?��?��?��. 
    im1_gnd = im1_gnd_ycbcr(:, :, 1);
end
im1_gnd = imresize(im1_gnd,4,'bicubic'); % up_scale parameter = 4
im1_gnd_nom = single(im1_gnd)/255; % super-resolution?�� ?��?�� normalization. overfitting?�� ?��?��?�� ?��과도 ?��?��.


% implement super-resolution via SRCNN
im_SRCNN = SRCNN(im1_gnd_nom, model);
im_SRCNN = uint8(im_SRCNN * 255);


% gray image -> rgb image
im1_gnd_ycbcr2 = imresize(im1_gnd_ycbcr,4,'bicubic');
im_SRCNN_cat = cat(3,im_SRCNN,im1_gnd_ycbcr2(:,:,2),im1_gnd_ycbcr2(:,:,3));
im_SRCNN_cat = ycbcr2rgb(im_SRCNN_cat);
toc
figure(1); imshow(im_SRCNN_cat); axis on; title('SRCNN');

% calculate psnr of super-resolution via SRCNN
psnr_SRCNN = psnr(im2,im_SRCNN_cat);