classdef mgobject < mgmotion  & mgfilter & mgflow & mghistory & mgaverage
    %MGOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties  %(Access = {?musicalgesture, ?mgmotion, ?mgflow, ?mgfilter ?mghistory ?mgaverage})
        file
        video
        startTime
        stopTime
        color
        invert
        frameInterval
        mg
    end
    
    methods
        function obj = mgobject(f,varargin)
            
            %MGOBJECT Construct an instance of this class
            %   Detailed explanation goes here
            %obj.Property1 = inputArg1 + inputArg2;
            %disp({"YOUR FILE NAME IS" f});
            
            
            if(isa(f, 'VideoReader'))
                %disp('input is a single video object');
                cprintf('*green', 'loading file(s)\n');
                obj.video = f;
                obj.file = strcat(f.Path, '/' ,f.Name);
                obj.startTime = 0;
                obj.stopTime = f.Duration;
                obj.frameInterval = 1;
            elseif(iscell(f))
                %disp('input is a cell array of video objects');
                noOfFiles = length(f);
                cprintf('*green', 'loading file(s)\n');
                for i=1:noOfFiles
                    
                    if(isa(f{i}, 'VideoReader'))
                        obj.video{i} = f{i};
                        obj.file{i} = strcat(f{i}.Path, '/' ,f{i}.Name);
                        obj.startTime{i} = 0;
                        obj.stopTime{i} = f{i}.Duration;
                        obj.frameInterval{i} = 1;
                    end
                    
                    
                end
            elseif(ischar(f))
                %disp('input is file or folder');
                if exist(f, 'dir')
                    %disp('input is a directory');
                    files = dir(f);
                    fileCount = length(files);
                    validFileCount = 0;
                    cprintf('*green', 'loading file(s)\n');
                    for fileIndex= 1:fileCount
                        [~, ~, extension_i] = fileparts(files(fileIndex).name);
                        if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                            validFileCount = validFileCount + 1;
                            obj.file{validFileCount} = strcat(files(fileIndex).folder, '/' ,files(fileIndex).name);
                            disp(obj.file{validFileCount} );
                            obj.video{validFileCount} = VideoReader(obj.file{validFileCount} );
                            obj.startTime{validFileCount} = 0;
                            obj.stopTime{validFileCount} = obj.video{validFileCount}.Duration;
                            obj.frameInterval{validFileCount} = 1;
                        end
                    end
                else
                    %disp('checking if input is a valid file');
                    
                    if(exist(f))
                        %disp('file available');
                        cprintf('*green', 'loading file(s)\n');
                        [~, ~, extension_i] = fileparts(f);
                        if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                            obj.file = f;
                            disp(obj.file );
                            obj.video = VideoReader(obj.file );
                            obj.startTime = 0;
                            obj.stopTime = obj.video.Duration;
                            obj.frameInterval = 1;
                        end
                    else
                        %disp('file do not exist');
                        return;
                    end
                end
            end
            
            
            
            disp(length(obj.video));
            
            for argi = 1:nargin-1
                
                if (strcmpi(varargin{argi},'startTime'))
                    if(arg.fileCount <= 1)
                        
                        if(argi + 1 <= nargin-1)
                            disp('start time specified');
                            arg.startTime = varargin{argi+1};
                        end
                    else
                        cprintf('*orange', 'starttime cannot be defined when loading multiple files\n');
                    end
                    
                elseif (strcmpi(varargin{argi},'stopTime'))
                    if(arg.fileCount <= 1)
                        if(argi + 1 <= nargin-1)
                            disp('stop time specified');
                            arg.stopTime = varargin{argi+1};
                        end
                    else
                        cprintf('*orange', 'starttime cannot be defined when loading multiple files\n');
                    end
                end
                
            end
            
            %obj.file = f;
            %obj.video = VideoReader(obj.file);
            %obj.startTime = 0;
            %obj.stopTime = obj.video.Duration;
            %obj.color = [];
            %obj.invert = [];
            obj.frameInterval = 1;
            
            
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

