% show the overlay of the CAD model to the image
% cls: class name, eg., 'car', 'bicycle', etc.
% example: show_cad_overlay('car');
function show_cad_overlay(cls)

% projection test
annotationPath = sprintf('../Annotations/%s_pascal/', cls);
imagePath = sprintf('../Images/%s_pascal/', cls);

% load cad model
CADPath = sprintf('../CAD/%s.mat', cls);
object = load(CADPath);
cad = object.(cls);

listing = dir(annotationPath);
recordSet = {listing.name};

figure;
for recordElement = recordSet
    [~, ~, ext] = fileparts(recordElement{1});
    if ~strcmp(ext, '.mat')
        continue;
    end
    record = load([annotationPath recordElement{1}],'record');
    record = record.record;
    
    im = imread([imagePath, record.filename]);
    imshow(im);
    
    carIdxSet = find(ismember({record.objects(:).class}, cls));
    
    hold on;
    for carIdx = carIdxSet
        if record.objects(carIdx).viewpoint.distance == 0
            fprintf('No continuous viewpoint\n');
            continue;
        end
        vertex = cad(record.objects(carIdx).cad_index).vertices;
        face = cad(record.objects(carIdx).cad_index).faces;
        x2d = project_3d(vertex, record.objects(carIdx));
        patch('vertices', x2d, 'faces', face, ...
            'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end
    axis off;
    hold off;
    pause;
    clf;
end