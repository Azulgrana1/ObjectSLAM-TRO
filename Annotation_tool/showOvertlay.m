% show the overlay of the CAD model to the image
% cls: class name, eg., 'car', 'bicycle', etc.
% example: show_cad_overlay('car');
scale = 1.0;
curId = 1;


cls = 'car';

% projection test
% load cad model
CADPath = sprintf('../CAD/%s.mat', cls);
object = load(CADPath);
load('aeroplanetrue');

while true
    
cad = object.(cls);
md = cad(1);
vertex = md.vertices;
face = md.faces;
rotMat = rotationData(curId).rot;
eular = rotm2eul(rotMat);
%rotMat = eye(3,3);
vtt = inv(rotMat)*vertex';
vtt = vtt';


close all;
figure(1);
patch('vertices', vtt, 'faces', face, 'FaceColor', 'blue', 'FaceAlpha', 0.4, 'EdgeColor', 'None');
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');

figure(2);
imname = rotationData(curId).voc_image_id;

img = imread([dir,imname,'.jpg']);
imshow(img);
ginput(1);
curId = curId+1;

end


