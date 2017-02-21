function runNewTest
keys = load('labeled_key');
[n,~] = size(keys);
compare3dPoints(keys(1));
end