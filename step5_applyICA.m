clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\preprocessing';
outputDir = fullfile(baseDir, 'postica');

icaTag = 'ica';
icaDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\icamat';

if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

%%%%%% baseline parameter
BASE = [-200, 0];  % ms

%%%%%% prepare datasets
tmp = dir(fullfile(inputDir, '*.set'));
fileName = natsort({tmp.name});
nFile = numel(fileName);
ID = get_prefix(fileName, 1);
ID = natsort(unique(ID));

icatmp = dir(fullfile(icaDir, '*.mat'));
icafileName = natsort({icatmp.name});
icaID = get_prefix(icafileName, 1);                       % get the icaID in the first position; unique
icaID = natsort(unique(icaID));

%%%%%% start for loop
for i = 1:nFile
	%%%%%% prepare output filename
	name = strcat(ID{i}, '_postica.set');
	outName = fullfile(outputDir, name);
    
    %%%%%% check if file exists
	if exist(outName, 'file'); warning('files already exist'); continue; end

	%%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);
    
    %%% load icamat
    icaFile = sprintf('%s_%s.mat', icaID{i}, icaTag);
    data = load(fullfile(icaDir, icaFile));
    ica = data.ica;
    
    %prepare parameter
     badchans = ica.info.badchans;
     orig_chanlocs = ica.info.orig_chanlocs
    
    %% apply ica .  reject ica componment by visual inspected and save the data_preprocessing
    EEG = apply_ica(EEG, ica)                                  %% EEG // ica_mat
     
    EEG.info = ica.info;
    EEG.info.badchans = badchans;
    EEG.info.orig_chanlocs = orig_chanlocs;
    
    EEG.icawinv = ica.icawinv;
    EEG.icasphere = ica.icasphere;
    EEG.icaweights = ica.icaweights;
  
     %% baseline-zero
    EEG = pop_rmbase(EEG, BASE);                                %  Empty or [] input -> Use whole epoch as baseline
    EEG = eeg_checkset(EEG);

    EEG = pop_saveset(EEG, 'filename', outName); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
end

