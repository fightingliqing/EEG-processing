clear, clc, close all

%%%%%% set directory
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\rawEEG';
outputDir = fullfile(baseDir, 'preprocessing');

epochDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epochmat\newres';

if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end
if ~exist(outputDir, 'dir'); mkdir(outputDir); end


%%%%%% preprocessing parameters
DS			= 250; % downsampling
HP 			= 0.1;  % 0.1 Hz for ERP
HP2 		= 1;    %1 Hz for ICA
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
	name = strcat(ID{i}, '_pre.set');
	outName = fullfile(outputDir, name);
    
    %%%%%% check if file exists
	if exist(outName, 'file'); warning('files already exist'); continue; end

	%%%%%% load dataset
	EEG = pop_loadset('filename', fileName{i}, 'filepath', inputDir);
	EEG = eeg_checkset(EEG);

	%% add channel locations
	EEG = pop_chanedit(EEG, 'lookup', locDir);                        % add channel location
	EEG = eeg_checkset(EEG);
    
	nChan = size(EEG.data, 1);
	EEG = pop_chanedit(EEG, 'append', nChan, ...
						'changefield',{nChan+1, 'labels', ONREF}, ...
						'lookup', locDir, ...
						'setref',{['1:',int2str(nChan+1)], ONREF});   % add online reference
	EEG = eeg_checkset(EEG);
	outStruct = chanLocCreate(ONREF, nChan+1);
	EEG = pop_reref(EEG, [], 'refloc', outStruct);                    % retain online reference data back
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
		EEG = pop_reref(EEG, []);
	elseif iscellstr(REF)
		indRef = lix_elecfind(chanLabels, REF);
		EEG = pop_reref(EEG, indRef);
	end
	EEG = eeg_checkset(EEG);
    
     EEG.etc.origchanlocs = EEG.chanlocs;
    

% 	%%%%%% downsampling to 250 Hz
% 	EEG = pop_resample(EEG, DS);
% 	EEG = eeg_checkset(EEG);

	 %% filtering
     %%%% low pass filtering
    EEG = pop_eegfiltnew(EEG, [], LP);
    EEG = eeg_checkset(EEG);
    
    EEG2 = EEG;

    %%%%%% high pass filtering: 0.1 Hz for erp study
	EEG = pop_eegfiltnew(EEG, HP, []); 
	EEG = eeg_checkset(EEG);

    %%%%%% high pass filtering:1 Hz for ICA
    EEG2 = pop_eegfiltnew(EEG2, HP2, []);  
    EEG2 = eeg_checkset(EEG2);
    
	%% remove bad channels( Christian's clean_artifacts)  
    arg_flatline = 5; % default is 5; Maximum tolerated flatline duration. In seconds.
	arg_highpass = 'off'; %  Default: [0.25 0.75]
	arg_channel = CHANTHRESH; % default is 0.85; Minimum channel correlation
	arg_noisy = [];   % default: 4
	arg_burst = 'off';
	arg_window = 'off';
	EEG2clean = clean_rawdata(EEG2, ...
		arg_flatline, arg_highpass, arg_channel, arg_noisy, arg_burst, arg_window);
	chanLabels = {EEG2.chanlocs.labels};
    if isfield(EEG2clean.etc, 'clean_channel_mask')
        EEG.etc.badChanLabelsASR = chanLabels(~EEG2clean.etc.clean_channel_mask);
        EEG.etc.badChanLabelsASR
        EEG = pop_select(EEG2, 'nochannel', find(~EEG2clean.etc.clean_channel_mask));
    else
        EEG.etc.badChanLabelsASR = {[]};
    end
	EEG = eeg_checkset(EEG);
    EEG2clean = [];
    EEG2 = [];
    

%    % interpolate channels
%     EEG = pop_interp(EEG, EEG.etc.origchanlocs, 'spherical');
%     EEG = eeg_checkset(EEG);
    
     %% remove abundant marks
    EEG = lix_check_event(EEG, RESP, STIM);
    EEG = eeg_checkset(EEG);
      
     %%% epoch.         
    EEG = pop_epoch(EEG, FROM, EPOCHTIME, 'epochinfo', 'yes');  % epochinfo:  Propagate event information into the new
                                                                % epoch structure {default: 'yes'}
    EEG = eeg_checkset(EEG);
      
    % load epochmat & apply new_mark
    epochFile = sprintf(epochfileName{i});
    data = load(fullfile(epochDir, epochFile));
    
    for kk = 1:576                                              % the number of epoch. e.g. 576
        EEG.epoch(1,kk).eventtype = data.epoch.types{kk};
        EEG.event(1,kk).type = data.epoch.types{kk};
    end  
    EEG = eeg_checkset( EEG ); 

      %% baseline-zero
    EEG = pop_rmbase(EEG, BASE);                                %  Empty or [] input -> Use whole epoch as baseline
    EEG = eeg_checkset(EEG);
    
     %% reject epochs
   [EEG, info] = rej_epoch_auto(EEG, thresh_param, trends_param, spectra_param, ...
                                joint_param, kurt_param, thresh_chan, reject);


     % save dataset
    EEG = pop_saveset(EEG, 'filename', outName); 
    EEG = []; ALLEEG = []; CURRENTSET = [];
end

