% calculate motion compensated image using with the motion vector matrix given
% imgCur : the image need to be coded
% imgI : the reference image 
% motVecMat : the motion vectors matrix
% blkSiz : size of macro block
% residual_image : the motion compensated image

function [residual_image] = motion_compensation(imgCur,imgRef,motVecMat,blkSiz)
    [row,col] = size(imgRef);
    imgRes = zeros(size(imgCur));
    imgRef = double(imgRef);
    imgCur = double(imgCur);

    for u = 1:blkSiz:row-blkSiz+1
        for v = 1:blkSiz:col-blkSiz+1
            % 外面两层对macro block做迭代
            % 每遍历完可以得到残差图中的一小块residual block

            % 计算当前macro block的坐标
            blockX = (u-1)/blkSiz+1; 
            blockY = (v-1)/blkSiz+1;

            % 取出当前macro block的motion vector
            deltaX = motVecMat(blockX,blockY,1);
            deltaY = motVecMat(blockX,blockY,2);

            % 计算reference block的位置
            refBlkX = u+deltaX;%+w+1;
            refBlkY = v+deltaY;%+w+1;

            % 将reference block和当前的macro block做差值，得到residual block
            imgRes(u:u+blkSiz-1,v:v+blkSiz-1) = ...
                imgCur(u:u+blkSiz-1,v:v+blkSiz-1)...
                -imgRef(refBlkX:refBlkX+blkSiz-1,refBlkY:refBlkY+blkSiz-1);
        end
    end

    % 画图 residual image 
    figure(2);imshow(uint8((255+imgRes)/2));title("residual image");

    residual_image = imgRes;
end