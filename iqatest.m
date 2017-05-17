clear;
clc;
DataBase=[6];    %1,LIVE;2,CSIQ;3,TID2008;4,MDIQ;5,TID2013;6,CID2013;7,MDID;
                                         
%CID2013
pathd=cell(1,6);
pathd(1)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS1\'};
pathd(2)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS2\'};
pathd(3)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS3\'};
pathd(4)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS4\'};
pathd(5)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS5\'};
pathd(6)={'E:\Study Files\Scientific Research\IQA\Datasets\CID2013\IS6\'};
filetype='*.jpg';
iqa=[];
%% 训练
% fea_mat=[];
% for i=1:6
%     pad=char(pathd(i));
%     dimg_path_list1=dir(pad);
%     len_list1=length(dimg_path_list1);
%     % dimg_path_list = dir(strcat(pad,filetype));
%     for ii=1:len_list1 
%         if(dimg_path_list1(ii).name(1)=='c')
%             pad2=strcat(pad,dimg_path_list1(ii).name,'\');
%             dimg_path_list2=dir(strcat(pad2,filetype));
%             len_list2=length(dimg_path_list2);
%             for j=1:len_list2
%                 disname=dimg_path_list2(j).name;
%                 disname=strcat(pad2,disname);
%                 disimg=imread(disname);
%     %                 figure,imshow(disimg);
%                 fea=fetchFeature(disimg);
%                 fea_mat=[fea_mat;fea];
% %                 mytest(disimg);
%                 % iqa=[iqa;iqaij];
%             end
%         end
%     end
% end
% path_excel='E:\Study Files\Scientific Research\IQA\Datasets\CID2013\CID2013 data - version 12112014.xlsx';
% [number,txt,raw]=xlsread(path_excel,'CID2013 MOS');
% img_mos=number(:,2);
% save mydata.mat fea_mat img_mos;
% my_mat=[fea_mat,img_mos]; % 最后一列为y
% save my_mat.mat my_mat;
load('my_mat.mat');
%% 标准化处理
mu_my=mean(my_mat);
sigma_my=mean((my_mat-repmat(mu_my,474,1)).^2);
my_mat=(my_mat-repmat(mu_my,474,1))./repmat((sigma_my.^0.5),474,1);
%% 交叉验证
cnt_groups=5;
cnt_train_groups=4;
[train_data,test_data]=crossValidation(my_mat,cnt_groups,cnt_train_groups);
%%
model=svmtrain(train_data(:,end),train_data(:,1:end-1),'-s 3 -t 2 -c 100 -g 10 -p 0.01'); % add -v 交叉验证，不输出模型值
[py,mse,decision]=svmpredict(test_data(:,end),test_data(:,1:end-1),model);
% pred_quality=py.*(sigma_my(:,end)^0.5)+mu_my(:,end);
%% 预测        
        
    

