function [ind, met] = findMatches(f1, f2, vp1, vp2, M, thr, uniq)
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
    
    ind = zeros(s1, 2);
    met = zeros(s1, 1);
    num = 0;
    
    for k = 1:s1
        lowest_sad = thr;
        increase = true;
        
        u = vp1(k, 1);
        v = vp1(k, 2);
        
        % Navigate into the region of interest
        l = 1;
        while l <= s2 && vp2(l, 2) < v - M
            l = l + 1;
        end
        
        lstart = l;
        
        while l <= s2 && vp2(l, 2) <= v + M
            l = l + 1;
        end
        
        if l == s2
            lend = s2;
        else
            lend = l - 1;
        end
        
        % We now know that all the v coordinates are in the interesting
        % region. Let's care about the u coordinates.
        
        vp = vp2(lstart:lend, :);
        
        s = length(vp);
        
        % If there are still positions which could be interesting we
        % continue with the u coordinates.
        if ~isempty(vp)
            [~, iCols] = sort(vp(:, 1));
            vp = vp(iCols, :);

            m = 1;
            while m <= s && vp(m, 1) < u - M
                m = m + 1;
            end
            
            % Now we really are in the interesting region
            while m <= s && vp(m, 1) <= u + M
                temp_sad = sum(abs(f1(k, :) - f2(lstart + iCols(m) - 1, :)));
                if temp_sad < lowest_sad
                    lowest_sad = temp_sad;

                    % Are we here for the first time for this k?
                    if increase
                        num = num + 1;
                        increase = false;
                    end

                    % Did we swap?
                    if swap
                        ind(num, :) = [i2_rows(lstart + iCols(m) - 1), i1_rows(k)];
                    else
                        ind(num, :) = [i1_rows(k), i2_rows(lstart + iCols(m) - 1)];
                    end

                    met(num) = lowest_sad;
                end
                
                m = m + 1;
            end
        end
    end
        
    % Resize the results to the actual number of outcomes
    if num == 0
        ind = [];
        met = [];
    else
        ind = ind(1:num, :);
        met = met(1:num, :);
    end
    
    % If it is wished for ensure that only unique matches show up
    if uniq
        if swap
            col = 1;
        else
            col = 2;
        end
        
        [~, ia, ~] = unique(ind(:, col));
        ind = ind(ia, :);
        met = met(ia, :);
    end
end