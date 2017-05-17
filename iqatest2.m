clear ;
clc;
close all;
warning('off'); % 不显示warning
                    
% 选择数据库
dataset_names={'CID2013','LIVE','TID2013'};
dataset_name=dataset_names{1};% 选择数据库
% load best_svr_param_tid2013;

%% 特征提取   
% fetchFeatureAll(dataset_name);
%% 性能评价
load(['my_mat_' lower(dataset_name)]);
% 去除参考图像
%  load('..\Datasets\LIVE\dmos_realigned.mat');
%  orgs2=orgs(1:end-174);
% inx=find(orgs2==1);
%  my_mat(inx,:)=[];
%% 特征选择
my_mat=[my_mat(:,1) my_mat(:,25:31) my_mat(:,56:62) my_mat(:,end)]; % mn+nss
%% 去除不合适的数据
my_mat(404,:)=[];
cnt_data=size(my_mat,1);
%% 标准化处理 可以改进
mu_my=mean(my_mat(:,2:end));
sigma2_my=mean((my_mat(:,2:end)-repmat(mu_my,cnt_data,1)).^2);
my_mat=[my_mat(:,1),(my_mat(:,2:end)-repmat(mu_my,cnt_data,1))./repmat((sigma2_my.^0.5),cnt_data,1)];
%% 交叉验证
cnt_cross=1000;% 交叉验证次数
CC=zeros(1,cnt_cross);
SROCC=zeros(1,cnt_cross);
RMSE=zeros(1,cnt_cross);
isBestParam=0;% 标识符，是否为svm最优参数
isShow=1;  % 是否显示结果对比图
for ii=1:cnt_cross
    cnt_groups=10;
    cnt_train_groups=8;
    start=2; % 特征起点
    end2=1; % 特征终点
    [train_data,test_data]=crossValidation(my_mat,cnt_groups,cnt_train_groups);
    %% svr模型训练
    % 如果参数不是最优，则选择最优参数
    if(isBestParam==0)
        [best_C,best_gamma]=SVR_choosing_paremeter(train_data(:,start:end-end2),train_data(:,end),dataset_name);
        isBestParam=1;
    end
    model=svmtrain(train_data(:,end),train_data(:,start:end-end2),sprintf('-s %f -t %f -c %f -g %f', 3, 2, best_C, best_gamma)); % add -v 交叉验证，不输出模型值
    %% 训练集验证结果
    [train_quality_norm,train_mse,train_decision]=svmpredict(train_data(:,end),train_data(:,start:end-end2),model);
    train_quality=train_quality_norm.*(sigma2_my(:,end)^0.5)+mu_my(:,end);
    train_mos=train_data(:,end).*(sigma2_my(:,end)^0.5)+mu_my(:,end);
    %% 聚类算法再精化
%     trainOfCluter(train_data(:,1),train_quality);
    
    %% svr 预测
    [test_quality_norm,test_mse,test_decision]=svmpredict(test_data(:,end),test_data(:,start:end-end2),model);
    test_quality=test_quality_norm.*(sigma2_my(:,end)^0.5)+mu_my(:,end);
    test_mos=test_data(:,end).*(sigma2_my(:,end)^0.5)+mu_my(:,end);
    %% 性能评估
    [CC(ii),SROCC(ii),RMSE(ii)]=performance_eval(test_quality,test_mos,isShow);
    isShow=0;
end
mu_CC=mean(CC)
mu_SROCC=mean(SROCC)
mu_RMSE=mean(RMSE)
    