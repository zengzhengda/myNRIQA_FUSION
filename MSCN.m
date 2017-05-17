%图像标准化
function [mscn_map]=MSCN(disimg)
if(ndims(disimg)==3)
    disimg=rgb2gray(disimg);
end
disimg=double(disimg);
window=fspecial('gaussian',7,7/6);
window=window/sum(sum(window));

mu=filter2(window,disimg,'same');
mu_sq=mu.*mu;
sigma=sqrt(abs(filter2(window, disimg.*disimg, 'same') - mu_sq)); % sigma的求法
mscn_map=(disimg-mu)./(sigma+eps);
