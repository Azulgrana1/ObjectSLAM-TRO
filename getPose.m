function [cam_center, rotation] = getPose(object)
if isfield(object, 'viewpoint') == 1
    % project the 3D points
    viewpoint = object.viewpoint;
    a = viewpoint.azimuth*pi/180;
    e = viewpoint.elevation*pi/180;
    d = viewpoint.distance;
    f = viewpoint.focal;
    theta = viewpoint.theta*pi/180;
    principal = [viewpoint.px viewpoint.py];
    viewport = viewpoint.viewport;
else
    cam_center = [];rotation = [];
    return;
end

if d == 0
    cam_center = [];rotation = [];
    return;
end

% camera center
C = zeros(3,1);
C(1) = d*cos(e)*sin(a);
C(2) = -d*cos(e)*cos(a);
C(3) = d*sin(e);
scale = 7;
C = scale*C;
cam_center = C;

a = -a;
e = -(pi/2-e);

% rotation matrix
Rz = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];   %rotate by a
Rx = [1 0 0; 0 cos(e) -sin(e); 0 sin(e) cos(e)];   %rotate by e
R = Rx*Rz;

% perspective project matrix
M = viewport;
P = [1 0 0; 0 1 0; 0 0 -1] * [R -R*C];

alpha = principal(1);
phi = principal(2);
R_x = [1, 0, 0; 0, cos(alpha), -sin(alpha); 0, sin(alpha), cos(alpha)];
R_y = [cos(phi), 0,  -sin(phi); 0, 1, 0; sin(phi), 0, cos(phi)];
R_3d = R_y*R_x;

% rotation matrix 2D
R2d = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
rotation = diag([1, -1, 1, 1])*blkdiag(R2d*R_3d, 1)*[P; zeros(1, 3) 1];
end