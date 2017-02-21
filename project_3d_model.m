function [x, cam_center, rotation] = project_3d_model(x3d, object)
[cam_center, rotation] = getPose(object);
scale = 3;
x = [scale*x3d, ones(size(x3d, 1), 1)]*rotation';
end

