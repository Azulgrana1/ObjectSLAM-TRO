OBJECT_FILE = '../seq1_folder/seq1_objects.txt';
SEL_ID_FILE = '../seq1_folder/seq1_selImgId.txt';
KEYID_FILE = '../seq1_folder/seq1_keyId.txt';
POSE_FILE = '../seq1_folder/seq1_viewpose_g2o_after.txt';
VIEWPOSE_FILE = '../seq1_folder/seq1_viewpose_test.txt';
DATA_DIR = '../seq1_folder/seq1_seldata_0';
VAR_SRC_DIR = '../seq1_folder/seq1_var_0';
VAR_DES_DIR = '../seq1_folder/seq1_var_1';
OBJECT_POSE_FILE = '../seq1_folder/seq1_object_poses.txt';

dist_scale = 0.13;
obj_scale =0.85;

fx = 355.943766;
fy = 355.943766;
cx = 374.852374;
cy = 193.776062;
width = 760;
height = 368;

load(OBJECT_FILE);
poseRaw = load(POSE_FILE);
fobj_pose = fopen(OBJECT_POSE_FILE, 'w');
N_entries = size(seq1_objects, 1);

%loop
for i = 1:N_entries;
curId = seq1_objects(i, 1);
objectID = seq1_objects(i, 2);
dataName = sprintf('left_%06d.mat',curId*5);
curRecord = load([DATA_DIR,'/',dataName]);
[~, objPose] = getPose(curRecord.record.objects);
objPose(1:3, 4) =  objPose(1:3, 4)*dist_scale;
objPose(4, 4) = objPose(4, 4) * obj_scale;

idx = find(poseRaw(:, 2)==curId);
cam2world = reshape(poseRaw(idx, 3:18)',[4,4]);
obj2world = cam2world*objPose;
obj2world_vec = obj2world(:);
fprintf(fobj_pose, '%d %d ', curId, objectID);
for j = 1:16
    fprintf(fobj_pose, '%f ', obj2world_vec(j));
end
fprintf(fobj_pose, '\r\n');
end
