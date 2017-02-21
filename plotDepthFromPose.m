
DEPTH_DIR = './depth_0/';
keyID = load('keyID.txt');
figure;
hold on;
axis equal;

cx = 7.497047486305237e+02/2;
cy = 3.875521240234375e+02/2;
fx = 7.118875318255427e+02/2;
fy = 7.118875318255427e+02/2;
width = 760; height = 368;
poses = load('poses_key.txt');

for i = 1:10
    
    DEPTH_FILE = sprintf('left_depth%04d.txt', keyID(i));
   
    depth = load([DEPTH_DIR, DEPTH_FILE]);
%     IMG_FILE = sprintf('./images/left_%06d.jpg',keyId(i)*5);
%     imgrgb = imread(IMG_FILE);
    rotation = vec2mat(poses(i, 2:17), 4)';
    
    center = rotation(:, 4);
    points3d = convert3dPoints(depth);
    points3d = [points3d, ones(size(points3d, 1),1)]*rotation';
    
    plot3(center(1), center(2), center(3), 'rx');
    plot3(points3d(:, 1), points3d(:, 2), points3d(:, 3), 'b.', 'MarkerSize', 0.5);
end
