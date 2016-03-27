function facebook(img_name, grid_nub) 
% ����ͼ��
Img = imread(img_name);
if ndims(Img) == 3
    gray = rgb2gray(Img);
else
    gray = Img;
end
% ��ͼ��ת��ΪYCbCr��ɫ�ռ�  
YCbCr = rgb2ycbcr(Img);  
% ���ͼ���Ⱥ͸߶�  
heigth = size(gray, 1);  
width = size(gray, 2);  
% ���ݷ�ɫģ�ͽ�ͼ���ֵ��  
for i = 1:heigth  
    for j = 1:width  
        Y = YCbCr(i, j, 1); 
        Cb = YCbCr(i, j, 2);  
        Cr = YCbCr(i, j, 3);  
        if(Y < 80)  
            gray(i, j) = 0;  
        else  
            if(skin(Y, Cb, Cr) == 1)  
                gray(i, j) = 255;  
            else  
                gray(i, j) = 0;  
            end  
        end  
    end  
end  
% ��ֵͼ����̬ѧ����  
SE = strel('arbitrary', eye(5));    
%gray = bwmorph(gray,'erode');  
% imopen�ȸ�ʴ������  
BW = imopen(gray, SE);
% imclose�������ٸ�ʴ  
%gray = imclose(gray,SE);  

figure;
subplot(2, 2, 1); imshow(Img);
title('ԭͼ��', 'FontWeight', 'Bold');
subplot(2, 2, 2); imshow(Img);
title('������ͼ��', 'FontWeight', 'Bold');
hold on;
grid_number = floor(grid_nub);
[xt, yt] = meshgrid(round(linspace(1, size(gray, 1), grid_number)), ...
    round(linspace(1, size(gray, 2), grid_number)));
mesh(yt, xt, zeros(size(xt)), 'FaceColor', ...
    'None', 'LineWidth', 1, ...
    'EdgeColor', 'r');
subplot(2, 2, 3); imshow(BW);
title('��ֵͼ��', 'FontWeight', 'Bold');
[n1, n2] = size(BW);
r = floor(n1/grid_number); % �ֳ�10�飬��
c = floor(n2/grid_number); % �ֳ�10�飬��
x1 = 1; x2 = r; % ��Ӧ�г�ʼ��
s = r*c; % �����
for i = 1:grid_number
    y1 = 1; y2 = c; % ��Ӧ�г�ʼ��
    for j = 1:grid_number
        if (y2 >= c && y2 <= grid_number*c) || (x2 >= r && x2 <= r*grid_number)
            % ���������������
            loc = find(BW(x1:x2, y1:y2) == 0);
            [p, q] = size(loc);
            pr = (p * q)/s * 100; % ��ɫ������ռ�ı�����
            if pr >= 80
                BW(x1:x2, y1:y2) = 0;
            end
        end
        y1 = y1 + c; % ����Ծ
        y2 = y2 + c; % ����Ծ
    end
    x1 = x1 + r; % ����Ծ
    x2 = x2 + r; % ����Ծ
end
[L, num] = bwlabel(BW, 8); % ������
stats = regionprops(L, 'BoundingBox'); % �õ���Χ���ο�
Bd = cat(1, stats.BoundingBox);
[s1, s2] = size(Bd);
mx = 0;
for k = 1:s1
    p = Bd(k, 3)* Bd(k, 4); % ��*��
    if p>mx && (Bd(k, 3)/Bd(k, 4)) < 1.8
        % ������������󣬶��ҿ�/�� < 1.8
        mx = p;
        j = k;
    end
end
subplot(2, 2, 4);imshow(Img); hold on;
rectangle('Position', Bd(j, :), 'Curvature',[1,1],...
    'EdgeColor', 'r', 'LineWidth', 2);
title('���ͼ��', 'FontWeight', 'Bold');
figure(2)
imshow(Img); hold on;
rectangle('Position', Bd(j, :), 'Curvature',[1,1],...
    'EdgeColor', 'r', 'LineWidth', 2);
title('���ͼ��', 'FontWeight', 'Bold');