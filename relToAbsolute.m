poses_rel = load('poses_adjusted_rel');
cam2world = eye(4);
n = size(poses_rel, 1);
poses_adjusted = fopen('poses_adjusted.txt','w');

for i = 1:n
    
end