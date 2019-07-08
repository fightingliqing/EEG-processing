Subj=[1:27];
for i=1:length(Subj)
    setname=strcat('d',num2str(i),'s1.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\sub\'; 
    EEG = pop_loadset('filename',setname,'filepath',setpath); 
    for nchan=1:EEG.nbchan; 
        x = squeeze(EEG.data(nchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data1(i,nchan,:,:)=squeeze(mean(P,3)); %% subject*channel*frequency*time
    end
     save(strcat('TFD_sub',num2str(i),'.mat'),'P_data1'); %% channel*frequency*time
end

t_pre_idx=find((t>=-0.45)&(t<=-0.05));
for i=1:size(P_data1,1)
    for j=1:size(P_data1,2)
        for k=1:size(P_data1,3)
            temp_data1=squeeze(P_data1(i,j,k,:));
            P_BC1(i,j,k,:)=temp_data1-mean(temp_data1(t_pre_idx)); %% subtraction
%             P_BC2(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/mean(temp_data(t_pre_idx));  %% percentage
%             P_BC3(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/std(temp_data(t_pre_idx));  %% Z score
        end
    end
 save(strcat('TFD_sub',num2str(i),'.mat'),'P_BC1');   
end





%%
clear all; clc;

Subj=[1:27];
for i=1:length(Subj)
    setname=strcat('d',num2str(i),'s2.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\sub\'; 
    EEG = pop_loadset('filename',setname,'filepath',setpath); 
    for nchan=1:EEG.nbchan; 
        x = squeeze(EEG.data(nchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data2(i,nchan,:,:)=squeeze(mean(P,3)); %% subject*channel*frequency*time
    end
     save(strcat('TFD_sub',num2str(i),'.mat'),'P_data2'); %% channel*frequency*time
    end

t_pre_idx=find((t>=-0.45)&(t<=-0.05));
for i=1:size(P_data2,1)
    for j=1:size(P_data2,2)
        for k=1:size(P_data2,3)
            temp_data2=squeeze(P_data2(i,j,k,:));
            P_BC2(i,j,k,:)=temp_data2-mean(temp_data2(t_pre_idx)); %% subtraction
%             P_BC2(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/mean(temp_data(t_pre_idx));  %% percentage
%             P_BC3(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/std(temp_data(t_pre_idx));  %% Z score
        end
    end
    save(strcat('TFD_sub',num2str(i),'.mat'),'P_BC2'); 
end



%%
clear all; clc;

Subj=[1:27];
for i=1:length(Subj)
    setname=strcat('d',num2str(i),'s3.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\sub\'; 
    EEG = pop_loadset('filename',setname,'filepath',setpath); 
    for nchan=1:EEG.nbchan; 
        x = squeeze(EEG.data(nchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data3(i,nchan,:,:)=squeeze(mean(P,3)); %% subject*channel*frequency*time
    end
    save(strcat('TFD_sub',num2str(i),'.mat'),'P_data3'); %% channel*frequency*time
    end

t_pre_idx=find((t>=-0.45)&(t<=-0.05));
for i=1:size(P_data3,1)
    for j=1:size(P_data3,2)
        for k=1:size(P_data3,3)
            temp_data3=squeeze(P_data3(i,j,k,:));
            P_BC3(i,j,k,:)=temp_data3-mean(temp_data3(t_pre_idx)); %% subtraction
%             P_BC2(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/mean(temp_data(t_pre_idx));  %% percentage
%             P_BC3(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/std(temp_data(t_pre_idx));  %% Z score
        end
    end
    save(strcat('TFD_sub',num2str(i),'.mat'),'P_BC3'); 
end



%%
clear all; clc;

Subj=[1:27];
for i=1:length(Subj)
    setname=strcat('d',num2str(i),'s4.set'); 
    setpath='F:\crf\实验\2017\monotonicity结论一屏\time_frequency\sub\'; 
    EEG = pop_loadset('filename',setname,'filepath',setpath); 
    for nchan=1:EEG.nbchan; 
        x = squeeze(EEG.data(EEG.nbchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 
        [S, P, F, U] = sub_stft(x, xtimes, t, f, Fs, winsize); 
        P_data4(i,nchan,:,:)=squeeze(mean(P,3)); %% subject*channel*frequency*time
    end
     save(strcat('TFD_sub',num2str(i),'.mat'),'P_data4'); %% channel*frequency*time
    end

t_pre_idx=find((t>=-0.45)&(t<=-0.05));
for i=1:size(P_data4,1)
    for j=1:size(P_data4,2)
        for k=1:size(P_data4,3)
            temp_data4=squeeze(P_data4(i,j,k,:));
            P_BC4(i,j,k,:)=temp_data4-mean(temp_data4(t_pre_idx)); %% subtraction
%             P_BC2(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/mean(temp_data(t_pre_idx));  %% percentage
%             P_BC3(i,j,k,:)=(temp_data-mean(temp_data(t_pre_idx)))/std(temp_data(t_pre_idx));  %% Z score
        end
    end
    save(strcat('TFD_sub',num2str(i),'.mat'),'P_BC4'); 
end


%% 
        
        x = squeeze(EEG.data(EEG.nbchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 


channel_plot=[8 10 12 17 19 21]; 
figure;  
for i=1:length(channel_plot) 
    subplot(3,2,2*i-1); imagesc(t,f,squeeze(mean(mean(P_data2(:,channel_plot,:,:),1),2))); axis xy; 
    hold on;  axis xy; caxis([0 5]); 
    subplot(3,2,2*i); imagesc(t,f,squeeze(mean(mean(P_BC2(:,channel_plot,:,:),1),2))); axis xy; 
    hold on;  axis xy;  caxis([-1 2]);
end


P_data34=P_data3-P_data4;
P_BC34=P_BC3-P_BC4;



channel_plot=[8 10 12 17 19 21]; 
figure;  
    subplot(2,1,1); imagesc(t,f,squeeze(mean(mean(P_data34(:,channel_plot,:,:),1),2))); axis xy; 
    hold on;  axis xy; caxis([0 4]); 
    subplot(2,1,2); imagesc(t,f,squeeze(mean(mean(P_BC34(:,channel_plot,:,:),1),2))); axis xy; 
    hold on;  axis xy;  caxis([-1 1]);




        x=squeeze(EEG.data(EEG.nbchan,:,:)); 
        xtimes=EEG.times/1000;  
        t=EEG.times/1000;
        f=0.1:0.5:40;
        Fs = EEG.srate;
        winsize = 0.200; 


ROI1_t=[-0.1 -0.4]; ROI1_f=[1 10];
ROI1_t_idx=find((t>=ROI1_t(1))&(t<=ROI1_t(2)));
ROI1_f_idx=find((f>=ROI1_f(1))&(f<=ROI1_f(2)));
TFD_plot=squeeze(mean(mean(mean(P_BC4(:,:,ROI1_f_idx,ROI1_t_idx),1),3),4)); %% chanel: 1*59
figure; topoplot(TFD_plot,EEG.chanlocs); title('ROI1 Magnitude','fontsize',16);
Central=[8 10 12 17 19 21]; 
ROI1_magntiude=squeeze(mean(mean(mean(P_BC4(:,Central,ROI1_f_idx,ROI1_t_idx),2),3),4)); 

ROI2_t=[0.5 1.5];ROI2_f=[8 13];
ROI2_t_idx=find((t>=ROI2_t(1))&(t<=ROI2_t(2)));
ROI2_f_idx=find((f>=ROI2_f(1))&(f<=ROI2_f(2)));
TFD_plot=squeeze(mean(mean(mean(P_BC4(:,:,ROI2_f_idx,ROI2_t_idx),1),3),4)); 
figure; topoplot(TFD_plot,EEG.chanlocs); title('ROI2 Magnitude','fontsize',16);
Cc=[28 29]; 
ROI2_magntiude=squeeze(mean(mean(mean(P_BC4(:,Cc,ROI2_f_idx,ROI2_t_idx),2),3),4)); 
