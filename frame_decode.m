% decode current frame image with reference image, motion vector matrix and
% motion compensated image
% imgRef : the reference image 
% motVecMat : the motion vectors matrix
% imgRes : the motion compensated image
% blkSiz : Size of the macroblock
% decode_image : the output image which has been decoded

function [decode_image] = frame_decode(imgRef,motVecMat,imgRes,blkSiz)
    [row,col] = size(imgRef);
    imgDecode = zeros(size(imgRef));
    imgRef = double(imgRef);
    imgRes = double(imgRes);

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

            imgDecode(u:u+blkSiz-1,v:v+blkSiz-1) = ...
               imgRef(refBlkX:refBlkX+blkSiz-1,refBlkY:refBlkY+blkSiz-1)...
               +imgRes(u:u+blkSiz-1,v:v+blkSiz-1);

        end
    end

    % 画图 decode image 
    figure(4);imshow(uint8(imgDecode));title("decode image");

    decode_image = imgDecode;
end