% 载入图像
%清理窗口  
close all  
clear all  
clc  
% 输入图像名字  
img_name = input('请输入图像名字(图像必须为RGB图像，输入0结束)：','s'); 
grid_number = input('请输入网格数 ：');
% 当输入0时结束  
while ~strcmp(img_name,'0')  
    % 进行人脸识别  
    %for grid_number = 1:20
       % grid_number = grid_number*10
    facebook(img_name, grid_number);
        %pause
    %end
    img_name = input('请输入图像名字(图像必须为RGB图像，输入0结束)：','s'); 
    grid_number = input('请输入网格数 ：');
end  
