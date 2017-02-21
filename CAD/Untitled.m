load('car.mat');
cadcd = car(1);
verts = cadcd.vertices;
faces = cadcd.faces;

figure;
hold on;
grid on;
vertN = [0 0 1];
patch('vertices', verts, 'faces', faces, 'FaceColor', 'None', 'VertexNormals',...
         vertN, 'FaceAlpha', 0.7, 'EdgeColor','blue','FaceLighting','gouraud',...
         'BackFaceLighting','lit');
axis equal;
keypointNum = numel(cadcd.pnames);
keypointSet = cadcd.pnames;
for i=1:keypointNum
    eval(['curpoint = cadcd.',keypointSet{i}]);
    plot3(curpoint(1),curpoint(2),curpoint(3),'r*');
end
