classdef DataExp
properties
  runNos    % 1D array of run numbers, e.g., '1:23'
  atoms     % name of atoms file
  probe     % name of probe file
  backg     % name of background file
  basepath  % full path where images are located
  dateFile  % date of images
  dataFolder% same as basepath, will be obsolete
  camera    % 'Andor','FleaH1' 
  pixCam    % pixel size camera plane [um]
  mag       % magnification of the imaging path
  bitDepth  % bit depth
  satCam    % camera saturation count #
  pixAtom   % pixel size atoms plane [um]
  pixNo     % # of pixels [row,col]
end

methods
  function obj = DataExp(dateFile, runNos, camera, basepath)
    % dateFile == YYYY/MM/DD
    % RunNo == 1D array of run numbers, e.g., '1:23'
    % basepath == full path where files are located
     
    if strcmp(camera,'Andor')==1
      obj.camera = 'Andor';
      obj.pixCam = 16;
      obj.mag = 39.9; % Calibration: 11/26/2019
      obj.bitDepth = 16;
      obj.satCam = 2^obj.bitDepth-1;
      obj.pixAtom = obj.pixCam/obj.mag;
      obj.basepath = basepath;
      obj.dataFolder = basepath;
      obj.dateFile = dateFile;
      obj.pixNo = [512,512];

      % Format runNos as row vector
      if isrow(runNos)==1
          obj.runNos = runNos;
      elseif iscolumn(runNos)==1
          obj.runNos = runNos';
      elseif isvector(runNos)==0
          error('runNos is not a vector as expected');
      end  

      % Return an error if the data folder doesn't exist
      if(exist(obj.dataFolder,'dir') ~= 7)
          error('Data Folder Does Not Exist');
      end

      str = {'Image','Probe','Background'};
      obj.atoms = strings(size(obj.runNos));
      obj.probe = strings(size(obj.runNos));
      obj.backg = strings(size(obj.runNos));
      
      iMax = max(size(obj.runNos));
      for ii = 1:iMax
          obj.atoms(ii) = strcat(str(1),'_',obj.dateFile,'_',num2str(obj.runNos(ii),'%04d'),'.tiff');
          obj.probe(ii) = strcat(str(2),'_',obj.dateFile,'_',num2str(obj.runNos(ii),'%04d'),'.tiff');
          obj.backg(ii) = strcat(str(3),'_',obj.dateFile,'_',num2str(obj.runNos(ii),'%04d'),'.tiff');
      end
    else
        error('DataExp::DataExp: Invalid camera.');
    end

  end
end
end
