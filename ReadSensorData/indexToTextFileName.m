function name = indexToTextFileName(index)
%% Input the index of the image you want, 0-indexed

% '0000000000'
   

name = strcat('000000000', num2str(index), '.txt');

if index < 10
    name = strcat('000000000', num2str(index), '.txt');
elseif index >= 10 && index <= 99
    name = strcat('00000000', num2str(index), '.txt');
elseif index >= 100 && index <= 999
    name = strcat('0000000', num2str(index), '.txt');
elseif index >= 1000 && index <= 9999
    name = strcat('000000', num2str(index), '.txt');
end





end