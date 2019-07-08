clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\rawEEG';
if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end

outputDir = fullfile(baseDir, 'epoch');
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

epochDir = fullfile(baseDir, 'epochmat');
if ~exist(epochDir, 'dir'); mkdir(epochDir); end

%%%%%% preprocessing parameters
DS			= 250; % downsampling
HP 			= 1; 
LP          = 40;
MODEL 		= 'Spherical'; % channel loacation file type 'Spherical' or 'MNI'
rmChans	= {'HEOL', 'HEOR', 'HEOG', 'HEO', ...
           'VEOD', 'VEO', 'VEOU', 'VEOG', ...
           'M1', 'M2', 'TP9', 'TP10'}; 
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
for i = 1:nFile
	%%%%%% prepare output filename  
	Name = strcat(ID{i}, '_Epoch.set');
	outName = fullfile(outputDir, Name);
    if exist(outName, 'file'); warning('files already exist'); continue; end
    
    epochName = strcat(ID{i}, '_epoch.mat');
	epochOutName = fullfile(epochDir, epochName);
     
	%%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);

	%% add channel locations
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
    
	%% remove nonbrain channels
    if ~strcmp(REF, 'average')
        rmChansReal = setdiff(rmChans, REF);
    else
        rmChansReal = rmChans;
    end
    
    EEG = pop_select(EEG, 'nochannel', rmChansReal);
    EEG = eeg_checkset(EEG);
    
    chanLabels = {EEG.chanlocs.labels};
    
    %% re-reference
	if strcmpi(REF, 'average')  
		EEG = pop_reref(EEG, []);  % ref: average
	elseif iscellstr(REF)
		indRef = lix_elecfind(chanLabels, REF);
		EEG = pop_reref(EEG, indRef);  % ref: REF
	end
	EEG = eeg_checkset(EEG);
    
    % 	%%%%%% downsampling to 250 Hz
% 	EEG = pop_resample(EEG, DS);
% 	EEG = eeg_checkset(EEG);
%     
    
	%% filtering
    %%% high pass filtering: 1 Hz for better ica results, but not proper for erp study
	EEG = pop_eegfiltnew(EEG, HP, []); 
	EEG = eeg_checkset(EEG);
    % low pass filtering
    if ~isempty(LP)
        EEG = pop_eegfiltnew(EEG, [], LP);
        EEG = eeg_checkset(EEG);
    end
    	
    EEG.etc.origchanlocs = EEG.chanlocs;
    
	%% remove bad channels( Christian's clean_artifacts)
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
    
%     % interpolate channels
%     EEG = pop_interp(EEG, EEG.etc.origchanlocs, 'spherical');
%     EEG = eeg_checkset(EEG);
    
    
    %% remove abundant marks
    EEG = lix_check_event(EEG, RESP, STIM);
    EEG = eeg_checkset(EEG);
    
    %%% epoch
    EEG = pop_epoch(EEG, FROM, EPOCHTIME, 'epochinfo', 'yes');
    EEG = eeg_checkset(EEG);
    
   
    
% 	%%%%%% change events.But this step ( funtion 'readable_event') could 
%   delete other marks which is	unrelated to the current event mark.

% 	EEG = readable_event(EEG, RESP, STIM, CHANGE, FROM, TO);
% 	
% 	%%%%%% epoch
%     	if CHANGE
% 	    	MARKS = unique(TO);
%     	else
% 	    	MARKS = unique(FROM);
%     	end
% 	EEG = pop_epoch(EEG, MARKS, EPOCHTIME);
% 	EEG = eeg_checkset(EEG);
%     
     
    %% baseline-zero
    EEG = pop_rmbase(EEG, BASE);
    EEG = eeg_checkset(EEG);
    
    epoch.event = EEG.event;
    epoch.types = {EEG.event.type}; % get all types
  
    parsave(epochOutName, epoch, 'epoch', '-mat');
    
    
    %% save epoch set

    EEG = pop_saveset(EEG, 'filename', outName); % save set
    EEG = eeg_checkset( EEG ); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
    
end

