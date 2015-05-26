function ext = nonMaximumSuppression(I1, I2, n, thr)
    % Efficient non maximum suppression as found in
    % https://www.vision.ee.ethz.ch/publications/papers/proceedings/eth_biwi_00446.pdf
    % with modification for minima from Andreas Geiger
    width = size(I1, 2);
    height = size(I1, 1);

    margin = 12;

    % Preallocate for maximum number of extrema
    ext = zeros(floor(width*height / (2*n + 1)^2), 4);
    % Variable to count the number of extrema
    num = 0;

    for i = (n + 1 + margin):(n + 1):(width - n - margin - 1)
        for j = (n + 1 + margin):(n + 1):(height - n - margin - 1)
            I1max_mi = i; I1max_mj = j; I2max_mi = i; I2max_mj = j;
            I1min_mi = i; I1min_mj = j; I2min_mi = i; I2min_mj = j;
            
            I1max_val = I1(j, i);
            I1min_val = I1max_val;
            I2max_val = I2(j, i);
            I2min_val = I2max_val;
            
            for i2 = i:(i + n)
                for j2 = j:(j + n)
                    cval = I1(j2, i2);
                    if cval < I1min_val
                        I1min_mi = i2;
                        I1min_mj = j2;
                        I1min_val = cval;
                    elseif cval > I1max_val
                        I1max_mi = i2;
                        I1max_mj = j2;
                        I1max_val = cval;
                    end
                    
                    cval = I2(j2, i2);
                    if cval < I2min_val
                        I2min_mi = i2;
                        I2min_mj = j2;
                        I2min_val = cval;
                    elseif cval > I2max_val
                        I2max_mi = i2;
                        I2max_mj = j2;
                        I2max_val = cval;
                    end
                end
            end

%             valid_ext = true;
%             i2 = I1max_mi - n;
%             imax = min([I1max_mi + n, width]);
%             while valid_ext && i2 <= imax
%                 for j2 = (I1max_mj - n):min([I1max_mj + n, height])
%                     cval = I1(j2, i2);
%                     if cval > I1max_val && ...
%                             (i2 < i || i2 > i + n || j2 < j || j2 > j + n)
%                         valid_ext = false;
%                         break;
%                     end
%                 end
%                 
%                 i2 = i2 + 1;
%             end
%             if valid_ext
%                 num = num + 1;
%                 ext(num, :) = [I1max_mi, I1max_mj, I1max_val, 0];
%             end
            
            val = max(I1((I1max_mj - n):min([I1max_mj + n, height]), ...
                            (I1max_mi - n):min([I1max_mi + n, width])));
            I1max_val2 = max(val);

            if I1max_val2 <= I1max_val && I2max_val >= thr
                num = num + 1;
                ext(num, :) = [ I1max_mi, I1max_mj, I1max_val, 0];
            end
            
            val = max(I2((I2max_mj - n):min([I2max_mj + n, height]), ...
                            (I2max_mi - n):min([I2max_mi + n, width])));
            I2max_val2 = max(val);

            if I2max_val2 <= I2max_val && I2max_val >= thr
                num = num + 1;
                ext(num, :) = [ I2max_mi, I2max_mj, I2max_val, 1];
            end
            
            val = min(I1((I1min_mj - n):min([I1min_mj + n, height]), ...
                            (I1min_mi - n):min([I1min_mi + n, width])));
            I1min_val2 = min(val);

            if I1min_val2 >= I1min_val && I1min_val <= -thr
                num = num + 1;
                ext(num, :) = [ I1min_mi, I1min_mj, I1min_val, 2];
            end
            
            val = min(I2((I2min_mj - n):min([I2min_mj + n, height]), ...
                            (I2min_mi - n):min([I2min_mi + n, width])));
            I2min_val2 = min(val);

            if I2min_val2 >= I2min_val && I2min_val <= -thr
                num = num + 1;
                ext(num, :) = [ I2min_mi, I2min_mj, I2min_val, 3];
            end
        end
    end
    
    % Resize the matrix to the actual size
    if num == 0
        ext = [];
    else
        ext = ext(1:num, :);
    end
end