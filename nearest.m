
inputimage=imread('woman_small.png'); % �̹��� �ҷ�����

scale=[4 4]; % ������ ����
oldsize=size(inputimage); % input image�� size ����
tic
% ���� ����
newsize2=scale.*oldsize(1:2); 
rowindex2=round(((1:newsize2(1))-0.5)./scale(1)+0.5);
colindex2=round(((1:newsize2(2))-0.5)./scale(2)+0.5);
largerimage=inputimage(rowindex2,colindex2,:);
toc
figure(1);imshow(largerimage);title('NN'); axis on;

original=imread('woman.png');
PSNR=psnr(largerimage,original); % psnr ����ϴ� ���� �Լ�
fprintf('PSNR : %f\n',PSNR); % ���â�� PSNR �� ǥ�����ִ� �Լ�
