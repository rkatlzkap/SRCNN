function bicubic(x, y)

%   input_image     -  bicubic interpolation ������ �̹��� 
input_image = im2double(imread(x));
[row col channel]=size(input_image);%[�� �� ä���Ǽ�(color�̹����ϱ� 3)]
tic
%   x_res-resizing�� �̹����� ���ο� �� 
%   y_res-resizing�� �̹����� ���ο� ��
x_res = 4*row; %scale factor :4(4��� resizing)
y_res = 4*col; %scale factor :4(4��� resizing)

figure(1); imshow(input_image, []); title('before resizing');
%resizing�ϱ����� input_image�� figure(1)�� ����

%M^(-1)�� �ٽ� ��� �ʿ�x, ���н����� fixed�� �� �̿��ϱ�
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
%three value�� ����[ width, height, and the number of color vectors 3]
[j k c] = size(input_image); %[�� �� ä���� ��]

%resizing���� �� �̹����� ��� ���� ���ο� ������ �缱��
x_new = x_res;
y_new = y_res;

%������ 4���� ������ scale factor�� ���ϱ� ����
%��Ʈ������ (1,1)�� ���������� �ȼ��������� (0,0)���� �����ϹǷ� ���������� ����
x_scale = x_new./(j-1);
y_scale = y_new./(k-1);

%resizing �� �̹����� ��� ��,�׸��� ä���� ������ zeros�� �ʱ�ȭ ��Ų��.
output_image = zeros(x_new, y_new, c);

