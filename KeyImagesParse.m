DEPTH_DIR = '/home/bbnc/databag/seq1_depth_0';
IMAGE_SRC_DIR = '/home/bbnc/databag/CVPR_data/cvpr_new/d1/image_0';
IMAGE_DES_DIR = '/home/bbnc/databag/seq1_keyimages_0';
mkdir(IMAGE_DES_DIR);
POSE_NAME = '/home/bbnc/databag/seq1_keyId.txt';
depthFiles = dir(fullfile(DEPTH_DIR,'*.txt'));
depthFileNames = {depthFiles.name}';
depthNum = length(depthFileNames);
preFix = 'left_depth';
preFixLen = length(preFix);
fullLen = length(depthFileNames{1});
keyIds = zeros(depthNum,1);
for i=1:depthNum
    curFileName = depthFileNames{i};
    curIdStr = curFileName(preFixLen+1:(fullLen-4));
    curId = str2num(curIdStr);
    curImageName = sprintf('left_%06d.jpg',curId*5);
    copyfile([IMAGE_SRC_DIR,'/',curImageName],[IMAGE_DES_DIR,'/',curImageName]);
    keyIds(i) = curId;    
end
save(POSE_NAME,'keyIds','-ascii');