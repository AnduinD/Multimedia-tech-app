% clear all; clc;

% 读入编码帧和参考帧
%imgCur  = imread('18.png');
imgCurGray = rgb2gray(imread('18.png'));
%imgNext = imread('20.png');
imgNextGray = rgb2gray(imread('20.png'));

% 设置编码参数
w = 16;
macro_block_size = 8;

% % 运动估计
% motion_vector_matrix = motion_estimation_exhaustive_search(imgCurGray,imgNextGray, macro_block_size, w);
% 
% % 运动补偿
% residual_matrix = motion_compensation(imgCurGray,imgNextGray,motion_vector_matrix, macro_block_size);
% 
% % 解码还原
% imgDecode = frame_decode(imgNextGray,motion_vector_matrix,residual_matrix,macro_block_size);
% 
% % 看看解码后的图像和实际图像差多少
% imgDelta = imgCurGray-uint8(imgDecode);
% figure(100);imshow(imgDelta);title("imgCur - imgDecode");



motion_vector_matrix_3step = motion_estimation_3step_search(imgCurGray,imgNextGray, macro_block_size, w);
residual_matrix_3step = motion_compensation(imgCurGray,imgNextGray,motion_vector_matrix_3step, macro_block_size);
imgDecode_3step = frame_decode(imgNextGray,motion_vector_matrix_3step,residual_matrix_3step,macro_block_size);
imgDelta_3step = imgCurGray-uint8(imgDecode_3step);
figure(100);imshow(imgDelta_3step);title("imgCur - imgDecode (3 step method)");