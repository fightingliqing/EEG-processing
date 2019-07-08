clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\preprocessing';
outputDir = fullfile(baseDir, 'preproEpoch');

epochDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epochmatRe';

if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end
if ~exist(outputDir, 'dir'); mkdir(outputDir); end


%%%%%% baseline parameter
BASE = [-200, 0];  % ms

%%%%%% channel location files
locDir = 'E:\Method_software\matlab\tools_matlab\tools\EEG\eeglab_dev\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';

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
	name = strcat(ID{i}, '_preEpoch.set');
	outName = fullfile(outputDir, name);
    
    %%%%%% check if file exists
	if exist(outName, 'file'); warning('files already exist'); continue; end

	%%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);

     % load epochmat & apply new_mark
    epochFile = sprintf(epochfileName{i});
    data = load(fullfile(epochDir, epochFile));
    
    for kk = 1:nFile                                              % the number of epoch. e.g. 576
        EEG.epoch(1,kk).eventtype = data.epoch.types{kk};
        EEG.event(1,kk).type = data.epoch.types{kk};
    end  
    EEG = eeg_checkset( EEG ); 

      %% baseline-zero
    EEG = pop_rmbase(EEG, BASE);                                %  Empty or [] input -> Use whole epoch as baseline
    EEG = eeg_checkset(EEG);

    EEG = pop_saveset(EEG, 'filename', outName); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
    
end

