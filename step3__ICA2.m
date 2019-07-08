% visual inspection and reject the bad epoch before use the ICA.mat.

clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epochRe';
if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end

outputDir = fullfile(baseDir, 'ica');
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

icaDir = fullfile(baseDir, 'icamat');
if ~exist(icaDir, 'dir'); mkdir(icaDir); end

%%% epoching parameters
REF			= {'TP9', 'TP10'};

%%% reject epochs parameters
% Abnormal values
thresh_param.low_thresh = -300;
thresh_param.up_thresh = 300;
% Abnormal trends
trends_param.slope = 200;
trends_param.r2 = 0.3;
% Abnormal Spectrum
spectra_param.threshold = [-35, 35];
spectra_param.freqlimits = [20 40];
% Joint Probability
joint_param.single_chan = 8;
joint_param.all_chan = 4;
% Kurtosis
kurt_param.single_chan = 8;
kurt_param.all_chan = 4;
% Reject channels by percentage of bad epoches in channel
thresh_chan = 1;

reject = 1;


%%%%%% prepare datasets
tmp = dir(fullfile(inputDir, '*.set'));
fileName = natsort({tmp.name});
nFile = numel(fileName);
ID = get_prefix(fileName, 1);
ID = natsort(unique(ID));

%%%%%% start for loop
parfor i = 1:nFile
	%%%%%% prepare output filename  
	Name = strcat(ID{i}, '_ica.set');
	outName = fullfile(outputDir, Name);
 
	icaName = strcat(ID{i}, '_ica.mat');
	icaOutName = fullfile(icaDir, icaName);
    
    ica = struct();
    if strcmp(REF, 'average')
        isavg = 1;
    else
        isavg = 0;
    end
   
	%%%%%% check if file exists
	if exist(outName, 'file'); warning('files already exist'); continue; end
	    
	%%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);
    
      %% reject epochs
   [EEG, info] = rej_epoch_auto(EEG, thresh_param, trends_param, spectra_param, ...
                                joint_param, kurt_param, thresh_chan, reject);


     %% initial parameter
     orig_chanlocs = EEG.chanlocs;
     badchans = EEG.etc.badChanLabelsASR;
     
    %% run ica
    if isavg
        EEG = pop_runica(EEG, 'runica', 'extended', 1, 'pca', EEG.nbchan-1);
    else
        EEG = pop_runica(EEG, 'runica', 'extended', 1);
    end
    ica.icawinv = EEG.icawinv;
    ica.icasphere = EEG.icasphere;
    ica.icaweights = EEG.icaweights;
    ica.icachansind = EEG.icachansind;  %channel indices
    
   
    ica.info.badchans = badchans;
    ica.info.orig_chanlocs = orig_chanlocs;
    
    parsave(icaOutName, ica, 'ica', '-mat');

	%% save sets
    EEG = pop_saveset(EEG, 'filename', outName); % save set
    EEG = eeg_checkset( EEG ); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
end

