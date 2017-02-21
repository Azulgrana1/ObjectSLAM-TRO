function pushbutton_view_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% retrieve annotation
viewpoint.azimuth_coarse = handles.azimuth;
viewpoint.elevation_coarse = handles.elevation;
cad = handles.cad(handles.cad_index);

% get anchor point annotations
part_num = numel(cad.pnames);
pnames = cad.pnames;
x2d = [];
x3d = [];
for j = 1:handles.anchor_index(handles.partpos) %part_num
    if isempty(handles.(pnames{j}).location) == 0  % filters the point not clicked on the image
        p = handles.(pnames{j}).location;
        x2d = [x2d; p];
        x3d = [x3d; cad.(pnames{j})];
    end
end

% compute continous viewpoint
num_anch = size(x2d,1);
if num_anch < 2
      set(handles.text_filename, 'String', 'number of anchor less than 2');
else
    % inialization
    v0 = zeros(7,1);
    % azimuth
    a = viewpoint.azimuth_coarse;
    v0(1) = a*pi/180;
    margin = 22.5;
    aextent = [max(a-margin,0)*pi/180 min(a+margin,360)*pi/180];
    % elevation 
    e = viewpoint.elevation_coarse;
    v0(2) = e*pi/180;
    margin = 22.5;
    eextent = [max(e-margin,-90)*pi/180 min(e+margin,90)*pi/180];        
    % distance
    dextent = [0, 100];
    v0(3) = compute_distance(v0(1), v0(2), dextent, x2d, x3d);
    d = v0(3);
    margin = 5;
    dextent = [max(d-margin,0) min(d+margin,100)];
    % focal length
    v0(4) = 1;
    fextent = [1 1];
    % principal point
    [principal_point, lbp, ubp] = compute_principal_point(v0(1), v0(2), v0(3), x2d, x3d);
    v0(5) = principal_point(1);
    v0(6) = principal_point(2);
    % in-plane rotation
    v0(7) = 0;
    rextent = [-pi, pi];
    % lower bound
    lb = [aextent(1); eextent(1); dextent(1); fextent(1); lbp(1); lbp(2); rextent(1)];
    % upper bound
    ub = [aextent(2); eextent(2); dextent(2); fextent(2); ubp(1); ubp(2); rextent(2)];

    % optimization
    v_out = zeros(10,1);
    [v_out(1), v_out(2), v_out(3), v_out(4), v_out(5), v_out(6), v_out(7), v_out(8), v_out(9), v_out(10)]...
        = compute_viewpoint_one(v0, lb, ub, x2d, x3d);

    % assign output
    azimuth = v_out(1);
    elevation = v_out(2);
    distance = v_out(3); 
    focal = v_out(4);
    px = v_out(5);
    py = v_out(6);
    theta = v_out(7);
    error = v_out(8);
    interval_azimuth = v_out(9);
    interval_elevation = v_out(10);
    str = sprintf('a=%f, e=%f, d=%f, f=%f, theta=%f\n', azimuth, elevation,...
            distance, focal, theta);
    set(handles.text_filename, 'String', str);
    
    % show overlay of the CAD model
    vertices = cad.vertices;
    faces = cad.faces;
    object.viewpoint.azimuth = azimuth;
    object.viewpoint.elevation = elevation;
    object.viewpoint.distance = distance;
    object.viewpoint.focal = 1;
    object.viewpoint.theta = theta;
    object.viewpoint.px = px;
    object.viewpoint.py = py;
    object.viewpoint.viewport = 3000;
    x2d = project_3d_points(vertices, object);
    if isempty(x2d) == 0
        set(handles.figure1, 'CurrentAxes', handles.axes_image);
        hold on;
        patch('vertices', x2d ,'faces', faces, ...
            'FaceColor', 'blue', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        hold off;
    end
end