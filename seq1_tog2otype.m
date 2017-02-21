SEL_ID_FILE = '/home/bbnc/databag/seq1_selImgId.txt';
KEYID_FILE = '/home/bbnc/databag/seq1_keyId.txt';
POSE_FILE = '/home/bbnc/databag/seq1_pose.txt';
VIEWPOSE_FILE = '/home/bbnc/databag/seq1_viewpose_g2o.txt';
EDGE_FILE = '/home/bbnc/databag/seq1_edge_g2o.txt';
DATA_DIR = '/home/bbnc/databag/seq1_keydata_0';
OBJECT_FILE = '/home/bbnc/databag/seq1_objects.txt';

dist_scale = 0.13;
obj_scale =0.85;

fx = 355.943766;
fy = 355.943766;
cx = 374.852374;
cy = 193.776062;
width = 760;
height = 368;

keyIds = load(KEYID_FILE);
selId = load(SEL_ID_FILE);
poseRaw = load(POSE_FILE);


fpose = fopen(VIEWPOSE_FILE,'wt');
fedge = fopen(EDGE_FILE,'wt');

posePrev = zeros(1,16);

objectId = load(OBJECT_FILE);
objectBucket = zeros(max(objectId(:,2)),1);

for i=1:length(keyIds)
    
    % Add Camera Vertexs and Camera-Camera Constraints
    curId = keyIds(i);
    curRank = find(selId==curId);
    curPose = poseRaw(i,:);
    
    if(i>1)
        curPoseMat = reshape(curPose,4,4);
        prePoseMat = reshape(posePrev,4,4);
        relMat = inv(prePoseMat)*curPoseMat;
        relPose = relMat(:);
        fprintf(fedge,'0 %d %d ',keyIds(i-1),keyIds(i));
        for j=1:16
            fprintf(fedge,'%f ',relPose(j));
        end
        fprintf(fedge,'\r\n');
    end
    posePrev = curPose;
    if(isempty(curRank))
        fprintf(fpose,'0 %d ',curId);
        for j=1:16
            fprintf(fpose,'%f ',curPose(j));
        end
        fprintf(fpose,'\r\n');
    else
        fprintf(fpose,'1 %d ',curId);
        for j=1:16
            fprintf(fpose,'%f ',curPose(j));
        end
        fprintf(fpose,'\r\n');
        
        objId = objectId(curRank,2);
        if objectBucket(objId)==0
            dataName = sprintf('left_%06d.mat',curId*5);
            curRecord = load([DATA_DIR,'/',dataName]);
            [junk objPose] = getPose(curRecord.record.objects);
            objPose = objPose(:);
            objPose(13:15) = objPose(13:15)*dist_scale/obj_scale;
            
            curPoseMat = reshape(curPose,4,4);
            curObjMat = reshape(objPose,4,4);
            curObjMat = curPoseMat*curObjMat;
            curObjPose = curObjMat(:);
            
            fprintf(fpose,'1 %d ',objId+10000);
            for j=1:16
                fprintf(fpose,'%f ',curObjPose(j));
            end
            fprintf(fpose,'\r\n');
            objectBucket(objId) = 1;
        end
    end
end


% Add Object Camera Constaints
for ii=1:length(objectId)
    fprintf(fedge,'1 %d %d ',objectId(ii,1), objectId(ii,2)+10000);
    dataName = sprintf('left_%06d.mat',objectId(ii,1)*5);
    curRecord = load([DATA_DIR,'/',dataName]);
    [junk objPose] = getPose(curRecord.record.objects);
    objPose = objPose(:);
    objPose(13:15) = objPose(13:15)*dist_scale/obj_scale;
    for j=1:16
        fprintf(fedge,'%f ',objPose(j));
    end
    fprintf(fedge,'\r\n');
end


fclose(fedge);
fclose(fpose);

