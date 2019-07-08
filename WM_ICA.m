clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\rawEEG';
if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end

outputDir = fullfile(baseDir, 'ica');
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

icaDir = fullfile(baseDir, 'icamat');
if ~exist(icaDir, 'dir'); mkdir(icaDir); end

%%%%%% preprocessing parameters
DS			= 250; % downsampling
HP 			= 1; 
LP          = 40;
MODEL 		= 'Spherical'; % channel loacation file type 'Spherical' or 'MNI'
rmChans	= {'VEO', 'HEOR', 'TP9', 'TP10'}; 
CHANTHRESH = 0.5;
%%% epoching parameters
REF			= {'TP9', 'TP10'};
ONREF 		= 'FCz';
CHANGE 	= true; % change event name
EPOCHTIME = [-0.2, 1]; % epoch time range
FROM 		= {'S  1', 'S  2', 'S  3'};
TO			= {'cued', 'uncued', 'neutral'};
STIM 		= FROM;
RESP 		= [];		

%%%%%% baseline parameter
BASE = [-200, 0];

%%% reject epochs parameters
thresh_chan = 0.05;
reject = 1;
thresh_param.low_thresh = -300;
thresh_param.up_thresh = 300;
trends_param.slope = 200;
trends_param.r2 = 0.2;
joint_param.single_chan = 8;
joint_param.all_chan = 4;
kurt_param.single_chan = 8;
kurt_param.all_chan = 4;
spectra_param.threshold = [-35, 35];
spectra_param.freqlimits = [20 40];

%%%%%% channel location files
% switch MODEL
% 	case 'MNI'
% 		locFile = 'standard_1005.elc';
% 	case 'Spherical'
% 		locFile = 'standard-10-5-cap385.elp';
% end
% locDir = dirname(which(locFile));

locDir = 'E:\Method_software\matlab\tools_matlab\tools\EEG\eeglab_dev\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';

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

	%%%%%% add channel locations
	EEG = pop_chanedit(EEG, 'lookup', locDir); % add channel location
	EEG = eeg_checkset(EEG);
    
	nChan = size(EEG.data, 1);
	EEG = pop_chanedit(EEG, 'append', nChan, ...
						'changefield',{nChan+1, 'labels', ONREF}, ...
						'lookup', locDir, ...
						'setref',{['1:',int2str(nChan+1)], ONREF}); % add online reference
	EEG = eeg_checkset(EEG);
	outStruct = chanLocCreate(ONREF, nChan+1);
	EEG = pop_reref(EEG, [], 'refloc', outStruct); % retain online reference data back
	EEG = eeg_checkset(EEG);
	EEG = pop_chanedit(EEG, 'lookup', locDir, 'setref',{['1:', int2str(size(EEG.data, 1))] 'average'});
	EEG = eeg_checkset(EEG);
	chanlocs = pop_chancenter(EEG.chanlocs, []);
	EEG.chanlocs = chanlocs;
	EEG = eeg_checkset(EEG);

	%%%%%% remove nonbrain channels
    if ~strcmp(REF, 'average')
        rmChansReal = setdiff(rmChans, REF);
    else
        rmChansReal = rmChans;
    end
    
    EEG = pop_select(EEG, 'nochannel', rmChansReal);
    EEG = eeg_checkset(EEG);
    
    EEG.etc.origChanlocs = EEG.chanlocs;
    
    chanLabels = {EEG.chanlocs.labels};

	%%%%%% downsampling to 250 Hz
	EEG = pop_resample(EEG, DS);
	EEG = eeg_checkset(EEG);

	%%%%%% high pass filtering: 1 Hz for better ica results, but not proper for erp study
	EEG = pop_eegfiltnew(EEG, HP, []); 
	EEG = eeg_checkset(EEG);
    % low pass filtering
    if ~isempty(LP)
        EEG = pop_eegfiltnew(EEG, [], LP);
        EEG = eeg_checkset(EEG);
    end
    
    	%%%%%% re-reference
	if strcmpi(REF, 'average')
		EEG = pop_reref(EEG, []);
	elseif iscellstr(REF)
		indRef = lix_elecfind(chanLabels, REF);
		EEG = pop_reref(EEG, indRef);
	end
	EEG = eeg_checkset(EEG);
    
    orig_chanlocs = EEG.chanlocs;

	%%%%%% remove bad channels( Christian's clean_artifacts)
	arg_flatline = 5; % default is 5; Maximum tolerated flatline duration. In seconds.
	arg_highpass = 'off'; %  Default: [0.25 0.75]
	arg_channel = CHANTHRESH; % default is 0.85; Minimum channel correlation
	arg_noisy = [];   % default: 4
	arg_burst = 'off';
	arg_window = 'off';
	EEGclean = clean_rawdata(EEG, ...
		arg_flatline, arg_highpass, arg_channel, arg_noisy, arg_burst, arg_window);
	chanLabels = {EEG.chanlocs.labels};
    if isfield(EEGclean.etc, 'clean_channel_mask')
        EEG.etc.badChanLabelsASR = chanLabels(~EEGclean.etc.clean_channel_mask);
        EEG.etc.badChanLabelsASR
        EEG = pop_select(EEG, 'nochannel', find(~EEGclean.etc.clean_channel_mask));
    else
        EEG.etc.badChanLabelsASR = {[]};
    end
	EEG = eeg_checkset(EEG);
    EEGclean = [];
    
    badchans = EEG.etc.badChanLabelsASR;
    
	%%%%%% change events
	EEG = readable_event(EEG, RESP, STIM, CHANGE, FROM, TO);
	
	%%%%%% epoch
    	if CHANGE
	    	MARKS = unique(TO);
    	else
	    	MARKS = unique(FROM);
    	end
	EEG = pop_epoch(EEG, MARKS, EPOCHTIME);
	EEG = eeg_checkset(EEG);
    
      % baseline-zero
    EEG = pop_rmbase(EEG, BASE);
    EEG = eeg_checkset(EEG);

    % reject epochs
   [EEG, info] = rej_epoch_auto(EEG, thresh_param, trends_param, spectra_param, ...
                                joint_param, kurt_param, thresh_chan, reject);

     %% run ica
    if isavg
        EEG = pop_runica(EEG, 'runica', 'extended', 1, 'pca', EEG.nbchan-1);
    else
        EEG = pop_runica(EEG, 'runica', 'extended', 1);
    end
    ica.icawinv = EEG.icawinv;
    ica.icasphere = EEG.icasphere;
    ica.icaweights = EEG.icaweights;
    ica.info = info;
    ica.info.badchans = badchans;
    ica.info.orig_chanlocs = orig_chanlocs;
    
    parsave(icaOutName, ica, 'ica', '-mat');

	%% save sets
	EEG.setname = strcat(ID{i}, '_ica');
    EEG = pop_saveset(EEG, 'filename', outName); % save set
    EEG = eeg_checkset( EEG ); 
    EEG = [];
    
    EEG = []; ALLEEG = []; CURRENTSET = [];
end

