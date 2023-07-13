
inputimage=imread('woman_small.png'); % 이미지 불러오기

scale=[4 4]; % 스케일 설정
oldsize=size(inputimage); % input image의 size 추출
tic
% 공식 적용
newsize2=scale.*oldsize(1:2); 
rowindex2=round(((1:newsize2(1))-0.5)./scale(1)+0.5);
colindex2=round(((1:newsize2(2))-0.5)./scale(2)+0.5);
largerimage=inputimage(rowindex2,colindex2,:);
toc
figure(1);imshow(largerimage);title('NN'); axis on;

original=imread('woman.png');
PSNR=psnr(largerimage,original); % psnr 계산하는 내장 함수
fprintf('PSNR : %f\n',PSNR); % 명령창에 PSNR 값 표시해주는 함수
