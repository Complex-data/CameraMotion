%% Loop through images and save Harris vectors to save time for later
clc, clear, close all

k = 1;

load('Left_1_300.mat');
load('Left_301_1000.mat');
load('Left_1001_1033.mat');

load('Right_1_1033.mat');

x = 0;
y = 0;
x_prev = 0;
y_prev = 0;
r2 = 0;
IL1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
IL2 = imread(['../ImageData/LeftData/', indexToImageName(k+1)]);

for k = 1:1000

    IR1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
    IR2 = imread(['../ImageData/RightData/', indexToImageName(k+1)]);

    % mp1 = Left_1_300.matched1{k};
    % mp2 = Left_1_300.matched2{k};

    mp1 = Right_1_1033.matched1{k};
    mp2 = Right_1_1033.matched2{k};
    

    u = mp2.Location(:, 1)-mp1.Location(:, 1);
    v = mp2.Location(:, 2)-mp1.Location(:, 2);
    
    r = mean(u);
    
    u_noRotation = u-r;
    
    v = mean(sqrt(u_noRotation.^2+v.^2));
%     V(k) = v;
%     R(k) = r;
    r2 = r2 + r;
    
    theta = r2*1.8*pi/3000;
    h = 0.01;
    
    x = x + v*h*cos(theta);
    y = y + v*h*sin(theta);
    figure(1)
    hold on
    plot([x_prev, x], [y_prev, y])
    plot(x, y, 'ro')
%     axis([0, 45, -35, 5])
    
    x_prev = x;
    y_prev = y;
    
    
    figure(2)
    hold off
    showMatchedFeatures(IR1, IR2, mp1, mp2);
    pause(0.01)
end



%%
% 
% clc
% 
% I1 = imread(['../ImageData/LeftData/', indexToImageName(1)]);
% 
% mQ = 0.0001;
% filt = 3;
% ROI = [128 1 size(I1,2)-128*2 size(I1,1)];
% 
% 
% for k = 1:1033
%     k
% %     IL1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
% %     IL2 = imread(['../ImageData/LeftData/', indexToImageName(k+1)]);
% 
%     IR1 = imread(['../ImageData/RightData/', indexToImageName(k)]);
%     IR2 = imread(['../ImageData/RightData/', indexToImageName(k+1)]);
% %     [~, ~, ~, ~, ~, ~, Lmp1, Lmp2] = returnHarrisVectors(IL1, IL2, mQ, filt, ROI);
%     
% %     Left.matched1{k} = Lmp1;
% %     Left.matched2{k} = Lmp2;
%     
%     [~, ~, ~, ~, ~, ~, Rmp1, Rmp2] = returnHarrisVectors(IR1, IR2, mQ, filt, ROI);
%     
%     Right.matched1{k} = Rmp1;
%     Right.matched2{k} = Rmp2;
%     
% end
