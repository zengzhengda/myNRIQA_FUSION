
function [mlv_fea,sharpnessScore, map] =MLVSharpnessMeasure(x)

T=1000;
alpha=-0.01;
x=double(x);
x(:)=x(:)/255; 

if(size(x,3)~=1)
    x=rgb2gray(x);
end

[map] = MLVMap(x);

[xs ys]=size(map);
xy_number=xs*ys;
l_number=round(xy_number);
vec = reshape(map,1,xy_number);
vec=sort(vec,'descend');
svec=vec(1:l_number);

a=(1:xy_number);
q=exp(alpha*a);
svec=svec.*q;
svec=svec(1:T);
[gamparam sigma] = estimateggdparam(svec);
sharpnessScore=sigma;   
mlv_fea=[sigma gamparam];
end %function

