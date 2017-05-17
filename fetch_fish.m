function [fish]=fetch_fish(img)
if(size(img,3)~=1)
    img=rgb2gray(img);
end
img=double(img);
%% Èý½×2D DWT±ä»»
alpha=0.8;
dwt_maps=cell(3,4);
[c,s]=wavedec2(img,3,'haar');
for i=1:3
    [dwt_maps{i,1},dwt_maps{i,2},dwt_maps{i,3}]=detcoef2('all',c,s,i);
    A = appcoef2(c,s,'haar',i);
%     dwt_maps{i,1}= wcodemat(H,255,'mat',1);
%     dwt_maps{i,2}= wcodemat(V,255,'mat',1);
%     dwt_maps{i,3}= wcodemat(D,255,'mat',1);
    dwt_maps{i,4}= wcodemat(A,255,'mat',1);
end
log_energy_arr=zeros(3,4);
for i=1:3
    for j=1:4
        N=length(dwt_maps{i,j}(:));
        tmp=dwt_maps{i,j}.^2;
        log_energy_arr(i,j)=log10(1+1/N*(sum(tmp(:))));
    end
end
E=(1-alpha)*(log_energy_arr(:,1)+log_energy_arr(:,2))/2+alpha*log_energy_arr(:,3);
fish=4*E(1)+2*E(2)+E(3);
end