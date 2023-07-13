I = imread('woman_small.png');
I2 = imread('woman.png');

tic
% small image size 도출
[m n c] = size(I);

% 원본 이미지의 중간 값을 찾기 위한 수식
M = m/2;
N = n/2;

% 4배 커진 사이즈
mm = m*4;
nn = n*4;

% Fourier Transform을 사용하여 freq. domain으로 변환
F = fft2(I);

% 원하는 scale만큼 커진 0 배열 생성
Fr = zeros(mm, nn, c);

% 원본 이미지를 4등분 하여 4배 커진 빈 배열의 각 코너에 하나씩 대입
% 나머지 부분은 zero padding
for cc = 1:c
    Fr(1:M, 1:N, cc) = F(1:M, 1:N, cc);
    Fr(mm-M+1:mm, 1:N, cc) = F(m-M+1:m, 1:N, cc);
    Fr(1:M, nn-N+1:nn,cc) = F(1:M, n-N+1:n,cc);
    Fr(mm-M+1:mm, nn-N+1:nn, cc) = F(m-M+1:m, n-N+1:n,cc);
end

% zero padding된 4배 커진 이미지를 inverse Fourier Transform 실수 부분만 추출 후 스케일의 제곱만큼
% 곱해준다.
Ir = real(ifft2(Fr))*16;
% double을 uint8로 변환
Ir = uint8(Ir);
toc

figure(3); imshow(Ir); title('zero padding at freq. domain'); axis on;

PSNR = psnr(Ir, I2);
fprintf('PSNR : %f\n',PSNR); % psnr 계산을 명령창에 표시해주는 명령어