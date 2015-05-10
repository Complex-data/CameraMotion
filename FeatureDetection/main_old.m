clc, clear

I = imread('0000000000.png');
Id = double(I)/255;


[m, n] = size(I);

w = 15;  % Window pixel width/height, always odd
wr = (w-1)/2;    %Range of pixels

x = 5;
y = 5;

Wx = [1, 0, -1; 2, 0, -2; 1, 0, -1];    % Derivative in x direction
Wy = [1, 2, 1; 0, 0, 0; -1, -2, -1];    % Derivative in y direction

Ix = conv2(Id, Wx);
Iy = conv2(Id, Wy);


%%
for x = wr+1:m-wr-1
    for y = wr+1:n-wr-1
        
%         Iw = I(x-wr:x+wr, y-wr:y+wr);   % Window image
        
        Ixw = Ix(x-wr:x+wr, y-wr:y+wr);   % Window image
        Iyw = Iy(x-wr:x+wr, y-wr:y+wr);   % Window image
        
        Ix2 = sum(sum(Ixw.^2));
        Ixy = sum(sum(Ixw.*Iyw));
        Iy2 = sum(sum(Iyw.^2));
        
        H = [Ix2, Ixy; Ixy, Iy2];
        C(x,y) = det(H) - trace(H);
        
    end
end

%%

ind = find(C > 30000);


figure(1)
clf
imshow(Id)
hold on

% x = index % Width;
% y = (index - x) / Width;

for i = 1:length(ind)
   
   
   x = mod(ind(i), n);
   y = round((ind(i)-x)/n);
   plot(x,y, 'bo');
    
end

%%
clf
hold on
imshow(Id)

plot(1, 1, 'bo');



