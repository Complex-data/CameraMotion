clc, clear variables

I1 = imread('0000000000.png');
I2 = imread('0000000001.png');
I3 = imread('0000000002.png');
I4 = imread('0000000003.png');
I5 = imread('0000000004.png');
I6 = imread('0000000005.png');
I7 = imread('0000000006.png');
I8 = imread('0000000007.png');
I9 = imread('0000000008.png');
I10 = imread('0000000009.png');
I11 = imread('0000000010.png');

[r, c] = size(I1);

I1 = I1(:, (c/2-r/2):(c/2+r/2-1));
I2 = I2(:, (c/2-r/2):(c/2+r/2-1));
I3 = I3(:, (c/2-r/2):(c/2+r/2-1));
I4 = I4(:, (c/2-r/2):(c/2+r/2-1));
I5 = I5(:, (c/2-r/2):(c/2+r/2-1));
I6 = I6(:, (c/2-r/2):(c/2+r/2-1));
I7 = I7(:, (c/2-r/2):(c/2+r/2-1));
I8 = I8(:, (c/2-r/2):(c/2+r/2-1));
I9 = I9(:, (c/2-r/2):(c/2+r/2-1));
I10 = I10(:, (c/2-r/2):(c/2+r/2-1));
I11 = I11(:, (c/2-r/2):(c/2+r/2-1));


[u, v] = HS(I1, I11);
%%
quiver(u, v)




%%

[r, c] = size(I1);

U = zeros(r,c);
V = zeros(r,c);

lambda = 0.4;

wx = [-1, 1; -1, 1];
wy = [-1, -1; 1, 1];
wt1 = ones(2);
wt2 = -ones(2);
wl = [0, -0.25, 0; -0.25, 1, -0.25; 0, -0.25, 0];

iter = 10;
u_av = 0;
v_av = 0;

for i = 10:10:(r-10)
    for j = 10:10:(c-10)
        for k = iter
            
            fx = ;
            fy = ;

            ft = ;

            u_av = ;
            v_av = ;


            P_D = (fx*u_av + fy*v_av + ft)/...
                  (lambda + fx^2 + fy^2);

            U(i,j) = u_av - fx*P_D;
            V(i,j) = v_av - fy*P_D;
        end
        
        u_av = 0;
        v_av = 0;
        
    end
end


% for k



% imshow(I1)



