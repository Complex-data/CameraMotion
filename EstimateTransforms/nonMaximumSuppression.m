function [ext, num] = nonMaximumSuppression(I1, I2, n, thr)
    % Efficient non maximum suppression as found in
    % https://www.vision.ee.ethz.ch/publications/papers/proceedings/eth_biwi_00446.pdf
    % with modification for minima from Andreas Geiger
    width = size(I1, 2);
    height = size(I1, 1);
    
    % n = 2; % Minimum distance between maxima / minima
    
    margin = 6;
    if margin < 0
        margin = 0;
    end

    % Preallocate for maximum number of extrema
    ext = zeros(floor(width*height / (2*n + 1)^2), 4, 'int16');
    % Variable to count the number of extrema
    num = 0;

    for i = (n + 1 + margin):(n + 1):(width - n - margin)
        for j = (n + 1 + margin):(n + 1):(height - n - margin)
            [val, ind_row] = max(I1(j:(j + n), i:(i + n)));
            [I1max_val, ind_col] = max(val);

            I1max_mj = ind_row(ind_col) + j - 1;
            I1max_mi = ind_col + i - 1;
            
            [val, ind_row] = max(I2(j:(j + n), i:(i + n)));
            [I2max_val, ind_col] = max(val);
            
            I2max_mj = ind_row(ind_col) + j - 1;
            I2max_mi = ind_col + i - 1;
            
            [val, ind_row] = min(I1(j:(j + n), i:(i + n)));
            [I1min_val, ind_col] = min(val);

            I1min_mj = ind_row(ind_col) + j - 1;
            I1min_mi = ind_col + i - 1;
            
            [val, ind_row] = min(I2(j:(j + n), i:(i + n)));
            [I2min_val, ind_col] = min(val);
            
            I2min_mj = ind_row(ind_col) + j - 1;
            I2min_mi = ind_col + i - 1;

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