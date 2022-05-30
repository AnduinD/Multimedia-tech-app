% calculate motion vectors using exhaustive search method
% imgCur : the image need to be coded
% imgRef : the reference image
% blkSiz : size of macro blocks
% w : the search range or step for current coding method to estimate motion vectors 
% motion_vector_matrix : the motion vectors for each macro block in imgCur

function [motion_vector_matrix] = motion_estimation_exhaustive_search(imgCur, imgRef, blkSiz, w)
    [row, col] = size(imgRef);
    motVecMat = zeros(row/blkSiz,col/blkSiz,2);

    for u = 1 : blkSiz : row-blkSiz+1
        for v = 1 : blkSiz : col-blkSiz+1
            % 外面两层对macro block做迭代
            % 里面两层在当前macro block 内迭代
            % 里面每遍历完可以得到motVecMat的一个元素值
            costMat = ones(2*w+1)*Inf() ; % 初始化对应于当前macro block的损失矩阵
            for m = -w : w        
                for n = -w : w
                    refBlkX = u + m; 
                    refBlkY = v + n; 
                    if (   refBlkX < 1 || refBlkX+blkSiz-1 > row ...
                        || refBlkY < 1 || refBlkY+blkSiz-1 > col)
                        continue;  % 忽略边角越界的参考帧
                    end

                    costMat(m+w+1,n+w+1) = ...
                        cost_cal_SAD(imgCur(u:u+blkSiz-1,v:v+blkSiz-1), ...
                                     imgRef(refBlkX:refBlkX+blkSiz-1,...
                                            refBlkY:refBlkY+blkSiz-1),...
                                     blkSiz);% 计算SAD矩阵中的一个元素值
                end
            end

            % 对当前的SAD矩阵查找最小值的位置
            [deltaX, deltaY, minVal] = min_cost_search(costMat);
            deltaX = deltaX-w-1;
            deltaY = deltaY-w-1;

            % 计算当前macro block的坐标
            blockX = (u-1)/blkSiz+1; 
            blockY = (v-1)/blkSiz+1;
            motVecMat(blockX,blockY,:) = [deltaX,deltaY]; % 记录当前macro block 的 motion vector
        end
    end
    
    % 画图 motion vector matrix
    [X,Y] = meshgrid(1:col/blkSiz,1:row/blkSiz);  % 不是很理解为啥meshgrid是行列反着建的
    U = motVecMat(:,:,1);
    V = motVecMat(:,:,2);    
    figure(1);quiver(X,Y,U,V);ylim([1,row/blkSiz]);xlim([1,col/blkSiz]);title("motion vector matrix (full search method)");

    motion_vector_matrix = motVecMat;% 参数带回去
end  