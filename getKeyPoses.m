keyID = load('keyID.txt');

cx = 7.497047486305237e+02/2;
cy = 3.875521240234375e+02/2;
fx = 7.118875318255427e+02/2;
fy = 7.118875318255427e+02/2;
poses = load('poses2.txt');
n = size(poses, 1);
keyPoses = fopen('poses_key.txt', 'w');
index = 1;
for i = 1:n
	key = keyID(index);
    imageID = poses(i, 1);
    %cam2cam = vec2mat(poses(i, 2:17), 4)';
    if(imageID > key)
        index = index + 1;
        i = i-1;
    else
        %rotation = cam2cam*rotation;
        if (imageID == key)
            fprintf(keyPoses, '%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', poses(i, :));
            index = index + 1;
        end
    end       
end
