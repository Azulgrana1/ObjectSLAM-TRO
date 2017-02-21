SRC_IMG_DIR = '/home/bbnc/databag/seq1_keyimages_0';
DES_IMG_DIR = '/home/bbnc/databag/seq1_keyimagesResize_0';
mkdir(DES_IMG_DIR);

rows = 368;
cols = 760;
rawImgs = dir(fullfile(SRC_IMG_DIR,'*.jpg'));
rawImgsName = {rawImgs.name}';
for i=1:length(rawImgsName)
    oriImg = imread([SRC_IMG_DIR,'/',rawImgsName{i}]);
    rImg = imresize(oriImg,[rows cols]);
    imwrite(rImg,[DES_IMG_DIR,'/',rawImgsName{i}]);    
end
