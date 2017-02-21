allDepthFile = dir('depth_0/left_depth*.txt');
n = size(allDepthFile, 1);
keyID = fopen('keyID.txt', 'w');
keys = zeros(n, 1);
for i = 1:n
    keys(i) = sscanf(allDepthFile(i).name, 'left_depth%04d.txt');
    fprintf(keyID, '%d\n', keys(i));
end
