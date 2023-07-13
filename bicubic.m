function bicubic(x, y)

%   input_image     -  bicubic interpolation 실행할 이미지 
input_image = im2double(imread(x));
[row col channel]=size(input_image);%[행 열 채널의수(color이미지니까 3)]
tic
%   x_res-resizing후 이미지의 새로운 행 
%   y_res-resizing후 이미지의 새로운 열
x_res = 4*row; %scale factor :4(4배로 resizing)
y_res = 4*col; %scale factor :4(4배로 resizing)

figure(1); imshow(input_image, []); title('before resizing');
%resizing하기전의 input_image를 figure(1)에 저장

%M^(-1)은 다시 계산 필요x, 수학식으로 fixed된 값 이용하기
M_inv = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
         0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0;
         -3,3,0,0,-2,-1,0,0,0,0,0,0,0,0,0,0;
         2,-2,0,0,1,1,0,0,0,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0;
         0,0,0,0,0,0,0,0,-3,3,0,0,-2,-1,0,0;
         0,0,0,0,0,0,0,0,2,-2,0,0,1,1,0,0;
         -3,0,3,0,0,0,0,0,-2,0,-1,0,0,0,0,0;
         0,0,0,0,-3,0,3,0,0,0,0,0,-2,0,-1,0;
         9,-9,-9,9,6,3,-6,-3,6,-6,3,-3,4,2,2,1;
         -6,6,6,-6,-3,-3,3,3,-4,4,-2,2,-2,-2,-1,-1;
         2,0,-2,0,0,0,0,0,1,0,1,0,0,0,0,0;
         0,0,0,0,2,0,-2,0,0,0,0,0,1,0,1,0;
         -6,6,6,-6,-4,-2,4,2,-3,3,-3,3,-2,-1,-2,-1;
         4,-4,-4,4,2,2,-2,-2,2,-2,2,-2,1,1,1,1
         ];

%Determine the dimensions of the source image
%three value를 가짐[ width, height, and the number of color vectors 3]
[j k c] = size(input_image); %[행 열 채널의 수]

%resizing했을 때 이미지의 행과 열을 새로운 변수로 재선언
x_new = x_res;
y_new = y_res;

%위에서 4배라고 지정한 scale factor를 구하기 위해
%매트랩에선 (1,1)로 시작하지만 픽셀단위에선 (0,0)으로 시작하므로 뺄셈연산이 존재
x_scale = x_new./(j-1);
y_scale = y_new./(k-1);

%resizing 후 이미지의 행과 열,그리고 채널의 정보를 zeros로 초기화 시킨다.
output_image = zeros(x_new, y_new, c);

