function [ x2d,x3d ] = ConvertAnchor( AnchorRecord )
%CONVERTANCHOR Summary of this function goes here
%   Detailed explanation goes here
objInfo = AnchorRecord.objects;
objClass = objInfo.class;
objCADInd = objInfo.cad_index;

tmpExp = strcat('./CAD/',objClass);
objCAD = load(tmpExp);

tmpExp = strcat('objCAD = objCAD.',objClass);
eval(tmpExp);
objCAD = objCAD(objCADInd);
pnames = objCAD.pnames;
keyNum = length(pnames);   
x3d = zezos(keyNum,3);
x2d = zeros(keyNum,2); 
for i=1:keyNum
    tmpExp = strcat('x3d(i,:)=objCAD.',pnames{i});
    eval(tmpExp);
    tmpExp = strcat('x2dstatus=objInfo.anchors.',pnames{i},'.status');
    eval(tmpExp);
    if(x2dstatus==1)
        tmpExp = strcat('x2d(i,:)=objInfo.anchors.',pnames{i},'.location');
        eval(tmpExp);
    end            
end
end

