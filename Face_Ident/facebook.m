function facebook(img_name, grid_nub) 
% 载入图像
Img = imread(img_name);
if ndims(Img) == 3
    gray = rgb2gray(Img);
else
    gray = Img;
end
% 将图像转化为YCbCr颜色空间  
YCbCr = rgb2ycbcr(Img);  
% 获得图像宽度和高度  
heigth = size(gray, 1);  
width = size(gray, 2);  
% 根据肤色模型将图像二值化  
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
% 二值图像形态学处理  
SE = strel('arbitrary', eye(5));    
%gray = bwmorph(gray,'erode');  
% imopen先腐蚀再膨胀  
BW = imopen(gray, SE);
% imclose先膨胀再腐蚀  
%gray = imclose(gray,SE);  

figure;
subplot(2, 2, 1); imshow(Img);
title('原图像', 'FontWeight', 'Bold');
subplot(2, 2, 2); imshow(Img);
title('网格标记图像', 'FontWeight', 'Bold');
hold on;
grid_number = floor(grid_nub);
[xt, yt] = meshgrid(round(linspace(1, size(gray, 1), grid_number)), ...
    round(linspace(1, size(gray, 2), grid_number)));
mesh(yt, xt, zeros(size(xt)), 'FaceColor', ...
    'None', 'LineWidth', 1, ...
    'EdgeColor', 'r');
subplot(2, 2, 3); imshow(BW);
title('二值图像', 'FontWeight', 'Bold');
[n1, n2] = size(BW);
r = floor(n1/grid_number); % 分成10块，行
c = floor(n2/grid_number); % 分成10块，列
x1 = 1; x2 = r; % 对应行初始化
s = r*c; % 块面积
for i = 1:grid_number
    y1 = 1; y2 = c; % 对应列初始化
    for j = 1:grid_number
        if (y2 >= c && y2 <= grid_number*c) || (x2 >= r && x2 <= r*grid_number)
            % 如果是在四周区域
            loc = find(BW(x1:x2, y1:y2) == 0);
            [p, q] = size(loc);
            pr = (p * q)/s * 100; % 黑色像素所占的比例数
            if pr >= 80
                BW(x1:x2, y1:y2) = 0;
            end
        end
        y1 = y1 + c; % 列跳跃
        y2 = y2 + c; % 列跳跃
    end
    x1 = x1 + r; % 行跳跃
    x2 = x2 + r; % 行跳跃
end
[L, num] = bwlabel(BW, 8); % 区域标记
stats = regionprops(L, 'BoundingBox'); % 得到包围矩形框
Bd = cat(1, stats.BoundingBox);
[s1, s2] = size(Bd);
mx = 0;
for k = 1:s1
    p = Bd(k, 3)* Bd(k, 4); % 宽*高
    if p>mx && (Bd(k, 3)/Bd(k, 4)) < 1.8
        % 如果满足面积块大，而且宽/高 < 1.8
        mx = p;
        j = k;
    end
end
subplot(2, 2, 4);imshow(Img); hold on;
rectangle('Position', Bd(j, :), 'Curvature',[1,1],...
    'EdgeColor', 'r', 'LineWidth', 2);
title('标记图像', 'FontWeight', 'Bold');
figure(2)
imshow(Img); hold on;
rectangle('Position', Bd(j, :), 'Curvature',[1,1],...
    'EdgeColor', 'r', 'LineWidth', 2);
title('结果图像', 'FontWeight', 'Bold');