% P*Vert = V_cor;
%V_cor*K = Image;
% show the overlay of the CAD model to the image
% cls: class name, eg., 'car', 'bicycle', etc.
% example: show_cad_overlay('car');
scale = 1.0;


cls = 'car';

% projection test
% load cad model
CADPath = sprintf('../CAD/%s.mat', cls);
object = load(CADPath);
load('car');

cad = object.(cls);
md = cad(1);
vertex = md.vertices;
face = md.faces;
rotMat = rotationData_test.rot;
vtt = inv(rotMat)*vertex';
vtt = vtt';
patch('vertices', vtt, 'faces', face, 'FaceColor', 'blue', 'FaceAlpha', 0.4, 'EdgeColor', 'None');
axis equal;
figure;
img = imread('2016_000001.jpg');
imshow(img);



[h,w,c] = size(img);
vi_fx = 500;
vi_fy = 500;
vi_cx = w/2;
vi_cy = h/2;
vi_K = [vi_fx 0 vi_cx; 0 vi_fy vi_cy;0 0 1];
vtt_inv = vtt+