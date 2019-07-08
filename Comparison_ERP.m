clear all; clc; close all; 

Subj=[1:19 21:28]; 
Cond={'31','32','33','34'};

%% compute averaged data

for i=1:length(Subj)
    setname=strcat('d',num2str(Subj(i)),'.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\8ar\';
    EEG= pop_loadset('filename',setname,'filepath',setpath); 
    EEG= eeg_checkset( EEG );
    for j=1:length(Cond)
        EEG_new = pop_epoch( EEG, Cond(j), [-0.2  1], 'newname', 'Merged datasets pruned with ICA   epochs epochs', 'epochinfo', 'yes'); 
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = pop_rmbase( EEG_new, [-200     0]); 
        EEG_new = eeg_checkset( EEG_new );
        EEG_avg(i,j,:,:)=squeeze(mean(EEG_new.data,3));  %% subj*cond*channel*timepoints
    end 
end

%% point-by-point repeated measures of ANOVA across time points

data_test=squeeze(EEG_avg(:,:,27,:)); %% select the data at Cz, data_test: subj*cond*time
for i=1:size(data_test,3)
    data_anova=squeeze(data_test(:,:,i)); %% select the data at time point i
    [p, table] = anova_rm(data_anova,'off');  %% perform repeated measures ANOVA  off关闭窗口
    P_anova(i)=p(1); %% save the data from ANOVA
    F_anova(i)=table{2,5};%%%table的信息
end

%%画P，F值
Cz=27;
mean_data=squeeze(mean(data_test,1)); %% dimension: cond*time，沿着被试平均
figure;plot(EEG.times, mean_data,'linewidth', 1.5); %% waveform for different condition 
set(gca,'YDir','reverse'); axis([-200 1000 -8 8]);
figure; 
subplot(211);plot(EEG.times,P_anova(1)); axis([-200 1000 0 0.05]); %% plot the p values from ANOVA
subplot(212);plot(EEG.times,F_anova(1)); xlim([-200 1000]); %axis([-500 1000 0 0.05]); %% plot the p values from ANOVA

%%  point-by-point paried t-test  across multiple time points 

data_test=squeeze(EEG_avg(:,:,13,:)); %% select the data at Cz, data_test: subj*cond*time
for i=1:size(data_test,3)
    data_1=squeeze(data_test(:,3,i)); %% select condition L3 for each time point
    data_2=squeeze(data_test(:,4,i)); %% select condition L4 for each time point
    [h,p,ci,stats]=ttest(data_1,data_2); %% ttest comparison
    P_ttest(i)=p; %% save the p value from ttest
    T_ttest(i)=stats.tstat; 
end
figure; plot(EEG.times,squeeze(mean(data_test(:,1,:),1)),'b'); %% plot the average waveform for Condition L3
hold on; plot(EEG.times,squeeze(mean(data_test(:,4,:),1)),'r'); %% plot the average waveform for Condition L4
figure; 
subplot(211); plot(EEG.times,P_ttest); axis([-500 1000 0 0.05]); 
subplot(212); plot(EEG.times,T_ttest); xlim([-500 1000]);

%% point-by-point paried t-test  across multiple channels

test_idx=find((EEG.times>=197)&(EEG.times<=217)); %% define the intervals
data_test=squeeze(mean(EEG_avg(:,:,:,test_idx),4)); %% select the data in [197 217]ms, subj*cond*channel
for i=1:size(data_test,3)
    data_1=squeeze(data_test(:,3,i)); %% select condition L3 for each channel
    data_2=squeeze(data_test(:,4,i)); %% select condition L4 for each channel
    [h,p,ci,stats]=ttest(data_1,data_2); %% ttest comparison
    P_ttest2(i)=p; %% save the p value from ttest
    T_ttest2(i)=stats.tstat; 
end
figure; 
subplot(221); 
topoplot(squeeze(mean(data_test(:,3,:),1)),EEG.chanlocs,'maplimits',[-20 20]); 
subplot(222); 
topoplot(squeeze(mean(data_test(:,4,:),1)),EEG.chanlocs,'maplimits',[-20 20]); 
subplot(223); 
topoplot(P_ttest2<fdr(P_ttest2,0.05),EEG.chanlocs); 
subplot(224); 
topoplot(T_ttest2,EEG.chanlocs); 

%% point-by-point repeated measures of ANOVA across channels

test_idx=find((EEG.times>=197)&(EEG.times<=217)); %% define the intervals
data_test=squeeze(mean(EEG_avg(:,:,:,test_idx),4)); %% select the data in [197 217]ms, subj*cond*channel
for i=1:size(data_test,3)
    data_anova=squeeze(data_test(:,:,i)); %% select the data at channel i
    [p, table] = anova_rm(data_anova,'off');  %% perform repeated measures ANOVA
    P_anova2(i)=p(1); %% save the data from ANOVA
    F_anova2(i)=table{2,5};
end
figure; 
for i=1:4
    subplot(1,6,i); 
    topoplot(squeeze(mean(data_test(:,i,:),1)),EEG.chanlocs,'maplimits',[-20 20]); 
end
subplot(1,6,5); topoplot( P_anova2,EEG.chanlocs); 
subplot(1,6,6); topoplot( F_anova2,EEG.chanlocs); 


