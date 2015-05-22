clc; clear all; close all;

% This script extracts the features of the left or optionally the right
% images and uses only these for navigation. Resulting more or less in
% monocular egomotion reconstruction

% General feature matching parameters
minQ = 0.0001;
filtS = 3;
roi = [128 1 985 376];

% Create cell arrays to store the precalculated matches
% For the right monocular results
right.m2p = cell(1034, 1);
right.m2c = cell(1034, 1);

% For the left monocular results
left.m1p = cell(1034, 1);
left.m1c = cell(1034, 1);

tic
for k = 1:10
%     I1p = imread(['../ImageData/LeftData/', num2str(k - 1, '%.6d'), '.png']);
%     I1c = imread(['../ImageData/LeftData/', num2str(k, '%.6d'), '.png')]);
% 
%     [m1p, m1c] = returnHarrisMatches(I1p, I1c, minQ, filtS, roi);
% 
%     left.m1p{k} = m1p;
%     left.m1c{k} = m1c;

    I2p = imread(['../ImageData/RightData/', num2str(k - 1, '%.6d'), '.png']);
    I2c = imread(['../ImageData/RightData/', num2str(k, '%.6d'), '.png']);
   
    [m2p, m2c] = returnHarrisMatches(I2p, I2c, minQ, filtS, roi);
   
    right.m2p{k} = m2p;
    right.m2c{k} = m2c;
end
toc

save right
save left