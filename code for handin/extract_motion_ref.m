% extract the ego motion from this reference implemenation

% for this file to work you need to download libviso2 from
% http://www.cvlibs.net/software/libviso/ and compile the
% Matlab mex extensions.

disp('===========================');
clear all; close all; dbstop error;

% parameter settings
% folder containing the image data. It contains to folders, one containing
% the images from the left camera and one containing the images from the
% right camera
img_dir     = 'C:\Users\Felix\Documents\Image Analysis and Spatial Statistics\CameraMotion\ImageData';
param.f     = 645.2;
param.cu    = 635.9;
param.cv    = 194.1;
param.base  = 0.571;
first_frame = 0;
last_frame  = 1033;

% init visual odometry
visualOdometryStereoMex('init',param);

% init transformation matrix array
Tr_total = cell(last_frame - first_frame + 1, 1);
Tr_total{1} = eye(4);

x = zeros(1, 1034);
y = zeros(1, 1034);

% for all frames do
for frame=first_frame:last_frame
  % 1-index
  k = frame-first_frame+1;
  
  % read current images
  I1 = imread([img_dir '\LeftData\' num2str(frame,'%06d') '.png']);
  I2 = imread([img_dir '\RightData\' num2str(frame,'%06d') '.png']);

  % compute and accumulate egomotion
  Tr = visualOdometryStereoMex('process',I1,I2);
  if k>1
    Tr_total{k} = Tr_total{k-1}*inv(Tr);
  end

  x(k) = Tr_total{k}(1, 4);
  y(k) = Tr_total{k}(3, 4);
end

% release visual odometry
visualOdometryStereoMex('close');

save('reference_motion.mat', 'x', 'y')
