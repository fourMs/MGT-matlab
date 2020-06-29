function [retval,videoOut] = filter(obj,varargin)
%FILTER Summary of this function goes here


disp('this is the filter function');


arg = [];

%default parameters
arg.mg = [];
arg.fileList = [];
arg.filterflag = 0;
arg.filtertype = 'Regular';
arg.thresh = 0.1;
arg.color = 'off';
arg.invert = 'off';
arg.frameInterval = obj.frameInterval;
arg.fileCount = length(obj.video);

if(arg.fileCount <= 1)
    arg.startTime = obj.startTime;
    arg.stopTime = obj.stopTime;
end





for argi = 1:nargin-1


    
    if (strcmpi(varargin{argi},'Thresh'))
        if(argi + 1 <= nargin-1 &&  isnumeric(varargin{argi + 1}))
            arg.thresh = varargin{argi+1};
        end
    elseif (strcmpi(varargin{argi},'Color'))
        disp('color mode on is specified in argument');
        arg.color = 'on'
        if(argi + 1 <= nargin-1)
            if (strcmpi(varargin{argi+1},'off'))
                arg.color = 'off'
            elseif (strcmpi(varargin{argi+1},'on'))
                arg.color = 'on'
            end
        else
            arg.color = 'on'
        end
    elseif (strcmpi(varargin{argi},'Gray'))
        disp('color mode on is specified in argument');
        arg.color = 'off'
    elseif (strcmpi(varargin{argi},'invert'))
        disp('invert mode on is specified in argument');
        arg.invert = 'on'
    elseif (strcmpi(varargin{argi},'Interval'))
        if(argi + 1 <= nargin-1 &&  isnumeric(varargin{argi + 1}))
            arg.frameInterval = varargin{argi+1};
        end
    end
end


filtertype = arg.filtertype;
thresh = arg.thresh;
filterflag = 1;
colorflag = [];
invertflag = [];


if(strcmpi(arg.color, 'on'))
    colorflag = true;
else
    colorflag = false;
end


if(strcmpi(arg.invert, 'on'))
    invertflag = true;
else
    invertflag = false;
end


if(arg.fileCount <= 1)
    obj.mg.video.gram.y = [];
    obj.mg.video.gram.x = [];
    obj.mg.video.qom = [];
    obj.mg.video.com = [];
    obj.mg.video.aom = [];
    obj.mg.video.wom = [];
    obj.mg.video.hom = [];

    
    [filepath,filename,ext] = fileparts(obj.video.Name);
    newfile = strcat(filename,'_motion.avi');
    v = VideoWriter(newfile);
    v.FrameRate = obj.video.FrameRate;
    open(v);
    
    fh = figure('visible','off');

    obj.video.CurrentTime = arg.startTime;
    numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime);
    
    
    if colorflag == true
        fr1 = readFrame(obj.video);
    else
        fr1 = rgb2gray(readFrame(obj.video));
    end
    
    
    
 
    
    for i = 1:arg.frameInterval:numfr-1
        
        if colorflag == true
            fr2 = readFrame(obj.video);
        else
            fr2 = rgb2gray(readFrame(obj.video));
        end
        
        diff = abs(fr2-fr1);
        

        if colorflag == true
            
        else
             diff = abs(fr2-fr1);
            if filterflag
                diff = mgmotionfilter(diff,filtertype,thresh);
            end
        end
        

        
        if colorflag == true
            [com,qom] = mgcentroid(rgb2gray(diff));
        else
            [com,qom] = mgcentroid(diff);
        end
        
        
        
        obj.mg.video.qom = [obj.mg.video.qom;qom];
        obj.mg.video.com = [obj.mg.video.com;com];
        gramx = mean(diff);
        gramy = mean(diff,2);
        obj.mg.video.gram.y = [obj.mg.video.gram.y;gramx];
        obj.mg.video.gram.x = [obj.mg.video.gram.x,gramy];
        if invertflag == true
            diff = imcomplement(diff);
        end
        writeVideo(v,diff);
        fr1 = fr2;
        
        progmeter(obj.video.CurrentTime,obj.stopTime);
        obj.video.CurrentTime = arg.startTime + (1/obj.video.FrameRate)*i;
        
    end
    
  
    

    
else
    for fileIndex = 1:arg.fileCount
        
        
    end
    
end



end

