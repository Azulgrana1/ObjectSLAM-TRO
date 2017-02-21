%global parameter of camera
camInfo = struct('cx','cy','fx','fy','x','y');
camInfo.cx = 7.497047486305237e+02/2;
camInfo.cy = 3.875521240234375e+02/2;
camInfo.fx = 7.118875318255427e+02/2;
camInfo.fy = 7.118875318255427e+02/2;
camInfo.x = 1520/2;
camInfo.y = 768/2;
camKK = [camInfo.fx 0 camInfo.cx;0 camInfo.fy camInfo.cy;0 0 1];
invcamKK = inv(camKK);
abscale = 0.15;
oriRotM = [1 0 0;0 -1 0; 0 0 -1];



dataPath = 'E:\workspace\cvpr_2017\objEstimate\cvpr_2017_kit\cvpr_fit\';
allDepthFile = dir([dataPath,'depth_0\left_depth*.txt']);
allDepthFileName = {allDepthFile.name}';
mData = load('NewDataResults_Car1.mat');
mData = mData.NewDataResults_Car1;
CAD = load('car.mat');
pnames = load('pnames.mat');

CADVerts = CAD.car(1).vertices;
CADFaces = CAD.car(1).faces;
colorPan = jet(4);

allRecordName = {mData.voc_image_id}';
for i=1:length(allDepthFileName)
    curDepthFile = allDepthFileName{i};
    curDepthId = str2num(curDepthFile(11:14));
    curNameToFind = sprintf('left_%06d',curDepthId*5);
    RawResult = cellfun(@(x) strfind(x,curNameToFind),allRecordName,'UniformOutput',false);
    stringInRow = cellfun(@(x) numel(x) == 1 || (numel(x)>1)*numel(cell2mat(x))>0, RawResult);
    recordId = find(stringInRow);
    depthRecordFind = false;
    if(~isempty(recordId))
        depthRecordFind = true;
    end
    if(depthRecordFind)
        Kps = mData(recordId).kps;
        KpsScores = mData(recordId).kpsScores;
        if(~isempty(Kps))
            imgFile = [dataPath,'depth_0/',curDepthFile];
            depthData = load(imgFile);
            figure(1);
            imshow(depthData);           
            hold on;
            KpsOut = KpsFilter(Kps,KpsScores);
            for jj=1:length(Kps)
                if(KpsScores(jj)>0 && KpsOut(1,jj)>0)
                    plot(KpsOut(1,jj)/2,KpsOut(2,jj)/2,'*','color',colorPan(mod(jj,4)+1,:));                    
                    tt = text(KpsOut(1,jj)/2,KpsOut(2,jj)/2,[pnames.pnames{jj},':',num2str(KpsScores(jj))]);
                    set(tt,'Color',colorPan(mod(jj,4)+1,:));
                    set(tt, 'Interpreter', 'none')
                end
            end
            figure(2);
            plot(KpsScores(1:4));
            pause(0.5);
        end
    end
    
    
    
end