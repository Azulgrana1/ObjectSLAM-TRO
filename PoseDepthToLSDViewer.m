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

keyIds = load(KEYID_FILE);
selId = load(SEL_ID_FILE);
poseRaw = load(POSE_FILE);

fpose = fopen(VIEWPOSE_FILE,'wt');

fprintf(fpose,'%f %f %f %f %d %d\r\n',cx,cy,fx,fy,width,height);


for i=1:length(keyIds)
    curId = keyIds(i);
    curRank = find(selId==curId);
    curPose = poseRaw(i,:);
    
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

