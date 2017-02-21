DATA_DIR = '/home/bbnc/databag/seq1_keydata_0';
IMG_DIR = '/home/bbnc/databag/seq1_keyimagesResize_0';
depthId = 2480;
colorPan = jet(7);
%CONVERTANCHOR Summary of this function goes here
%   Detailed explanation goes here

imgFile = sprintf('left_%06d.jpg',depthId);
dataFile = sprintf('left_%06d.mat',depthId);


load([DATA_DIR,'/',dataFile]);
img = imread([IMG_DIR,'/',imgFile]);



objInfo = record.objects;
objClass = objInfo.class;
objCADInd = objInfo.cad_index;

tmpExp = strcat('./CAD/',objClass);
objCAD = load(tmpExp);

tmpExp = strcat('objCAD = objCAD.',objClass);
eval(tmpExp);
objCAD = objCAD(objCADInd);
pnames = objCAD.pnames;
keyNum = length(pnames);   
x3d = zeros(keyNum,3);
x2d = zeros(keyNum,2); 
figure(1);
imshow(img);
hold on;

for i=1:keyNum    
    tmpExp = strcat('x2dstatus=objInfo.anchors.',pnames{i},'.status');
    eval(tmpExp);
    if(x2dstatus==1)
        tmpExp = strcat('x2d(i,:)=objInfo.anchors.',pnames{i},'.location');
        eval(tmpExp);       
        plot(x2d(i,1),x2d(i,2),'.','color',colorPan(mod(i,7)+1,:),'MarkerSize',40);     
        
    end            
end