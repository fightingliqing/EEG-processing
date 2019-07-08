% function iris_study
clear, clc
baseDir = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab';
inputDir = fullfile(baseDir, 'postica');
if ~exist(inputDir, 'dir'); disp('inputDir does not exist\n please reset it'); return; end

outputDir = fullfile(baseDir, 'study');
if ~exist(outputDir, 'dir'); mkdir(outputDir); end

%%%%%% study parameters
nameStudy = 'WM_attention.study';
nameTask = 'search task';
noteStudy = '0.1-40Hz, mastoid; V bad epoch and ICA';
dipselect = [];
inbrain = [];

%%%%%% study design parameters
cued = {'S  3','S  6'};
uncued = {'S  4','S  8'};
neutral = {'S  5','S  10'};
V1 = {'cued', 'uncued', 'neutral'};
% V1 = {'S  3', 'S  4', 'S  5','S  6', 'S  8', 'S  10'};
% V2 = {'high_freq', 'low_freq'};
% HF = {'s1','s2','s3','s4','s6','s8','s9','s11','s14','s16','s23','s24','s26','s27','s29','s31','s34','s35','s37','s38'};
% LF = {'s5','s7','s10','s12','s13','s15','s17','s18','s19','s20','s21','s22','s25','s28','s30','s32','s33','s36','s39','S40'};

%%%%%%% prepare data
tmp = dir(fullfile(inputDir, '*.set'));
fileName = natsort({tmp.name});
ID = get_prefix(fileName, 1);
tagGroup = cell(numel(ID), 1);
%g1 = ismember(ID, HF);
%g2 = ismember(ID, LF);
%tagGroup(g1) = V2(1);
%tagGroup(g2) = V2(2);

%%%%%%% load sets
ALLEEG = []; EEG = []; STUDY = [];
EEG = pop_loadset('filename', fileName, 'filepath', inputDir);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'study',0);

% create studycommands cell arrays
studycommands = cell(size(fileName));
% for i = 1:numel(fileName)
% 	studycommands{i} = {'index', i, ...
% 							'subject', ID{i}, ...
% 							'group', tagGroup{i}};
% end

for i = 1:numel(fileName)
    studycommands{i} = {'index', i, ...
        'subject', ID{i}};
end

% if ~isempty(inbrain) && ~isempty(dipselect)
% 	studycommands = {studycommands{:}, {'inbrain', inbrain, 'dipselect', dipselect}};
% end

%%%%%%% create study
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, ...
    'name', nameStudy, ...
    'task', nameTask, ...
    'notes', noteStudy, ...
    'commands', studycommands, ...
    'updatedat', 'on');

%%%%%%% change design
% STUDY = std_makedesign(STUDY, ALLEEG, 1, ...
% 							'variable1', 'type', 'pairing1', 'on', ...
% 							'variable2', 'group', 'pairing2', 'off', ...
% 							'values1', V1, ...
% 							'values2', V2, ...
% 							'filepath', outputDir);
STUDY = std_makedesign(STUDY, ALLEEG, 1, ...      % apply only to at most two (paired or unpaired) factors.
    'variable1', 'condition', 'pairing1', 'on', ...
    'values1', V1, ...
    'filepath', outputDir);

%%%%%%% save study
STUDY = pop_savestudy(STUDY, EEG, 'filename', nameStudy, 'filepath', outputDir);