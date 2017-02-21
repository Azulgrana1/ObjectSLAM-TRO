function plotDepthPoints()
DEPTH_DIR = './depth_0/';
DATA_DIR = './keyData/';
n = 40;
keyID = load('keyID.txt');
figure;
hold on;
axis equal;

cx = 7.497047486305237e+02/2;
cy = 3.875521240234375e+02/2;
fx = 7.118875318255427e+02/2;
fy = 7.118875318255427e+02/2;
file = fopen('poses_new.txt','w');
pose_rel = fopen('poses_new_rel.txt','w');
prev_cam = eye(4);
%fprintf(file, '%f %f %f %f\n', cx, cy, fx, fy);
for i = 29:49
    DEPTH_FILE = sprintf('left_depth%04d.txt', keyID(i));
    DATA_FILE = sprintf('left_%06d.mat', keyID(i)*5);
    depth = load([DEPTH_DIR, DEPTH_FILE]);
    load([DATA_DIR, DATA_FILE]);
%     IMG_FILE = sprintf('./images/left_%06d.jpg',keyId(i)*5);
%     imgrgb = imread(IMG_FILE);
    
    [center, rotation] = getPose(record.objects);
    cam2world = inv(rotation);
    cam2cam = cam2world/prev_cam;
    prev_cam = cam2world;
    fprintf(file, '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n'...
        ,keyID(i), cam2world(:)');
    fprintf(pose_rel, '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n'...
        ,keyID(i), cam2cam(:)');
    points3d = convert3dPoints(depth);
    points3d = [points3d, ones(size(points3d, 1),1)]/(rotation');
    
    plot3(center(1), center(2), center(3), 'rx');
    plot3(points3d(:, 1), points3d(:, 2), points3d(:, 3), 'b.', 'MarkerSize', 0.5);
end
end