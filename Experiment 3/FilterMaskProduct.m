%%用于产生空间滤波模板
clc
clear
close all
%Input = [];
type = [];
Input = InputPicture();
Input = rgb2gray(Input);
Input = double(Input);
m = 3;
n = 3;
[length,width] = size(Input);
Output = zeros(length,width);

% parpool('local',4); 
switch type
  case 'average' % Smoothing filter
     mask   = ones(siz)/prod(siz);
     Output = conv2(Input,mask,'same');
  case 'gaussian' % Gaussian filter

     siz   = [3 3];
     std   = 1;
     
     [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
     arg   = -(x.*x + y.*y)/(2*std*std);

     mask  = exp(arg);
     mask  = mask/sum(sum(mask));
     Output = conv2(Input,mask,'same');
   case 'laplacian' % Laplacian filter
     alpha = p2;
     alpha = max(0,min(alpha,1));
     h1    = alpha/(alpha+1); h2 = (1-alpha)/(alpha+1);
     h     = [h1 h2 h1;h2 -4/(alpha+1) h2;h1 h2 h1];
   case 'sobel' % Sobel filter
     mask = [1 2 1;0 0 0;-1 -2 -1];
end
%% 
%%均值滤波
mask = ones(m,n)/(m*n);
%mask = 1/16 * [1 2 1;2 4 2;1 2 1];
out = imfilter(Input,mask,'conv','replicate');
figure
out = uint8(out);
imshow(out)

tic

  
Output = conv2(Input,mask,'same');
        
% for i = 2:length-1;
%     for j = 2:width-1;
%         %OutputTemp = conv2(Input(i,j),mask);%求卷积
%         Output(i,j) = sum(sum(Input((i-1:i+1),(j-1:j+1)).* mask));
%     end
% end
toc
Output = uint8(Output);
figure
imshow(Output)

%% 
%%中值滤波
%

mask = zeros(m,n);
out = medfilt2(Input,[3 3]);
figure
out = uint8(out);
imshow(out)
for i = 2:length-1;
    for j = 2:width-1;
        mask = Input((i-1:i+1),(j-1:j+1));
        maskTemp(1,:) = mask(:);%median返回值的原因需要将mask转为一行
        Output(i,j) = median(maskTemp);%求中值
    end
end
figure
Output = uint8(Output);
imshow(Output)
%delete(gcp('nocreate'));