function [bbox] = getBBox(object)
    cls = object.class;
    mCAD = load(['./CAD/',cls,'.mat']);
    eval(['pnames = mCAD.',cls,'.pnames']);
    anchors = object.anchors;
    x2d = zeros(length(pnames),2);
    for i=1:length(pnames)
        eval(['x2dstatus = anchors.',pnames{i},'.status']);        
        if(x2dstatus ==1)
            eval(['x2d(i,:)=anchors.',pnames{i},'.location']);
        end        
    end    
    x2d = x2d(find(x2d(:,1)>0),:);
    xmin = min(x2d(:,1));
    xmax = max(x2d(:,1));
    ymin = min(x2d(:,2));
    ymax = max(x2d(:,2));
    
    bbox = [xmin xmax;ymin ymax];
end