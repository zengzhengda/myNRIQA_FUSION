function [fish_bb]=fetch_fish_bb(img)
if(ndims(img)==3)
    img=rgb2gray(img);
end
%% 计算局部fish
[M,N]=size(img);
size_blk=64; % 块的尺寸
gap=32; % 块之间的间隔大小
fish_map=[];
for row=1:gap:(floor(M/gap)-2)*gap
    for col=1:gap:(floor(N/gap)-2)*gap
        img_blk=img(row:row+size_blk,col:col+size_blk);
        fish_loc=fetch_fish(img_blk);
        fish_map=[fish_map,fish_loc];
    end
end
fish_bb=sqrt(mean(fish_map.^2));
end