%RGB가 섞인 color이미지였으므로 for루프를 전체적으로 세번 돌린다.
for z = 1 : c
    %z가 1일때 부터 시작하여
    %각각의 채널에서의 행과 열 정보만을 담는 새로운 변수를 선언한다.
    temp_image = zeros(x_new,y_new);

    %z가 1일때 부터 시작하여
    %1번)각각의 채널에서의 미분을 거치지 않은 원래의 resizing전 이미지를 I로 선언한다. 
    I = input_image(:,:,z);

    %2번))I를 x에대해 미분
    %이미지의 x축 상의 미분을 하기 위해 zeors로 행,열을 초기화한다.
    Ix = double(zeros(j,k));
    for count1 = 1:j     %(j,k)의 모든 이미지 픽셀들에 대해 반복함
        for count2 = 1:k
            if( (count2==1) || (count2==k) )
                Ix(count1,count2)=0;
                %첫번째 열과 마지막 열에선 0값을 가진다.
            else
                Ix(count1,count2)=(0.5).*(I(count1,count2+1)-I(count1,count2-1));
                %원하는 pixel값을 얻기위해 x기준 양 옆의 픽셀을 이용해 미분하는 방법
            end
        end
    end
    %3번))I를 y에대해 미분
    Iy = double(zeros(j,k));
    for count1 = 1:j     %(j,k)의 모든 이미지 픽셀들에 대해 반복함
        for count2 = 1:k
            if( (count1==1) || (count1==j) )
                Iy(count1,count2)=0;
                %첫번째 행과 마지막 행에선 0값을 가진다.
            else
                Iy(count1,count2)=(0.5).*(I(count1+1,count2)-I(count1-1,count2));
                %원하는 pixel값을 얻기위해 y기준 양옆의 픽셀을 이용해 미분하는 방법
            end
        end
    end
    %4번))I의 x,y둘다에 대한 두번 미분
    Ixy = double(zeros(j,k));
    for count1 = 1:j     %(j,k)의 모든 이미지 픽셀들에 대해 반복함
        for count2 = 1:k
            if( (count1==1) || (count1==j) || (count2==1) || (count2==k) )
                Ixy(count1,count2)=0;
                %첫번째 행과열, 마지막 헹과열에선 0값을 가진다.
            else
                Ixy(count1,count2)=(0.25).*((I(count1+1,count2+1)+I(count1-1,count2-1)) - (I(count1+1,count2-1)+I(count1-1,count2+1)));
                %원하는 pixel값을 얻기위해 x,y기준 양옆 총 4개의 픽셀을 이용해 두번 미분하는 방법);
            end
        end
    end
    
    for count1 = 0:x_new-1
        for count2 = 0:y_new-1
             %Calculate the normalized distance constants, h and w
             %(1,1),(1,2),(2,1),(2,2) 정사각형 네모가 있다 생각하기
             %역방향 사상을 통해 4배의 resizing 한 이미지의 픽셀값을 알아내려한다. 정수값으로
             %떨어진다면 원래 resizing전 픽셀값과 같은 값을 가질것이고 소수점으로 떨어진다면
             %bicubic interpolation으로 알아내야한다. 
             %우리가 그 픽셀값을 알아내기위해 정사각형의 (1,1),(1,2),(2,1),(2,2)위치에서의
             %픽셀값을 알아야 하고 16개 점의 계수의 정보를 구해내는 것이 목적이다. 
             %floor내장함수:해당 요소보다 작거나 같은 가장 가까운 정수로 내림
             %ceil내장함수:해당 요소보다 크거나 같은 가장 가까운 정수로 올림
             W = -(((count1./x_scale)-floor(count1./x_scale))-1);
             H = -(((count2./y_scale)-floor(count2./y_scale))-1);
            
             %Determine the indexes/address of the 4 neighbouring pixels from the source data/image
             I11_index = [1+floor(count1./x_scale),1+floor(count2./y_scale)];
             I21_index = [1+floor(count1./x_scale),1+ceil(count2./y_scale)];
             I12_index = [1+ceil(count1./x_scale),1+floor(count2./y_scale)];
             I22_index = [1+ceil(count1./x_scale),1+ceil(count2./y_scale)];
             
             
             %1번)정사각형의 (1,1),(1,2),(2,1),(2,2)위치에서의 픽셀값을 구한다.
             I11 = I(I11_index(1),I11_index(2));
             I21 = I(I21_index(1),I21_index(2));
             I12 = I(I12_index(1),I12_index(2));
             I22 = I(I22_index(1),I22_index(2));
             %2번)x기준으로 미분한 값을 구한다.
             Ix11 = Ix(I11_index(1),I11_index(2));
             Ix21 = Ix(I21_index(1),I21_index(2));
             Ix12 = Ix(I12_index(1),I12_index(2));                  
             Ix22 = Ix(I22_index(1),I22_index(2));
             %3번) %y기준으로 미분한 값을 구한다.
             Iy11 = Iy(I11_index(1),I11_index(2));
             Iy21 = Iy(I21_index(1),I21_index(2));
             Iy12 = Iy(I12_index(1),I12_index(2));
             Iy22 = Iy(I22_index(1),I22_index(2));
             %3번) %x,y기준으로 두번 미분한 값을 구한다.
             Ixy11 = Ixy(I11_index(1),I11_index(2));
             Ixy21 = Ixy(I21_index(1),I21_index(2));
             Ixy12 = Ixy(I12_index(1),I12_index(2));
             Ixy22 = Ixy(I22_index(1),I22_index(2));
             
             %M^(-1)*beta=alpha이므로
             beta = [I11 I21 I12 I22 Ix11 Ix21 Ix12 Ix22 Iy11 Iy21 Iy12 Iy22 Ixy11 Ixy21 Ixy12 Ixy22];
             alpha = M_inv*beta';
             
             temp_p=0;%픽셀값을 저장위해 초기화
             %다음의 for문은 P(x,y),Px(x,y),Py(x,y),Pxy(x,y)의 식을 표현
             for count3 = 1:16
                 w_temp = floor((count3-1)/4);%위 네함수의 x와y의 제곱수를 표현
                 h_temp = mod(count3-1,4);%mod내장함수:나눈 후 나머지를 반환
                                          %위 네함수의 x와y의 제곱수를 표현

                 temp_p = temp_p + alpha(count3).*((1-W)^(w_temp)).*((1-H)^(h_temp));
                 %위 for문 과정통해 P(x,y),Px(x,y),Py(x,y),Pxy(x,y)의 식을 만들고 
                 %resizing한 픽셀좌표(H,W)에 해당하는 픽셀값을 temp_p로 저장
             end

             temp_image(count1+1,count2+1)=temp_p; 
             %57line에 zeros로 초기화한 temp_image에 값 저장
        end
    end

    % New - Change by Ray - Assign to output channel
    output_image(:,:,z) = temp_image;%z가 1일때 부터 시작하여 각각의 채널에서의 
                                     %resizing한 이미지의 모든 픽셀값 저장
end
toc

figure(2);imshow(output_image); title('bicubic');
I2 = imread(y); % psnr 계산을 위한 reference 사진
I2 = im2double(I2); 
PSNR = psnr(output_image, I2); % psnr 계산
fprintf('PSNR : %f\n',PSNR); % psnr 계산을 명령창에 표시해주는 명령어

truesize% 영상의 실제크기 화면에 나온다.
end
