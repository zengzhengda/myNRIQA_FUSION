function [img_dst]=imgPreDeal(img_ref)
% 对图像进行预处理

%% Ready data for processing
if( ndims( img_ref ) == 3 )
  img_ref = rgb2gray( img_ref );
end

%% Take to luminance domain using LUT
k= 0.02874;
LUT=0:1:255;
LUT=k.*LUT.^(2.2/3);
ref=LUT(img_ref+1);
[M,N]=size(ref);
%% ACCOUNT FOR CONTRAST SENSITIVITY
csf = make_csf( M, N, 32 )';
dst = real( ifft2( ifftshift( fftshift( fft2( ref ) ).* csf ) ) );
img_dst=dst;
end

%% ---------------------------------------------------------
function [res] = make_csf(x, y, nfreq)
[xplane,yplane]=meshgrid(-x/2+0.5:x/2-0.5, -y/2+0.5:y/2-0.5);	% generate mesh
plane=(xplane+1i*yplane)/y*2*nfreq;
radfreq=abs(plane);				% radial frequency

% We modify the radial frequency according to angle.
% w is a symmetry parameter that gives approx. 3 dB down along the
% diagonals.
w=0.7;
s=(1-w)/2*cos(4*angle(plane))+(1+w)/2;
radfreq=radfreq./s;

% Now generate the CSF
csf = 2.6*(0.0192+0.114*radfreq).*exp(-(0.114*radfreq).^1.1);
f=find( radfreq < 7.8909 ); csf(f)=0.9809+zeros(size(f));

res = csf;
end