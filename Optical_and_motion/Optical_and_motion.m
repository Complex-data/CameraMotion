% MATHWORKS example
%Set up objects.
videoReader = vision.VideoFileReader('viptraffic.avi','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');
%Convert the image to single precision, then compute optical flow for the video. Generate coordinate points and draw lines to indicate flow. Display results.

while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    of = step(opticalFlow, im);
    lines = videooptflowlines(of, 20);
    if ~isempty(lines)
        out =  step(shapeInserter, im, lines);
        step(videoPlayer, out);
    end
end
%Close the video reader and player

release(videoPlayer);
release(videoReader);

%% Motion
blockSize = 5;
img1 = im2double(imread('0000000000.png'));
img2 = im2double(imread('0000000001.png'));

hbm = vision.BlockMatcher('ReferenceFrameSource', 'Input port', 'BlockSize', [blockSize blockSize]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
halphablend = vision.AlphaBlender;

opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';

motion = step(hbm, img1, img2);

img12 = step(halphablend, img2, img1);

[X, Y] = meshgrid(1:blockSize:size(img1, 2), 1:blockSize:size(img1, 1));
imshow(img12); hold on;
quiver(X(:), Y(:), real(motion(:)), imag(motion(:)), 0); hold off;

%% Optical flow
clc, clear
img1 = im2double(imread('0000000000.png'));
img2 = im2double(imread('0000000001.png'));

opticalFlow = vision.OpticalFlow('ReferenceFrameSource', 'Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
V = step(opticalFlow, img1, img2);

[X, Y] = meshgrid(1:size(img1, 2), 1:size(img1, 1));
imshow(img1); hold on;
quiver(X(:), Y(:), real(V(:)), imag(V(:)), 0);
hold off;