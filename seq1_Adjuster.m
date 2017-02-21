SEL_ID_FILE = '/home/bbnc/databag/seq1_selImgId.txt';
KEYID_FILE = '/home/bbnc/databag/seq1_keyId.txt';
POSE_FILE = '/home/bbnc/databag/seq1_pose.txt';
VIEWPOSE_FILE = '/home/bbnc/databag/seq1_viewpose.txt';
DATA_DIR = '/home/bbnc/databag/seq1_seldata_0';
dist_scale = 0.13;
obj_scale =0.85;

fx = 355.943766;
fy = 355.943766;
cx = 374.852374;
cy = 193.776062;
width = 760;
height = 368;


cam2 = [-3.643590e-01 -1.355500e-01 9.213410e-01 0 -5.090640e-02 9.907700e-01 1.256330e-01 0 -9.298660e-01 -1.126570e-03 -3.678960e-01 0 2.472190e+00 -1.502280e-01 2.382630e+00 1 ];
cam2_new = [-0.734126782959165,-0.0760283676951873,0.674741709893976,0,0.0588874981494997,0.982838599063231,0.174814289654231,0,-0.676453273238514,0.168069803326194,-0.717051550839478,0,1.90338912299446,-0.191296076182449,2.28091482983913,1];

cam2_pose = reshape(cam2,4,4);
cam2_newpose = reshape(cam2_new,4,4);


keyIds = load(KEYID_FILE);
selId = load(SEL_ID_FILE);
poseRaw = load(POSE_FILE);

fpose = fopen(VIEWPOSE_FILE,'wt');

fprintf(fpose,'%f %f %f %f %d %d\r\n',cx,cy,fx,fy,width,height);
for i=1:length(keyIds)
    curId = keyIds(i);
    curRank = find(selId==curId);
    curPose = poseRaw(i,:);
    if(curId>245 && curId<420)
        continue;
    elseif(curId>=420)
        curPose = reshape(curPose,4,4);
        curPose = cam2_newpose*inv(cam2_pose)*curPose;
        curPose = curPose(:);        
    end
    
    
    
        
    
    
    
    
    
    if(isempty(curRank))
        fprintf(fpose,'0 %d ',curId);
        for j=1:16
            fprintf(fpose,'%d ',curPose(j));
        end
        fprintf(fpose,'\r\n');
    else
        fprintf(fpose,'1 %d ',curId);
        for j=1:16
            fprintf(fpose,'%d ',curPose(j));
        end
        fprintf(fpose,'\r\n');
        
        fprintf(fpose,'1 %d ',curId);
        dataName = sprintf('left_%06d.mat',curId*5);
        curRecord = load([DATA_DIR,'/',dataName]);
        [junk objPose] = getPose(curRecord.record.objects);
        objPose = objPose(:);
        objPose(13:15) = objPose(13:15)*dist_scale;
        objPose(16) = objPose(16)*obj_scale;
        for j=1:16
            fprintf(fpose,'%d ',objPose(j));
        end
        fprintf(fpose,'\r\n');
    end
end

fclose(fpose);

