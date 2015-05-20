%% Loop through images and save Harris vectors to save time for later
clc, clear

k = 1;

load('Left_1_300.mat');
load('Left_301_1000.mat');
load('Left_1001_1033.mat');

load('Right_1_1033.mat');



IL1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
IL2 = imread(['../ImageData/LeftData/', indexToImageName(k+1)]);

for k = 1:400

    IR1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
    IR2 = imread(['../ImageData/RightData/', indexToImageName(k+1)]);

    % mp1 = Left_1_300.matched1{k};
    % mp2 = Left_1_300.matched2{k};

    mp1 = Right_1_1033.matched1{k};
    mp2 = Right_1_1033.matched2{k};

    % showMatchedFeatures(IL1, IL2, mp1, mp2);
    showMatchedFeatures(IR1, IR2, mp1, mp2);

end



%%

clc

I1 = imread(['../ImageData/LeftData/', indexToImageName(1)]);

mQ = 0.0001;
filt = 3;
ROI = [128 1 size(I1,2)-128*2 size(I1,1)];


for k = 1:1033
    k
%     IL1 = imread(['../ImageData/LeftData/', indexToImageName(k)]);
%     IL2 = imread(['../ImageData/LeftData/', indexToImageName(k+1)]);

    IR1 = imread(['../ImageData/RightData/', indexToImageName(k)]);
    IR2 = imread(['../ImageData/RightData/', indexToImageName(k+1)]);
%     [~, ~, ~, ~, ~, ~, Lmp1, Lmp2] = returnHarrisVectors(IL1, IL2, mQ, filt, ROI);
    
%     Left.matched1{k} = Lmp1;
%     Left.matched2{k} = Lmp2;
    
    [~, ~, ~, ~, ~, ~, Rmp1, Rmp2] = returnHarrisVectors(IR1, IR2, mQ, filt, ROI);
    
    Right.matched1{k} = Rmp1;
    Right.matched2{k} = Rmp2;
    
end
