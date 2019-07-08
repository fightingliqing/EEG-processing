clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epoch';
if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end


outputDir = fullfile(baseDir, 'epochRe');
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

epochDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epochmat\newres';

%%%%%% prepare datasets
tmp = dir(fullfile(inputDir, '*.set'));
fileName = natsort({tmp.name});
nFile = numel(fileName);
ID = get_prefix(fileName, 1);
ID = natsort(unique(ID));


epochtmp = dir(fullfile(epochDir, '*.mat'));
epochfileName = natsort({epochtmp.name});
%epochID = get_prefix(epochfileName, 1);  % get the icaID in the first position; unique


%%%%%% start for loop
for i = 1:nFile
	%%%%%% prepare output filename  
	Name = strcat(ID{i}, '_epochRe.set');
	outName = fullfile(outputDir, Name);
	if exist(outName, 'file'); warning('files already exist'); continue; end
    
   %%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);
    
    %%% load epochmat
    epochFile = sprintf(epochfileName{i});
    data = load(fullfile(epochDir, epochFile));
    
    for kk = 1:576
        EEG.epoch(1,kk).eventtype = data.epoch.types{kk};
        EEG.event(1,kk).type = data.epoch.types{kk};
    end  
    EEG = eeg_checkset( EEG ); 
    
    
    
    %% save sets
    EEG = pop_saveset(EEG, 'filename', outName); % save set
    EEG = eeg_checkset( EEG ); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
end