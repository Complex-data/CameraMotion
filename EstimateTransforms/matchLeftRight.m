function [ind, met] = matchLeftRight(f1, f2, vp1, vp2, M, thr)
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
    met = zeros(s1, 1);
    num = 0;
    
    l = 1;    
    for k = 1:s1
        lowest_sad = thr;
        increase = true;
        r1 = vp1(k, 2);
        % As long as we are too low it is not interesting. We are matching
        % left right, so the features should be epipolar. Give it a
        % possible error of plus/minus one pixel
        while l <= s2 && vp2(l, 2) < r1 - 1
            l = l + 1;
        end
        % Save this for later
        l_bak = l;
        
        % We found a feature marker at a row position higher than r1 - 1.
        % Let's see if it also not too high already
        while l <= s2 && vp2(l, 2) <= r1 + 1
            % Here comes the check if we didn't maybe wander off too far
            if abs(vp1(k, 1) - vp2(l, 1)) <= M
                % Let's do the feature matching
                temp_sad = sum(abs(f1(k, :) - f2(l, :)));
                if temp_sad < lowest_sad 
                    % We found a match
                    lowest_sad = temp_sad;
                    
                    % Is this the first time we come here for this k?
                    if increase == true
                        num = num + 1;
                        increase = false;
                    end
                    
                    % Did we swap f1 and f2?
                    if swap == true
                        ind(num, :) = [i2_rows(l), i1_rows(k)];
                    else
                        ind(num, :) = [i1_rows(k), i2_rows(l)];
                    end
                    
                    % Save the metric
                    met(num) = lowest_sad;
                end
            end
            
            l = l + 1;
        end
        
        % Now we reached a value above r1 + 1. Since the next feature could
        % again have v position r1 we will go back to l_bak. The first time
        % that the v positions in vp2 were greater or equal to r1 - 1.
        l = l_bak;
    end    
    
    % Resize ind
    if num == 0
        ind = [];
        met = [];
    else
        ind = ind(1:num, :);
        met = met(1:num, :);
    end
end