function [ave_grad std_grad gradMap1]=fetchGradient(X)
if(ndims(X)==3)
    X=rgb2gray(X);
end
X=double(X);
Down_step=2; % 对图像降采样，减少运算量
dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
dy = dx';

% aveKernel=fspecial('average',2);
% X=conv2(X,aveKernel,'same');
% X=aveX(1:Down_step:end,1:Down_step:end); % 不改变图像大小

IxX1=conv2(X,dx,'same');
IyX1=conv2(X,dy,'same');
gradMap1=sqrt(IxX1.^2+IyX1.^2);
ave_grad1=mean2(gradMap1);
std_grad1=std2(gradMap1);
% 二阶导数
IxX2=conv2(gradMap1,dx,'same');
IyX2=conv2(gradMap1,dy,'same');
gradMap2=sqrt(IxX2.^2+IyX2.^2);
ave_grad2=mean2(gradMap2);
std_grad2=std2(gradMap2);
% 三阶导数
IxX3=conv2(gradMap2,dx,'same');
IyX3=conv2(gradMap2,dy,'same');
gradMap3=sqrt(IxX3.^2+IyX3.^2);
ave_grad3=mean2(gradMap3);
std_grad3=std2(gradMap3);
ave_grad=[ave_grad1 ave_grad2 ave_grad3];
std_grad=[std_grad1 std_grad2 std_grad3];
end