% clear;clc

%% �½�һ���ļ��У���script720��Ȼ���data.mat����ȥ
clear;
cd O:\huan-eeg\eegrawdata\�����˵�ʵ������

%% ��neuros�ĵ缫��λ��תһ��
load('data.mat');

% �ҵ���ȷ�ģ�BP����58���缫��˳��
channels = {};
for i = 1:length(lwdata)
   if strcmp(lwdata(1,i).header.chanlocs(4).labels,'F1')
      for j=1:58
         channels{j} =  lwdata(1,i).header.chanlocs(j).labels;
      end
       break;
   end
end

orig = squeeze(lwdata(1,5).data(1,4,1,1,4,5:10));
for i = 1:length(lwdata)
    if ~strcmp(lwdata(1,i).header.chanlocs(4).labels,'F1')
        temp = lwdata(1,i);
        for j=1:58  %�޸ĵ�j��
          chan = channels{j};
          for k = 1:58   % k�ǵ缫���ڵ��б�
              if strcmp(temp.header.chanlocs(k).labels,chan)
                    disp(strcat(num2str(i),':',num2str(j),'<->',num2str(k)));%��ӡҪ����˳�������
                    temp.data(:,[j,k],:,:,:,:) = temp.data(:,[k,j],:,:,:,:);
                    temp.header.chanlocs(k).labels = temp.header.chanlocs(j).labels;
                    temp.header.chanlocs(j).labels = chan;
%                     break;
              end
          end
        end
       lwdata(1,i) = temp;
    end
end
moved = squeeze(lwdata(1,5).data(1,2,1,1,4,5:10));

%%
% clear;


% cd E:\ʱƵ����\eegrawdata3;%ע����Щ·��

filenames={};
for i = 1:200
    str = lwdata(i).header.name;
    filenames{i} = strcat(lwdata(i).header.name,'_4plot');
    eeg = lwdata(i);
    eeg.Channels = channels;%�����һ����channels
    save(strcat(filenames{i},'.mat'),'eeg');  
end



% file_nameCC�� K�ı���   file_nameSS����Ӧ���ı���  file_nameSD����Ӧ���ı���
file_nameCC = {};
for i = [61,65,69,1,5,13,17,21,29,33,37,49,53] %8��Ҫ�޸ģ�����ΪK�ı��Ը���*4
    file_nameCC{length(file_nameCC)+1} = {[strcat(filenames{i},'.mat')],...
                                        [strcat(filenames{i+1},'.mat')],...
                                        [strcat(filenames{i+2},'.mat')],...
                                        [strcat(filenames{i+3},'.mat')]};           
end
for i=2:13%�����2��Ҫ�ĳ�K�ı�����������ͬ
file_nameCC{i}=cat(2,file_nameCC{i-1},file_nameCC{i});
end
file_nameCC=file_nameCC{13};                                

disp('file_name11����ļ��У�')
for i = 1:length(file_nameCC)
    disp(file_nameCC{i});
end

% file_nameSS����Ӧ���ı���
file_nameSS = {};
for i = [89,121,149,185,197,73,81,105,109,117,125,153,161]
    file_nameSS{length(file_nameSS)+1} = {[strcat(filenames{i},'.mat')],...
                                        [strcat(filenames{i+1},'.mat')],...
                                        [strcat(filenames{i+2},'.mat')],...
                                        [strcat(filenames{i+3},'.mat')]};   
end
for i=2:13
file_nameSS{i}=cat(2,file_nameSS{i-1},file_nameSS{i});
end
file_nameSS=file_nameSS{13};

disp('file_name2����ļ��У�')
for i = 1:length(file_nameSS)
    disp(file_nameSS{i});
end

% file_nameSD����Ӧ���ı���
file_nameSD = {};
for i = [85,93,113,129,133,137,145,157,165,173,177,181,189]
    file_nameSD{length(file_nameSD)+1} = {[strcat(filenames{i},'.mat')],...
                                        [strcat(filenames{i+1},'.mat')],...
                                        [strcat(filenames{i+2},'.mat')],...
                                        [strcat(filenames{i+3},'.mat')]};   
end
for i=2:13
file_nameSD{i}=cat(2,file_nameSD{i-1},file_nameSD{i});
end
file_nameSD=file_nameSD{13};

disp('file_name2����ļ��У�')
for i = 1:length(file_nameSD)
    disp(file_nameSD{i});
end

%%group CC

idx=1;
t=-598:2:998;   
f=1:0.58:30;  

for i=1:4:length(file_nameCC)   
    load(file_nameCC{i});
    datasCCc1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameCC{i+1});
    datasCCc2(:,:,:,idx)=squeeze(eeg.data);
       
    load(file_nameCC{i+2});
    datasCCe1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameCC{i+3});
    datasCCe2(:,:,:,idx)=squeeze(eeg.data);

    idx=idx+1;
end

%%group SS

