function [train_data,test_data]=crossValidation(my_data,cnt_groups,cnt_train_groups)
[cnt_data,len_fea]=size(my_data);
cnt_per_group=floor(cnt_data/cnt_groups);% 每组的数据量
i=0;
% 增加一列图像标号


for i=1:cnt_groups-1
    rng('shuffle')
    rand_indexs=randperm(cnt_data-cnt_per_group*(i-1),cnt_per_group);
    data_of_group{i}=my_data(rand_indexs,:);
    my_data(rand_indexs,:)=[];
end
data_of_group{i+1}=my_data;

train_data=cell2mat(data_of_group(1:cnt_train_groups)');
test_data=cell2mat(data_of_group(cnt_train_groups+1:cnt_groups)');