keyID = 485;

DEPTH_DIR = '/home/bbnc/databag/seq1_depth_0';
DATA_DIR =  '/home/bbnc/databag/seq1_seldata_0';
DEPTH_FILE = sprintf('left_depth%04d.txt', keyID/5);
DATA_FILE = sprintf('left_%06d', keyID);
depth = load([DEPTH_DIR,'/', DEPTH_FILE]);
load([DATA_DIR,'/', DATA_FILE]);
load('./CAD/car.mat');
points3d = convert3dPoints(depth);

p_model = project_3d_model(car(2).vertices, record.objects);
figure;hold on;


p3d = length(points3d);
sparseId = 1:50:p3d;
points3d = points3d(sparseId,:);
scatter3(points3d(:, 1), points3d(:, 2), points3d(:, 3),'.');

scatter3(p_model(:, 1), p_model(:, 2), p_model(:, 3),'r.');
xlabel('x'); ylabel('y'); zlabel('z');
axis equal;


%points2d = points3d(:, 1:2)./(repmat(points3d(:, 3), 1, 2));
%model_2d = p_model(:, 1:2)./repmat(p_model(:, 3), 1,2);
%figure;
%scatter(points2d(:, 1), -points2d(:, 2), '.');
%hold on;
%scatter(model_2d(:, 1), -model_2d(:, 2), 'r.');