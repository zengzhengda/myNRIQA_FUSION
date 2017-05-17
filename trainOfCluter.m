function []=trainOfCluter(img_ind,train_quality)
%% 按照train_quality 对图像集分类
cnt_train=length(train_quality);
level_vec=zeros(cnt_train,1); %  分成10级
for i=1:cnt_train
    level_vec(i)=ceil(train_quality(i)/10);
end
img_info=[img_ind,level_vec];

end
