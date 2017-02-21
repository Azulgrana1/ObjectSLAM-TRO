SEL_ID_FILE = '../seq1_folder/seq1_selImgId.txt';
KEYID_FILE = '../seq1_folder/seq1_keyId.txt';
POSE_FILE = '../seq1_folder/seq1_viewpose_g2o_after.txt';
VIEWPOSE_FILE = '../seq1_folder/seq1_viewpose_test.txt';
DATA_DIR = '../seq1_folder/seq1_seldata_0';
VAR_SRC_DIR = '../seq1_folder/seq1_var_0';
VAR_DES_DIR = '../seq1_folder/seq1_var_1';

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
for i=1:length(poseRaw)
    
    curId = poseRaw(i,2);
    curRank = find(selId==curId);
    curPose = poseRaw(i,3:end);
    
    
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
        
        fprintf(fpose,'1 %d ',curId);
        dataName = sprintf('left_%06d.mat',curId*5);
        curRecord = load([DATA_DIR,'/',dataName]);
        [junk, objPose] = getPose(curRecord.record.objects);
        [bbox] = getBBox(curRecord.record.objects);
        varName = sprintf('left_var%04d.txt',curId);
        varFile = [VAR_DES_DIR,'/',varName];
       
        varBackFile = [VAR_DES_DIR,'/',varName,'.backup'];
         if exist(varBackFile, 'file') == 2
             ;
         else
            copyfile(varFile,varBackFile);
         end
         
         mVar = load(varFile);
         bbox = uint32(bbox(:));
         for u=bbox(2):bbox(4)
             for v=bbox(1):bbox(3)
                 mVar(u,v) = -1;
             end
         end
         save(varFile,'mVar','-ascii');
                                                                    
        objPose = objPose(:);
        objPose(13:15) = objPose(13:15)*dist_scale;
        objPose(16) = objPose(16)*obj_scale;
        for j=1:16
            fprintf(fpose,'%f ',objPose(j));
        end
        fprintf(fpose,'\r\n');
    end
end

fclose(fpose);

