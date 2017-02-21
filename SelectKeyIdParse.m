KEY_ID_FILE = '/home/bbnc/databag/seq1_keyId.txt';
SEL_IMG_DIR = '/home/bbnc/databag/seq1_selimages_0';


SEL_IMG_FILE = '/home/bbnc/databag/seq1_selImgId.txt';

selImgFile = dir(fullfile(SEL_IMG_DIR,'*.jpg'));
selImgName = {selImgFile.name};


fselImg = fopen(SEL_IMG_FILE,'wt');
for i=1:length(selImgName)
    curImgName = selImgName{i};
    curImgId = str2num(curImgName(6:11))/5;
    fprintf(fselImg,'%d\n',curImgId);
end

fclose(fselImg);
