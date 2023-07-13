function output_image = bilinear2(input_image, scale_factor)
    % �Էµ� �̹����� ���򺰷� �и�
    A = input_image(:,:,1); % R �̹���
    B = input_image(:,:,2); % G �̹���
    C = input_image(:,:,3); % B �̹���
    
    % A ����� ������ ���̸� ����.
    [orig_height,orig_width] = size(A);
    tic
    % original size�� �ø��� ���� scale factor �����ش�.
    new_height = ceil(orig_height * scale_factor); 
    new_width = ceil(orig_width * scale_factor); 
    bit = class(input_image); 
    
    % scale factor�� ���� ��ŭ �� �迭 ����
    A_new = zeros(new_height,new_width,bit);
    B_new = zeros(new_height,new_width,bit);
    C_new = zeros(new_height,new_width,bit);

    % scale factor��ŭ Ŀ�� �� �迭�� bilinear ������ �����Ͽ� image �����
    for y_out = 1:new_height
        dy = (y_out/scale_factor) + (0.5 * (1 - 1/scale_factor));
        for x_out = 1:new_width
            dx = (x_out/scale_factor) + (0.5 * (1 - 1/scale_factor)); 
            dx(dx < 1) = 1; 
            if dx >= orig_width 
                dx = orig_width;
                x1 = floor(dx) - 1; 
            else
                x1 = floor(dx);
            end
            x2 = x1 + 1; 

            dy(dy < 1) = 1; 
            if dy >= orig_height
                dy = orig_height
                y1 = floor(dy) - 1; 
            else
                y1 = floor(dy); 
            end
            y2 = y1 + 1; 
 
            Ax_y1 = (x2 - dx)*A(y1,x1) + (dx - x1)*A(y1,x2);
            Ax_y2 = (x2 - dx)*A(y2,x1) + (dx - x1)*A(y2,x2);
            A_new(y_out,x_out) = (y2 - dy)*Ax_y1 + (dy - y1)*Ax_y2; 

            Bx_y1 = (x2 - dx)*B(y1,x1) + (dx - x1)*B(y1,x2);
            Bx_y2 = (x2 - dx)*B(y2,x1) + (dx - x1)*B(y2,x2);
            B_new(y_out,x_out) = (y2 - dy)*Bx_y1 + (dy - y1)*Bx_y2; 

            Cx_y1 = (x2 - dx)*C(y1,x1) + (dx - x1)*C(y1,x2);
            Cx_y2 = (x2 - dx)*C(y2,x1) + (dx - x1)*C(y2,x2);
            C_new(y_out,x_out) = (y2 - dy)*Cx_y1 + (dy - y1)*Cx_y2; 
        end
    end
   
    output_image = cat(3, A_new, B_new, C_new); 
    toc
    figure(1); imshow(output_image); axis on;
    


end