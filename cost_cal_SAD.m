% calculate the Sum of Absolute Difference (MAD) for the given two blocks
% curBlk : the first block, usually stands for the macro block
% refBlk : the second block, usually stands for current reference block
% blkSize : block size
% cost : The SAD value for the two blocks

function [cost] = cost_cal_SAD(curBlk,refBlk,blkSize) 
    diff = 0;  
    % blkSize = size(curBlk,1);
    for u = 1:blkSize
        for v = 1:blkSize
            diff = diff + abs(curBlk(u,v)-refBlk(u,v)); 
        end
    end
    cost = diff;
end