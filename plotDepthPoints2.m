function plotDepthPoints2()
DEPTH_DIR = './depth_0/';
DATA_DIR = './keyData/';
DATA2_DIR = './keyData2/';
n = 40;
keyID = load('keyID.txt');
figure;
hold on;
axis equal;

cx = 7.497047486305237e+02/2;
cy = 3.875521240234375e+02/2;
fx = 7.118875318255427e+02/2;
fy = 7.118875318255427e+02/2;

file = fopen('poses2.txt','w');
fprintf(file, '%f %f %f %f\n', cx, cy, fx, fy);
for i = 5:14
    DEPTH_FILE = sprintf('left_depth%04d.txt', keyID(i));
    DATA_FILE = sprintf('left_%06d.mat', keyID(i)*5);
    depth = load([DEPTH_DIR, DEPTH_FILE]);
    load([DATA_DIR, DATA_FILE]);
%     IMG_FILE = sprintf('./images/left_%06d.jpg',keyId(i)*5);
%     imgrgb = imread(IMG_FILE);
    
    [center, rotation] = getPose(record.objects);
    cam2world = inv(rotation);
    fprintf(file, '%d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n'...
        ,1,keyID(i), cam2world(:)');
    points3d = convert3dPoints(depth);
    points3d = [points3d, ones(size(points3d, 1),1)]/(rotation');
    
    plot3(center(1), center(2), center(3), 'rx');
    plot3(points3d(:, 1), points3d(:, 2), points3d(:, 3), 'b.', 'MarkerSize', 0.5);
end

rotation1 = rotation;% car1 to camera
DATA_FILE = sprintf('left_%06d.mat', keyID(14)*5);
load([DATA2_DIR, DATA_FILE]);
[center2, rotation2] = getPose(record.objects);
rotation21 = rotation1\rotation2;% car2 to car1

for i = 14:36
    DEPTH_FILE = sprintf('left_depth%04d.txt', keyID(i));
    DATA_FILE = sprintf('left_%06d.mat', keyID(i)*5);
    depth = load([DEPTH_DIR, DEPTH_FILE]);
    load([DATA2_DIR, DATA_FILE]);
%     IMG_FILE = sprintf('./images/left_%06d.jpg',keyId(i)*5);
%     imgrgb = imread(IMG_FILE);  
    [center, rotation] = getPose(record.objects);%car2
    center = rotation21*[center; 1];
    cam2world = rotation21/rotation;
    fprintf(file, '%d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n'...
        ,1,keyID(i), cam2world(:)');
    points3d = convert3dPoints(depth);
    points3d = [points3d, ones(size(points3d, 1),1)]/(rotation')*rotation21';
    
    plot3(center(1), center(2), center(3), 'rx');
    plot3(points3d(:, 1), points3d(:, 2), points3d(:, 3), 'b.', 'MarkerSize', 0.5);
end
end