function points3d = convert3dPoints(depth)
camInfo = struct('cx','cy','fx','fy','x','y');
camInfo.cx = 374.852374;
camInfo.cy = 193.776062;
camInfo.fx = 355.943766;
camInfo.fy = 355.943760;
camInfo.x = 760; 
camInfo.y = 368;
camKK = [camInfo.fx 0 camInfo.cx;0 camInfo.fy camInfo.cy;0 0 1];
invcamKK = inv(camKK);
oriRotM = [-1 0 0;0 -1 0; 0 0 1];

[Y, X] = size(depth);
rows = repmat([1:Y], 1, X);
cols = repmat([1:X], Y, 1);
cols = cols(:)';
points2d = [cols; rows; ones(1, X*Y)];
points3d = (invcamKK * points2d)./(repmat(depth(:)', 3, 1));
points3d = points3d';
points3d = points3d(points3d(:,3)>0, :);
%mask = abs(points3d) < 10;
%points3d = mask.*points3d;
points3d = points3d(abs(points3d(:, 1))<10 & abs(points3d(:, 2))<10 & points3d(:, 3)<10, :);
end