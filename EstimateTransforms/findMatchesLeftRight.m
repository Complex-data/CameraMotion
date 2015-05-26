function [ind, met] = findMatchesLeftRight(fl, fr, vpl, vpr, M, thr, uniq)
    % Assume that there are fewer features in f1. If this is not the case
    % than swap their roles
    s1 = length(fl);
    s2 = length(fr);
    
    swap = false;    
    if s2 == min(s1, s2)
        % Swap features
        temp = fr;
        fr = fl;
        fl = temp;
        % Swap valid points
        temp = vpr;
        vpr = vpl;
        vpl = temp;
        % Swap sizes
        temp = s2;
        s2 = s1;
        s1 = temp;
        % We swapped f1 and f2
        swap = true;
    end
    
    % Sort the valid points and features by the row coordinates
    [~, i1_rows] = sort(vpl(:, 2));
    vpl = vpl(i1_rows, :);
    fl = fl(i1_rows, :);
    [~, i2_rows] = sort(vpr(:, 2));
    vpr = vpr(i2_rows, :);
    fr = fr(i2_rows, :);
    
    ind = zeros(s1, 2, 'uint16');
    met = zeros(s1, 1);
    num = 0;
    
    l = 1;    
    for k = 1:s1
        lowest_sad = thr;
        increase = true;
        r1 = vpl(k, 2);
        % As long as we are too low it is not interesting. We are matching
        % left right, so the features should be epipolar. Give it a
        % possible error of plus/minus one pixel
        while l <= s2 && vpr(l, 2) < r1 - 1
            l = l + 1;
        end
        % Save this for later
        l_bak = l;
        
        % We found a feature marker at a row position higher than r1 - 1.
        % Let's see if it also not too high already
        while l <= s2 && vpr(l, 2) <= r1 + 1
            % Here comes the check if we didn't maybe wander off too far
            if abs(vpl(k, 1) - vpr(l, 1)) <= M
                % Let's do the feature matching
                temp_sad = sum(abs(fl(k, :) - fr(l, :)));
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
        met = met(1:num);
    end
    
%     % Do a sanity check and remove the matches with negative disparity
%     % (left u position lower than on the right)
%     ind2 = zeros(size(ind), 'uint16');
%     met2 = zeros(size(met));
%     num = 0;
%     if swap
%         for k = 1:length(ind)
%             if vpr(ind(k, 1), 1) >= vpl(ind(k, 2), 1)
%                 num = num + 1;
%                 ind2(num, :) = ind(k, :);
%                 met2(num) = met(k);
%             end
%         end
%     else
%         for k = 1:length(ind)
%             if vpl(ind(k, 1), 1) >= vpr(ind(k, 2), 1)
%                 num = num + 1;
%                 ind2(num, :) = ind(k, :);
%                 met2(num) = met(k);
%             end
%         end
%     end
%     ind = ind2(1:num, :);
%     met = met2(1:num);
       
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