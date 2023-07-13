I = imread('woman_small.png');
I2 = imread('woman.png');

tic
% small image size ����
[m n c] = size(I);

% ���� �̹����� �߰� ���� ã�� ���� ����
M = m/2;
N = n/2;

% 4�� Ŀ�� ������
mm = m*4;
nn = n*4;

% Fourier Transform�� ����Ͽ� freq. domain���� ��ȯ
F = fft2(I);

% ���ϴ� scale��ŭ Ŀ�� 0 �迭 ����
Fr = zeros(mm, nn, c);

% ���� �̹����� 4��� �Ͽ� 4�� Ŀ�� �� �迭�� �� �ڳʿ� �ϳ��� ����
% ������ �κ��� zero padding
for cc = 1:c
    Fr(1:M, 1:N, cc) = F(1:M, 1:N, cc);
    Fr(mm-M+1:mm, 1:N, cc) = F(m-M+1:m, 1:N, cc);
    Fr(1:M, nn-N+1:nn,cc) = F(1:M, n-N+1:n,cc);
    Fr(mm-M+1:mm, nn-N+1:nn, cc) = F(m-M+1:m, n-N+1:n,cc);
end

% zero padding�� 4�� Ŀ�� �̹����� inverse Fourier Transform �Ǽ� �κи� ���� �� �������� ������ŭ
% �����ش�.
Ir = real(ifft2(Fr))*16;
% double�� uint8�� ��ȯ
Ir = uint8(Ir);
toc

figure(3); imshow(Ir); title('zero padding at freq. domain'); axis on;

PSNR = psnr(Ir, I2);
fprintf('PSNR : %f\n',PSNR); % psnr ����� ���â�� ǥ�����ִ� ��ɾ