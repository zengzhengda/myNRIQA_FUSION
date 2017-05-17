%% 选择数据库，提取数据特征
function fetchFeatureAll(dataset_name)

cnt_img_level=2;% 图像的层级

if(strcmp(dataset_name,'CID2013'))
    fetchFeatureAll_CID2013(cnt_img_level);
elseif(strcmp(dataset_name,'LIVE'))
    fetchFeatureAll_LIVE(cnt_img_level);
elseif(strcmp(dataset_name,'TID2013'))
    fetchFeatureAll_TID2013(cnt_img_level);
end
end

%% 提取CID2013数据集的特征
function [my_mat]=fetchFeatureAll_CID2013(cnt_img_level)
pathd=cell(1,6);
pathd(1)={'..\Datasets\CID2013\IS1\'};
pathd(2)={'..\Datasets\CID2013\IS2\'};
pathd(3)={'..\Datasets\CID2013\IS3\'};
pathd(4)={'..\Datasets\CID2013\IS4\'};
pathd(5)={'..\Datasets\CID2013\IS5\'};
pathd(6)={'..\Datasets\CID2013\IS6\'};
filetype='*.jpg';
% fid=fopen('..\Datasets\CID2013\img_name.txt','w');

len_imgs=474;
ori_img_dataset=cell(1,len_imgs);
fea_mat=[];
cnt_img=1; % 图像计数
% 主观数据集
path_excel='..\Datasets\CID2013\CID2013 data - version 12112014.xlsx';
[number,txt,raw]=xlsread(path_excel,'CID2013 MOS');
img_mos=number(:,3);

for i=1:6
    i
    pad=char(pathd(i));
    dimg_path_list1=dir(pad);
    len_list1=length(dimg_path_list1);
    % dimg_path_list = dir(strcat(pad,filetype));
    for ii=1:len_list1 
        if(dimg_path_list1(ii).name(1)=='c')
            pad2=strcat(pad,dimg_path_list1(ii).name,'\');
            dimg_path_list2=dir(strcat(pad2,filetype));
            len_list2=length(dimg_path_list2);
            for j=1:len_list2
                disname=dimg_path_list2(j).name;       
                %% 记录图像id
%                 if(j~=len_list2)
%                     fprintf(fid,'%s  ',disname);
%                 else
%                     fprintf(fid,'%s\n',disname);
%                 end         
                disname_all=strcat(pad2,disname);
                disimg=imread(disname_all);   
                %% 重新保存整理图像
%                 img_gray=rgb2gray(disimg);
%                 path_gray=strcat('..\Datasets\CID2013_gray\',disname(1:end-4),'_',num2str(img_mos(cnt_img)),'.jpg');
%                 path_color=strcat('..\Datasets\CID2013_color\',disname(1:end-4),'_',num2str(img_mos(cnt_img)),'.jpg');
%                 imwrite(img_gray,path_gray);
%                 imwrite(disimg,path_color);
                %%
                ori_img_dataset{cnt_img}=disimg;
                cnt_img=cnt_img+1;
                fea=fetchFeature3(disimg,cnt_img_level);
                fea_mat=[fea_mat;fea];               

            end
         end
    end
end
% fclose(fid);
img_ind=(1:len_imgs)';
my_mat=[img_ind,fea_mat,img_mos]; % 最后一列为y
save my_mat_cid2013.mat my_mat;   
% save ori_img_dataset.mat ori_img_dataset;
end

%% 提取LIVE数据集的特征
function [my_mat]=fetchFeatureAll_LIVE(cnt_img_level)
 load('..\Datasets\LIVE\refnames_all.mat');
 %refnames_all{i} is the name of the reference image for image i whose dmos value is given by dmos(i).
 load('..\Datasets\LIVE\dmos_realigned.mat');%dmos and orgs. orgs(i)==0 for distorted images.
 %dmos=[dmos_jpeg2000(1:227) dmos_jpeg(1:233) white_noise(1:174) gaussian_blur(1:174) fast_fading(1:174)]
 
pathr='..\Datasets\LIVE\refimgs\';
pathd=cell(1,5);
pathd(1)={'..\Datasets\LIVE\jp2k\'};
pathd(2)={'..\Datasets\LIVE\jpeg\'};
pathd(3)={'..\Datasets\LIVE\wn\'};
pathd(4)={'..\Datasets\LIVE\gblur\'};
pathd(5)={'..\Datasets\LIVE\fastfading\'};

imgn=[227,233,174,174,174];
delta=[0,227,460,634,808];

fea_mat=[];
cnt_img=1; % 图像计数

len_imgs=982;

for j=1:5
    simgn=imgn(j);
    pad=char(pathd(j));
%     delt=delta(j);
  for i=1:simgn
    disname=strcat(pad,'img');
    disname=strcat(disname,num2str(i));
    disname=strcat(disname,'.bmp');
    % refimg=imread(char(refname));
    disimg=imread(disname);
    fea=fetchFeature(disimg,cnt_img_level);
    fea_mat=[fea_mat;fea];   
    
    cnt_img=cnt_img+1   % 记数
  end
end

img_ind=(1:len_imgs)';
my_mat=[img_ind,fea_mat,dmos_new']; % 最后一列为y
save my_mat_live.mat my_mat;   
% save ori_img_dataset.mat ori_img_dataset;
end

%% 提取TID2013的数据特征
function []=fetchFeatureAll_TID2013(cnt_img_level)
mos=load('..\Datasets\TID2013\mos.txt');
pathr='..\Datasets\TID2013\reference_images\I';
file_path='..\Datasets\TID2013\distorted_images\';
filetype='*.bmp'; 
txt_path_list = dir(strcat(file_path,filetype));

fea_mat=[];
cnt_img=0;
iqa=[];
len_imgs=3000;

for i=1:25
%     refname=strcat(pathr,num2name(i));
%     refname=strcat(refname,'.bmp');
%     refimg=imread(refname);
    for j=1:120
         cnt_img=cnt_img+1   % 记数
         
        txt_name = txt_path_list(120*i-120+j).name;
        disimg = imread(strcat(file_path,txt_name));
        fea=fetchFeature3(disimg,cnt_img_level);
        fea_mat=[fea_mat;fea];   
    end
end
img_ind=(1:len_imgs)';
my_mat=[img_ind,fea_mat,mos]; % 最后一列为y
save my_mat_tid2013.mat my_mat;  
end