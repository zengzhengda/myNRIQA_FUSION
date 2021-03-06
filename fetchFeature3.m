% 2017-04-25 修改
function [feature]=fetchFeature3(disimg,cnt_img_level)
[rows,cols,dim]=size(disimg);
if(nargin==1)
    cnt_img_level=1;
end
feature=[];
for level=1:cnt_img_level
     %% 图像预处理
    %  disimg=imgPreDeal(disimg);

   %% 图像灰度化
    if(size(disimg,3)~=1)
        disimg_gray=double(rgb2gray(disimg));
    end
    %% 显著性特征
    sigmaF = 1.34;%fixed donot change
    omega0 = 0.0210;%fixed
    sigmaD = 145;%fixed
    sigmaC = 0.001;%fixed
    [mu_saliency,sigma_saliency,beta_saliency,VSMap]=fetchSaliencyFeature(disimg,sigmaF,omega0,sigmaD,sigmaC);
    feature_saliency=[mu_saliency,beta_saliency];   
    %% 梯度特征
    [ave_grad std_grad grad_map1]=fetchGradient(disimg_gray);
    grad_fea=[ave_grad std_grad]; % 6项
    %% 颜色空间转化：RGB->LMN
    L = 0.06 * double(disimg(:,:,1)) + 0.63 * double(disimg(:,:,2)) + 0.27 * double(disimg(:,:,3));
    M = 0.30 * double(disimg(:,:,1)) + 0.04 * double(disimg(:,:,2)) - 0.35 * double(disimg(:,:,3));
    N = 0.34 * double(disimg(:,:,1)) - 0.60 * double(disimg(:,:,2)) + 0.17 * double(disimg(:,:,3));
    window = fspecial('gaussian', 7, 1.5);
    window = window/sum(sum(window));  
    mu_L_map=filter2(window,L,'same');
    mu_M_map=filter2(window,M,'same');
    mu_N_map=filter2(window,L,'same');
    mu_L=mean2(mu_L_map);
    mu_M=mean2(mu_M_map);
    mu_N=mean2(mu_N_map);
    std_L=std2(mu_L_map);
    std_M=std2(mu_M_map);
    std_N=std2(mu_N_map);
    feature_base=[mu_L,std_L,mu_M,std_M,mu_N,std_N];% 6项
    %% MN分量的统计特征
    [M_alpha M_overallstd M_skewness M_kurtosis M_entropy]=fetchNSSFea(M);
    [N_alpha N_overallstd N_skewness N_kurtosis N_entropy]=fetchNSSFea(N);
    fea_MN=[M_alpha M_overallstd M_skewness M_kurtosis M_entropy N_alpha N_overallstd N_skewness N_kurtosis N_entropy];
    %% 颜色空间转化：RGB-> HVS
%     img_hsv=rgb2hsv(disimg);
%     H=double(img_hsv(:,:,1));
%     S=double(img_hsv(:,:,2));
%     V=double(img_hsv(:,:,3));
%     
%     window = fspecial('gaussian', 11, 1.5);
%     window = window/sum(sum(window));  
%     mu_H_map=filter2(window,H,'same');
%     mu_S_map=filter2(window,S,'same');
%     mu_V_map=filter2(window,V,'same');
% %     mu_H_sq_map=mu_H_map.*mu_H_map;
% %     mu_S_sq_map=mu_H_map.*mu_S_map;
% %     mu_V_sq_map=mu_H_map.*mu_V_map;
% %     sigma_H_sq_map=filter2(window, H.*H, 'same') - mu_H_sq_map;
% %     sigma_S_sq_map=filter2(window, S.*S, 'same') - mu_S_sq_map;
% %     sigma_V_sq_map=filter2(window, V.*V, 'same') - mu_V_sq_map;
% %     alpha=0.001;
% %     C_H=alpha*max(H(:));
% %     C_S=alpha*max(S(:));
% %     C_V=alpha*max(V(:));
% %     H_norm_map=(H-mu_H_map)./(sqrt(sigma_H_sq_map)+C_H);
% %     S_norm_map=(S-mu_S_map)./(sqrt(sigma_S_sq_map)+C_S);
% %     V_norm_map=(V-mu_V_map)./(sqrt(sigma_V_sq_map)+C_V);
%     mu_H=mean2(mu_H_map);
%     mu_S=mean2(mu_S_map);
%     mu_V=mean2(mu_V_map);
%     std_H=std2(mu_H_map);
%     std_S=std2(mu_S_map);
%     std_V=std2(mu_V_map);
% %     mu_H=mean2(H);
% %     temp=(H-mu_H).^2;
% %     sigma_H=mean(temp(:));
% %     mu_S=mean2(S);
% %     temp=(S-mu_S).^2;
% %     sigma_S=mean(temp(:));
% %     mu_V=mean2(V);
% %     temp=(V-mu_V).^2;
% %     sigma_V=mean(temp(:));
% %     feature_base=[mu_H,sigma_H,mu_S,sigma_S,mu_V,sigma_V];% 6项
%     feature_base=[mu_H,std_H,mu_S,std_S,mu_V,std_V];% 6项
    %% FISH特征
    fish_fea=fetch_fish(disimg_gray);% 1项
    %% MLV特征（描述sharpness）
    mlv_fea=MLVSharpnessMeasure(disimg_gray);
    %% sharpness 特征
    sharpness_fea=[mlv_fea fish_fea grad_fea]; % 9项
%     sharpness_fea=[mlv_fea grad_fea]; % 8项
    %% NSS特征
    [nss_alpha ,nss_overallstd, nss_skewness, nss_kurtosis ,nss_entropy]=fetchNSSFea(disimg_gray);
    feature_nss=[nss_alpha nss_overallstd nss_skewness nss_kurtosis nss_entropy]; % 5项
%     %% 斜度特征
%     skewness_fea=skewness(disimg_gray(:));
%     %% 峰度特征
%     kurtosis_fea=kurtosis(disimg_gray(:));
%     %% 信息熵特征
%     entropy_fea=entropy(disimg_gray);
    %% 特征向量
    % 基本特征6 MN颜色特征10项 NSS特征5   sharpness特征9项  显著性特征2 
    feature=[feature feature_base fea_MN feature_nss sharpness_fea  feature_saliency];
    
    disimg=imresize(disimg,0.5);
end