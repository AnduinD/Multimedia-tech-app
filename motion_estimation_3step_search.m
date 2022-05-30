% calculate motion vectors using 3 step method
% imgCur : the image need to be coded
% imgRef : the reference image
% blkSiz : size of macro blocks
% w : the search range or step for current coding method to estimate motion vectors 
% motion_vector_matrix : the motion vectors for each macro block in imgCur

function [motion_vector_matrix] = motion_estimation_3step_search(imgCur, imgRef, blkSiz, w)
    [row, col] = size(imgRef);
    motVecMat = zeros(row/blkSiz,col/blkSiz,2);

    for u = 1 : blkSiz : row-blkSiz+1
        for v = 1 : blkSiz : col-blkSiz+1
            % 外面两层对macro block做迭代
            % 里面两层在当前macro block 内迭代
        wCur = w; %用来对步长做迭代的
        uCur = u; %用来对当前九点中心做迭代的（用这个值的自身替换，而不是递归）
        vCur = v; %用来对当前九点中心做迭代的（用这个值的自身替换，而不是递归）
        while(wCur>1)
            wCur = fix(wCur/2);% 步长减半
            costMat = ones(3)*Inf();% 对于当前九个点的损失矩阵
            refBlkX = uCur + wCur*[-1,0,1]; %定位参考块的左上角坐标
            refBlkY = vCur + wCur*[-1,0,1]; %定位参考块的左上角坐标
            for m = 1:3
                for n = 1:3
                    if (   refBlkX(m) < 1 || refBlkX(m)+blkSiz-1 > row ...
                        || refBlkY(n) < 1 || refBlkY(n)+blkSiz-1 > col)
                        continue;  % 忽略边角越界的参考帧
                    end

                    costMat(m,n) = ...
                        cost_cal_SAD(imgCur(u:u+blkSiz-1,v:v+blkSiz-1), ...
                                     imgRef(refBlkX(m):refBlkX(m)+blkSiz-1,...
                                            refBlkY(n):refBlkY(n)+blkSiz-1),...
                                     blkSiz);% 计算SAD矩阵中的一个元素值
                end
            end
            % 对当前的SAD矩阵查找九点中的谷点位置
            [localX,localY,minVal] = min_cost_search(costMat);
            uCur = refBlkX(localX);
            vCur = refBlkY(localY);
        end         

            % 根据最终的谷点，计算运动向量
            deltaX = uCur-u;
            deltaY = vCur-v;
            
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
    figure(10);quiver(X,Y,U,V);ylim([1,row/blkSiz]);xlim([1,col/blkSiz]);title("motion vector matrix (3 step method)");

    motion_vector_matrix = motVecMat;% 参数带回去
end  