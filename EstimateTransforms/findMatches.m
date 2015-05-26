function ind = findMatches(f1, f2, vp1, vp2, M, thr)
    % Assume that there are fewer features in f1. If this is not the case
    % than swap their roles
    s1 = length(f1);
    s2 = length(f2);
    
    swap = false;    
    if s2 == min(s1, s2)
        % Swap features
        temp = f2;
        f2 = f1;
        f1 = temp;
        % Swap valid points
        temp = vp2;
        vp2 = vp1;
        vp1 = temp;
        % Swap sizes
        temp = s2;
        s2 = s1;
        s1 = temp;
        % We swapped f1 and f2
        swap = true;
    end
    
    % Sort the valid points and features by the row coordinates
    [~, i1_rows] = sort(vp1(:, 2));
    vp1 = vp1(i1_rows, :);
    f1 = f1(i1_rows, :);
    [~, i2_rows] = sort(vp2(:, 2));
    vp2 = vp2(i2_rows, :);
    f2 = f2(i2_rows, :);
    
    ind = zeros(s1, 2, 'uint16');
    num = 0;
    
    for k = 1:s1
        lowest_sad = thr;
        increase = true;
        
        u = vp1(k, 1);
        v = vp1(k, 2);
        
        for l = 1:s2
            if vp2(l, 1) > u + M || vp2(l, 1) < u - M ...
                    || vp2(l, 2) > v + M || vp2(l, 2) < v - M
                continue;
            end
            
            temp_sad = sum(abs(f1(k, :) - f2(l, :)));
            if temp_sad < lowest_sad
                lowest_sad = temp_sad;
                
                % Are we here for the first time for this k?
                if increase
                    num = num + 1;
                    increase = false;
                end
                
                % Did we swap?
                if swap
                    ind(num, :) = [i2_rows(l), i1_rows(k)];
                else
                    ind(num, :) = [i1_rows(k), i2_rows(l)];
                end
            end
        end
        
        % Resize the results to the actual number of outcomes
        if num == 0
            ind = [];
        else
            ind = ind(1:num, :);
        end
    end
end