%RGB�� ���� color�̹��������Ƿ� for������ ��ü������ ���� ������.
for z = 1 : c
    %z�� 1�϶� ���� �����Ͽ�
    %������ ä�ο����� ��� �� �������� ��� ���ο� ������ �����Ѵ�.
    temp_image = zeros(x_new,y_new);

    %z�� 1�϶� ���� �����Ͽ�
    %1��)������ ä�ο����� �̺��� ��ġ�� ���� ������ resizing�� �̹����� I�� �����Ѵ�. 
    I = input_image(:,:,z);

    %2��))I�� x������ �̺�
    %�̹����� x�� ���� �̺��� �ϱ� ���� zeors�� ��,���� �ʱ�ȭ�Ѵ�.
    Ix = double(zeros(j,k));
    for count1 = 1:j     %(j,k)�� ��� �̹��� �ȼ��鿡 ���� �ݺ���
        for count2 = 1:k
            if( (count2==1) || (count2==k) )
                Ix(count1,count2)=0;
                %ù��° ���� ������ ������ 0���� ������.
            else
                Ix(count1,count2)=(0.5).*(I(count1,count2+1)-I(count1,count2-1));
                %���ϴ� pixel���� ������� x���� �� ���� �ȼ��� �̿��� �̺��ϴ� ���
            end
        end
    end
    %3��))I�� y������ �̺�
    Iy = double(zeros(j,k));
    for count1 = 1:j     %(j,k)�� ��� �̹��� �ȼ��鿡 ���� �ݺ���
        for count2 = 1:k
            if( (count1==1) || (count1==j) )
                Iy(count1,count2)=0;
                %ù��° ��� ������ �࿡�� 0���� ������.
            else
                Iy(count1,count2)=(0.5).*(I(count1+1,count2)-I(count1-1,count2));
                %���ϴ� pixel���� ������� y���� �翷�� �ȼ��� �̿��� �̺��ϴ� ���
            end
        end
    end
    %4��))I�� x,y�Ѵٿ� ���� �ι� �̺�
    Ixy = double(zeros(j,k));
    for count1 = 1:j     %(j,k)�� ��� �̹��� �ȼ��鿡 ���� �ݺ���
        for count2 = 1:k
            if( (count1==1) || (count1==j) || (count2==1) || (count2==k) )
                Ixy(count1,count2)=0;
                %ù��° �����, ������ ��������� 0���� ������.
            else
                Ixy(count1,count2)=(0.25).*((I(count1+1,count2+1)+I(count1-1,count2-1)) - (I(count1+1,count2-1)+I(count1-1,count2+1)));
                %���ϴ� pixel���� ������� x,y���� �翷 �� 4���� �ȼ��� �̿��� �ι� �̺��ϴ� ���);
            end
        end
    end
    
    for count1 = 0:x_new-1
        for count2 = 0:y_new-1
             %Calculate the normalized distance constants, h and w
             %(1,1),(1,2),(2,1),(2,2) ���簢�� �׸� �ִ� �����ϱ�
             %������ ����� ���� 4���� resizing �� �̹����� �ȼ����� �˾Ƴ����Ѵ�. ����������
             %�������ٸ� ���� resizing�� �ȼ����� ���� ���� �������̰� �Ҽ������� �������ٸ�
             %bicubic interpolation���� �˾Ƴ����Ѵ�. 
             %�츮�� �� �ȼ����� �˾Ƴ������� ���簢���� (1,1),(1,2),(2,1),(2,2)��ġ������
             %�ȼ����� �˾ƾ� �ϰ� 16�� ���� ����� ������ ���س��� ���� �����̴�. 
             %floor�����Լ�:�ش� ��Һ��� �۰ų� ���� ���� ����� ������ ����
             %ceil�����Լ�:�ش� ��Һ��� ũ�ų� ���� ���� ����� ������ �ø�
             W = -(((count1./x_scale)-floor(count1./x_scale))-1);
             H = -(((count2./y_scale)-floor(count2./y_scale))-1);
            
             %Determine the indexes/address of the 4 neighbouring pixels from the source data/image
             I11_index = [1+floor(count1./x_scale),1+floor(count2./y_scale)];
             I21_index = [1+floor(count1./x_scale),1+ceil(count2./y_scale)];
             I12_index = [1+ceil(count1./x_scale),1+floor(count2./y_scale)];
             I22_index = [1+ceil(count1./x_scale),1+ceil(count2./y_scale)];
             
             
             %1��)���簢���� (1,1),(1,2),(2,1),(2,2)��ġ������ �ȼ����� ���Ѵ�.
             I11 = I(I11_index(1),I11_index(2));
             I21 = I(I21_index(1),I21_index(2));
             I12 = I(I12_index(1),I12_index(2));
             I22 = I(I22_index(1),I22_index(2));
             %2��)x�������� �̺��� ���� ���Ѵ�.
             Ix11 = Ix(I11_index(1),I11_index(2));
             Ix21 = Ix(I21_index(1),I21_index(2));
             Ix12 = Ix(I12_index(1),I12_index(2));                  
             Ix22 = Ix(I22_index(1),I22_index(2));
             %3��) %y�������� �̺��� ���� ���Ѵ�.
             Iy11 = Iy(I11_index(1),I11_index(2));
             Iy21 = Iy(I21_index(1),I21_index(2));
             Iy12 = Iy(I12_index(1),I12_index(2));
             Iy22 = Iy(I22_index(1),I22_index(2));
             %3��) %x,y�������� �ι� �̺��� ���� ���Ѵ�.
             Ixy11 = Ixy(I11_index(1),I11_index(2));
             Ixy21 = Ixy(I21_index(1),I21_index(2));
             Ixy12 = Ixy(I12_index(1),I12_index(2));
             Ixy22 = Ixy(I22_index(1),I22_index(2));
             
             %M^(-1)*beta=alpha�̹Ƿ�
             beta = [I11 I21 I12 I22 Ix11 Ix21 Ix12 Ix22 Iy11 Iy21 Iy12 Iy22 Ixy11 Ixy21 Ixy12 Ixy22];
             alpha = M_inv*beta';
             
             temp_p=0;%�ȼ����� �������� �ʱ�ȭ
             %������ for���� P(x,y),Px(x,y),Py(x,y),Pxy(x,y)�� ���� ǥ��
             for count3 = 1:16
                 w_temp = floor((count3-1)/4);%�� ���Լ��� x��y�� �������� ǥ��
                 h_temp = mod(count3-1,4);%mod�����Լ�:���� �� �������� ��ȯ
                                          %�� ���Լ��� x��y�� �������� ǥ��

                 temp_p = temp_p + alpha(count3).*((1-W)^(w_temp)).*((1-H)^(h_temp));
                 %�� for�� �������� P(x,y),Px(x,y),Py(x,y),Pxy(x,y)�� ���� ����� 
                 %resizing�� �ȼ���ǥ(H,W)�� �ش��ϴ� �ȼ����� temp_p�� ����
             end

             temp_image(count1+1,count2+1)=temp_p; 
             %57line�� zeros�� �ʱ�ȭ�� temp_image�� �� ����
        end
    end

    % New - Change by Ray - Assign to output channel
    output_image(:,:,z) = temp_image;%z�� 1�϶� ���� �����Ͽ� ������ ä�ο����� 
                                     %resizing�� �̹����� ��� �ȼ��� ����
end
toc

figure(2);imshow(output_image); title('bicubic');
I2 = imread(y); % psnr ����� ���� reference ����
I2 = im2double(I2); 
PSNR = psnr(output_image, I2); % psnr ���
fprintf('PSNR : %f\n',PSNR); % psnr ����� ���â�� ǥ�����ִ� ��ɾ�

truesize% ������ ����ũ�� ȭ�鿡 ���´�.
end
