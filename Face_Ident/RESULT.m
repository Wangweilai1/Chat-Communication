% ����ͼ��
%������  
close all  
clear all  
clc  
% ����ͼ������  
img_name = input('������ͼ������(ͼ�����ΪRGBͼ������0����)��','s'); 
grid_number = input('������������ ��');
% ������0ʱ����  
while ~strcmp(img_name,'0')  
    % ��������ʶ��  
    %for grid_number = 1:20
       % grid_number = grid_number*10
    facebook(img_name, grid_number);
        %pause
    %end
    img_name = input('������ͼ������(ͼ�����ΪRGBͼ������0����)��','s'); 
    grid_number = input('������������ ��');
end  