idx=1;
for i=1:4:length(file_nameSS)  

    load(file_nameSS{i});
    datasSSc1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameSS{i+1});
    datasSSc2(:,:,:,idx)=squeeze(eeg.data);
       
    load(file_nameSS{i+2});
    datasSSe1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameSS{i+3});
    datasSSe2(:,:,:,idx)=squeeze(eeg.data);

    idx=idx+1;
end

%%group SD

idx=1;
for i=1:4:length(file_nameSD)  

    load(file_nameSD{i});
    datasSDc1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameSD{i+1});
    datasSDc2(:,:,:,idx)=squeeze(eeg.data);
       
    load(file_nameSD{i+2});
    datasSDe1(:,:,:,idx)=squeeze(eeg.data);
 
    load(file_nameSD{i+3});
    datasSDe2(:,:,:,idx)=squeeze(eeg.data);

    idx=idx+1;
end

%% ��ͼ
chan={'CPz','CP1','CP3','CP5','Cz','C1','C3','C5',};

chan={'Pz'};
% chan={'CPz','P1','CP1','Pz','CP2','P2'};
% chan={'CPz','CP1','CP3','CP5'};
chan={'CP1','CP2','C2','C1','CPz','Cz'};
chan={'CPz','CP1','CP3','CP5','Cz','C1','C3','C5',};
chanlocs= channels;%��һ���ű���channels
for i=1:length(chan)
    for j=1:length(chanlocs)
        if strcmp(chan{i},chanlocs(j))
            chan_idx(i)=j;
        end
    end
end

%group CC
tempsCCc1=squeeze(mean(datasCCc1(chan_idx,:,:,:),1));
tempsCCc2=squeeze(mean(datasCCc2(chan_idx,:,:,:),1));
tempsCCe1=squeeze(mean(datasCCe1(chan_idx,:,:,:),1));
tempsCCe2=squeeze(mean(datasCCe2(chan_idx,:,:,:),1));


 figure;hold on;
 subplot(221);imagesc(t,f,squeeze(mean(tempsCCc1,3)));axis xy;colorbar;title('CC-c1');caxis([-0.8 0.8])%ÿ��ˮƽ��ʱƵ�ֲ�ͼ
 subplot(222);imagesc(t,f,squeeze(mean(tempsCCc2,3)));axis xy;colorbar;title('CC-c2');caxis([-0.8 0.8])
 subplot(223);imagesc(t,f,squeeze(mean(tempsCCe1,3)));axis xy;colorbar;title('CC-e1');caxis([-0.8 0.8])
 subplot(224);imagesc(t,f,squeeze(mean(tempsCCe2,3)));axis xy;colorbar;title('CC-e2');caxis([-0.8 0.8])

%group SS
tempsSSc1=squeeze(mean(datasSSc1(chan_idx,:,:,:),1));
tempsSSc2=squeeze(mean(datasSSc2(chan_idx,:,:,:),1));
tempsSSe1=squeeze(mean(datasSSe1(chan_idx,:,:,:),1));
tempsSSe2=squeeze(mean(datasSSe2(chan_idx,:,:,:),1));

% 
 figure;hold on;
 subplot(221);imagesc(t,f,squeeze(mean(tempsSSc1,3)));axis xy;colorbar;title('SS-c1');caxis([-0.8 0.8])%ÿ��ˮƽ��ʱƵ�ֲ�ͼ
 subplot(222);imagesc(t,f,squeeze(mean(tempsSSc2,3)));axis xy;colorbar;title('SS-c2');caxis([-0.8 0.8])
 subplot(223);imagesc(t,f,squeeze(mean(tempsSSe1,3)));axis xy;colorbar;title('SS-e1');caxis([-0.8 0.8])
 subplot(224);imagesc(t,f,squeeze(mean(tempsSSe2,3)));axis xy;colorbar;title('SS-e2');caxis([-0.8 0.8])

%group SD
tempsSDc1=squeeze(mean(datasSDc1(chan_idx,:,:,:),1));
tempsSDc2=squeeze(mean(datasSDc2(chan_idx,:,:,:),1));
tempsSDe1=squeeze(mean(datasSDe1(chan_idx,:,:,:),1));
tempsSDe2=squeeze(mean(datasSDe2(chan_idx,:,:,:),1));


 figure;hold on;
 subplot(221);imagesc(t,f,squeeze(mean(tempsSDc1,3)));axis xy;colorbar;title('SD-c1');caxis([-0.8 0.8])%ÿ��ˮƽ��ʱƵ�ֲ�ͼ
 subplot(222);imagesc(t,f,squeeze(mean(tempsSDc2,3)));axis xy;colorbar;title('SD-c2');caxis([-0.8 0.8])
 subplot(223);imagesc(t,f,squeeze(mean(tempsSDe1,3)));axis xy;colorbar;title('SD-e1');caxis([-0.8 0.8])
 subplot(224);imagesc(t,f,squeeze(mean(tempsSDe2,3)));axis xy;colorbar;title('SD-e2');caxis([-0.8 0.8])



