KEYID_FILE = '/home/bbnc/databag/seq1_keyId.txt';
KEY_DATA_DIR = '/home/bbnc/databag/seq1_keydata_0';
IMG_DIR = '/home/bbnc/databag/seq1_keyimagesResize_0';

keyIds = load(KEYID_FILE);
keyIds = int16(keyIds);
mkdir(KEY_DATA_DIR);
for i = 1:length(keyIds)
    image_id = sprintf('left_%06d', keyIds(i)*5);
    filename = [image_id, '.jpg'];
    record = struct;
    record.folder = 'VOC2012';
    record.filename = filename; 
    record.database = 'The VOC2011 Database';
    record.source = struct('database', record.database, 'annotation', {'PASCAL VOC2011'}, 'image', {'flickr'});
    record.imgsize = [368,760,3];
    record.size = struct('width', record.imgsize(1), 'height', record.imgsize(2), 'depth', 3);
    record.segmented = false;
    record.imgname = [IMG_DIR,'/',filename];

    objects = struct;
    objects.class = 'car';
    objects.view = 'Rear';
    objects.truncated = 0;
    objects.occluded = 0;
    objects.difficult = false;
    objects.label  = 'PAScarRear';
    objects.orglabel = 'PAScarRear';
    objects.bbox = [0,0,1,1];
    objects.bndbox = struct('xmin', 0, 'ymin', 0, 'xmax',0, 'ymax',0);
    objects.polygon = [];
    objects.mask = [];
    objects.hasparts = false;
    objects.part = [];
    objects.point = [];
    objects.hasactions = false;
    objects.actions = [];

    anchor = struct('location',[], 'status',2);
    objects.anchors.left_front_wheel = anchor;
    objects.anchors.left_back_wheel = anchor;
    objects.anchors.right_front_wheel = anchor;
    objects.anchors.right_back_wheel = anchor;
    objects.anchors.upper_left_windshield = anchor;
    objects.anchors.upper_right_windshield = anchor;
    objects.anchors.upper_left_rearwindow = anchor;
    objects.anchors.upper_right_rearwindow = anchor;
    objects.anchors.left_front_light = anchor;
    objects.anchors.right_front_light = anchor;
    objects.anchors.left_back_trunk = anchor;
    objects.anchors.right_back_trunk = anchor;

    viewpoint = struct;
    viewpoint.azimuth_coarse = 190;
    viewpoint.elevation_coarse = 2.5;
    viewpoint.azimuth = 197;
    viewpoint.elevation = 8;
    viewpoint.distance = 3.399;
    viewpoint.focal = 1;
    viewpoint.px = 301.5;
    viewpoint.py = 173.68;
    viewpoint.theta = -10.112;
    viewpoint.error = 533.27;
    viewpoint.interval_azimuth = 0.1944;
    viewpoint.interval_elevation = 0.24123;
    viewpoint.num_anchor = 0;
    viewpoint.viewport = 355.943766;
    objects.viewpoint = viewpoint;

    objects.cad_index = 2;
    objects.subtype = 'race';
    objects.sublabel = 4;
    objects.subindex = 5;
    record.objects = objects;

    m = matfile([KEY_DATA_DIR,'/',image_id,'.mat'],'writable',true);
    m.record = record;

end