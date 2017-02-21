% show the PASCAL annotations
% cls: class name, eg., 'car', 'bicycle', etc.
% example: show_annotation_pascal('car');
function show_annotation_pascal(cls)

path_image = sprintf('../Images/%s_pascal', cls);
path_ann = sprintf('../Annotations/%s_pascal', cls);

figure;
files = dir(path_image);
N = numel(files);
i = 1;
while i <= N
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            disp(filename);
            I = imread(fullfile(path_image, filename));
            imshow(I);
            hold on;

            % load annotation
            filename_ann = sprintf('%s/%s.mat', path_ann, name);

            if exist(filename_ann) == 0
                errordlg('No annotation available for the image');
            else
                object = load(filename_ann);
                record = object.record;
                tit = [];

                % show the bounding box
                for j = 1:numel(record.objects)
                    if strcmp(record.objects(j).class, cls) == 1
                        bbox = record.objects(j).bbox;
                        bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
                        rectangle('Position', bbox_draw, 'EdgeColor', 'g');
                        % show anchor points
                        if isfield(record.objects(j), 'anchors') == 1 && isempty(record.objects(j).anchors) == 0
                            names = fieldnames(record.objects(j).anchors);
                            for k = 1:numel(names)
                                if record.objects(j).anchors.(names{k}).status == 1
                                    x = record.objects(j).anchors.(names{k}).location(1);
                                    y = record.objects(j).anchors.(names{k}).location(2);
                                    plot(x, y, 'ro');
                                end
                            end
                        end
                        if record.objects(j).viewpoint.distance == 0
                            str = sprintf('ac=%.2f, ec = %.2f, ', record.objects(j).viewpoint.azimuth_coarse, ...
                                record.objects(j).viewpoint.elevation_coarse);
                        else
                            str = sprintf('a=%.2f, e=%.2f, d=%.2f, ', record.objects(j).viewpoint.azimuth, ...
                                record.objects(j).viewpoint.elevation, record.objects(j).viewpoint.distance);
                        end
                        tit = strcat(tit, str);
                    end
                end             
            end
            title(tit);
            hold off;
            pause;
        end
    end
    i = i + 1;
end