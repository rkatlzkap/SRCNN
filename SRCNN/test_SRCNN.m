% 'SRCNN.m'?„ ?˜¸ì¶œí•˜?—¬, SRCNN?— ?˜?•œ super-resolution?„ ?ˆ˜?–‰?•˜?Š” ?Š¤?¬ë¦½íŠ¸ %

% ?ŒŒ?¼ë¯¸í„° ? •?˜
tic
im1 = imread('baby_small.png');
im2 = imread('baby.png');
times = 4; % up_scale parameter
model = 'x4.mat'; % loading SRCNN model


% SRCNN?? ì±„ë„?´ 1ê°œì¸ ?˜?ƒë§? ì²˜ë¦¬?•  ?ˆ˜ ?žˆ?Œ / rgb image to gray image
if size(im1,3) > 1 % ì±„ë„?´ 2ê°? ?´?ƒ?¸ ?˜?ƒ?¸ ê²½ìš° -> 1ê°œë¡œ ë³?ê²½í•´?•¼?•¨
    im1_gnd_ycbcr = rgb2ycbcr(im1); % ycbcrëª¨ë¸?˜ ì±„ë„ y?Š” r,g,b?˜ ?¼ì°? ê²°í•© ë°ê¸° ê°’ì„ ?˜ë¯¸í•¨. SRCNN?? ?´ ì±„ë„ yê°’ì„ super-resolution?— ?™œ?š©?•œ?‹¤. 
    im1_gnd = im1_gnd_ycbcr(:, :, 1);
end
im1_gnd = imresize(im1_gnd,4,'bicubic'); % up_scale parameter = 4
im1_gnd_nom = single(im1_gnd)/255; % super-resolution?„ ?œ„?•œ normalization. overfitting?„ ?”¼?•˜?Š” ?š¨ê³¼ë„ ?žˆ?‹¤.


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