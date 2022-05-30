% finds the indices of the cell which holds the minimum cost
% costMat : matrix that contains the estimation costs for a block
% deltaX : the motion vector component in row
% deltaY : the motion vector component in col
% minVal : the minimum value in the cost matrix

function [deltaX, deltaY, minVal] = min_cost_search(costMat)
    %[row, col] = size(costMat,1);
    
    minVal = costMat(1,1);
    deltaX=1;
    deltaY=1;

    for u = 1:size(costMat,1)
        for v = 1:size(costMat,2)        
            if costMat(u,v) < minVal
                minVal = costMat(u,v);
                deltaX = u;
                deltaY = v;
            end
        end
    end
end

