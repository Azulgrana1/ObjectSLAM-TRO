SEL_ID_FILE = '../seq1_folder/seq1_selImgId.txt';
KEYID_FILE = '../seq1_folder/seq1_keyId.txt';
POSE_FILE = '../seq1_folder/seq1_viewpose_g2o_after.txt';
VIEWPOSE_FILE = '../seq1_folder/seq1_viewpose_test.txt';
DATA_DIR = '../seq1_folder/seq1_keydata_0';
VAR_SRC_DIR = '../seq1_folder/seq1_var_0';
VAR_DES_DIR = '../seq1_folder/seq1_var_1';
OBJECT_POSES = '../seq1_folder/seq1_object_poses.txt';

dist_scale = 0.13;
obj_scale =0.85;

fx = 355.943766;
fy = 355.943766;
cx = 374.852374;
cy = 193.776062;
width = 760;
height = 368;
camKK = [fx, 0, cx; 0, fy, cy; 0, 0, 1];

keyIds = load(KEYID_FILE);
selId = load(SEL_ID_FILE);
poseRaw = load(POSE_FILE);
objPosesList = load(OBJECT_POSES);
load('./CAD/car.mat');

model = car(2);
pnames = model.pnames;
x3d = zeros(length(pnames), 3);
for i = 1:length(pnames)
    eval(['x3d(i, :)=model.', pnames{i}]);
end

for i=108:122
    curId = poseRaw(i,2);
    if(curId >= 10000)
        continue;
    end
    curPose = reshape(poseRaw(i,3:end), [4, 4]);
    objPose = reshape(objPosesList(3, 3:end), [4, 4]);
    
    dataName = sprintf('left_%06d.mat',curId*5);
    curRecord = load([DATA_DIR,'/',dataName]);
    
    obj2cam = curPose\objPose;
    x3dcam = [x3d, ones(size(x3d, 1), 1)]*obj2cam';
    x2d = (x3dcam(:, 1:3)./repmat(x3dcam(:, 4), 1, 3))*camKK';
    if(min(x2d(:, 3))<=0)
        continue;
    end
    x2d = x2d./repmat(x2d(:, 3), 1, 3);
    xmin = max(min(x2d(:,1)), 1);
    xmax = min(max(x2d(:,1)), width);
    ymin = max(min(x2d(:,2)), 1);
    ymax = min(max(x2d(:,2)), height);
    bbox = [xmin xmax ymin ymax];
    
    varName = sprintf('left_var%04d.txt',curId);
    varFile = [VAR_DES_DIR,'/',varName];
    
    varBackFile = [VAR_DES_DIR,'/',varName,'.backup'];
    if exist(varBackFile, 'file') == 2
        ;
    else
        copyfile(varFile,varBackFile);
    end
    
    mVar = load(varFile);
    bbox = uint32(bbox);
    for u=bbox(3):bbox(4)
        for v=bbox(1):bbox(2)
            mVar(u,v) = -1;
        end
    end
    save([VAR_DES_DIR, '/', varName],'mVar','-ascii');
    imshow(mVar/0.001);

end


