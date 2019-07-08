%%all channel,cond,sub时频语句
clear all; clc;

Subj=[1:27];
Cond={'31','32','33','34'};
for i=1:length(Subj)
    setname=strcat('d',num2str(Subj(i)),'.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\8ar\'; 
    EEG = pop_loadset('filename',setname,'filepath',setpath); 
   for j=1:length(Cond)
        EEG_new = pop_epoch( EEG, Cond(j), [-0.5  1.998], 'newname', 'Merged datasets pruned with ICA   epochs epochs', 'epochinfo', 'yes'); 
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = pop_rmbase( EEG_new, [-500     0]); 
        EEG_new = eeg_checkset( EEG_new );
        for nchan=1:EEG.nbchan; 
        x = squeeze(EEG.data(nchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data(i,j,nchan,:,:)=squeeze(mean(P,3)); %% subject*channel*frequency*time
        end
     %%%save(strcat('TFD_sub',num2str(i),'.mat'),'P_data1'); %% channel*frequency*time
    end
end




%% 多个条件一个电极点时频语句
clear all; clc;

Subj=[1:2];
Cond={'31','32','33','34'};

%% time-frequency analysis for multiple conditions

for i=1:length(Subj)
    setname=strcat('d',num2str(i),'.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\8ar\'; 
    EEG= pop_loadset('filename',setname,'filepath',setpath); 
    EEG= eeg_checkset( EEG );
    for j=1:length(Cond)
        EEG_new = pop_epoch( EEG, Cond(j), [-0.5  2], 'newname', 'Merged datasets pruned with ICA   epochs epochs', 'epochinfo', 'yes'); 
        EEG_new = eeg_checkset( EEG_new );
        EEG_new = pop_rmbase( EEG_new, [-500     0]); 
        EEG_new = eeg_checkset( EEG_new );
        for nchan=1:EEG.nbchan;
        x = squeeze(EEG_new.data(13,:,:)); 
        xtimes=EEG_new.times/1000; 
        t=EEG_new.times/1000;
        f=1:1:30; 
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data(i,j,nchan,:,:)=squeeze(P); %% subject*channel*frequency*time
       end
       end    
end

%% baseline correction 

t_pre_idx=find((t>=-0.8)&(t<=-0.2));
for i=1:size(P_data,1)
    for j=1:size(P_data,2)
        for ii=1:size(P_data,3)
            for jj=1:size(P_data,4)
                temp_data=squeeze(P_data(i,j,ii,jj,:));
                P_BC(i,j,ii,jj,:)=temp_data-mean(temp_data(t_pre_idx));
            end
        end
    end
end
%% ttest for each time-frequency point

data_test=squeeze(P_data(:,:,:,:)); %% select the data at Cz, data_test: subj*cond*frequency*time
for i=1:size(data_test,3)
    for j=1:size(data_test,4)
        data_1=squeeze(data_test(:,1,i,j)); %% select condition L3 for each time-frequency point
        data_2=squeeze(data_test(:,4,i,j)); %% select condition L4 for each time-frequency point
        [h,p,ci,stats]=ttest(data_1,data_2); %% ttest comparison
        P_ttest(i,j)=p; %% save the p value from ttest
        T_ttest(i,j)=stats.tstat; %% save the t value from ttest
    end
end

for i=1:size(data_test,3)
    for j=1:size(data_test,4)
        data_anova=squeeze(data_test(:,:,i,j)); %% select the data at time-frequency point
        [p, table] = anova_rm(data_anova,'off');  %% perform repeated measures ANOVA
        P_anova(i,j)=p(1); %% save the data from ANOVA
         F_anova(i,j)=table{2,5}; %% F value from ANOVA
    end
end

%% fdr correction to account for multiple comparisons

[p_fdr1, p_masked] = fdr(P_ttest, 0.05); %% fdr correction for p values from ttest
figure; imagesc(t,f,P_ttest); axis xy; caxis([0 0.05]); 

[p_fdr2, p_masked] = fdr(P_anova, 0.05);%% fdr correction for p values from ANOVA
figure; imagesc(t,f,P_anova); axis xy; caxis([0 0.05]); 

%% correlation with behavioral measures

Rating=[1:10];
data_test=squeeze(mean(P_data(:,:,13,:,:),2)); %% select the data at Cz, data_test: subj*frequency*time
for i=1:size(data_test,2)
    for j=1:size(data_test,3)
        data_anova=squeeze(data_test(:,i,j)); %% select the data at time-frequency point (i,j), Subj*1
        [r p]=corrcoef(data_anova,Rating); %% correlation (pearson)
        R_corr(i,j)=r(1,2);  %% save the r values
        P_corr(i,j)=p(1,2); %% save the p values
    end
end

[p_fdr3, p_masked] = fdr(P_corr, 0.05);%% fdr correction for p values from ANOVA
figure; imagesc(t,f,P_corr); axis xy; caxis([0 p_fdr3]); 



%%把几个矩阵合到一起
P_BC(1,:,:,:,:)=P_BC1(:,:,:,:);
P_BC(2,:,:,:,:)=P_BC2(:,:,:,:);
P_BC(3,:,:,:,:)=P_BC3(:,:,:,:);
P_BC(4,:,:,:,:)=P_BC4(:,:,:,:);


