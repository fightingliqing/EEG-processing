% clear;clc

%% 新建一个文件夹，叫script720，然后把data.mat考进去
clear;
cd O:\huan-eeg\eegrawdata\所有人的实验数据

%% 把neuros的电极点位置转一下
load('data.mat');

% 找到正确的（BP）的58个电极点顺序
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
        for j=1:58  %修改第j行
          chan = channels{j};
          for k = 1:58   % k是电极点在的行标
              if strcmp(temp.header.chanlocs(k).labels,chan)
                    disp(strcat(num2str(i),':',num2str(j),'<->',num2str(k)));%打印要调换顺序的两行
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


% cd E:\时频分析\eegrawdata3;%注意这些路径

filenames={};
for i = 1:200
    str = lwdata(i).header.name;
    filenames{i} = strcat(lwdata(i).header.name,'_4plot');
    eeg = lwdata(i);
    eeg.Channels = channels;%上面第一步的channels
    save(strcat(filenames{i},'.mat'),'eeg');  
end



% file_nameCC： K的被试   file_nameSS：高应激的被试  file_nameSD：低应激的被试
file_nameCC = {};
for i = [61,65,69,1,5,13,17,21,29,33,37,49,53] %8需要修改，数量为K的被试个数*4
    file_nameCC{length(file_nameCC)+1} = {[strcat(filenames{i},'.mat')],...
                                        [strcat(filenames{i+1},'.mat')],...
                                        [strcat(filenames{i+2},'.mat')],...
                                        [strcat(filenames{i+3},'.mat')]};           
end
for i=2:13%后面的2需要改成K的被试数量。下同
file_nameCC{i}=cat(2,file_nameCC{i-1},file_nameCC{i});
end
file_nameCC=file_nameCC{13};                                

disp('file_name11里的文件有：')
for i = 1:length(file_nameCC)
    disp(file_nameCC{i});
end

% file_nameSS：高应激的被试
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

disp('file_name2里的文件有：')
for i = 1:length(file_nameSS)
    disp(file_nameSS{i});
end

% file_nameSD：低应激的被试
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

disp('file_name2里的文件有：')
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

%% 画图
chan={'CPz','CP1','CP3','CP5','Cz','C1','C3','C5',};

chan={'Pz'};
% chan={'CPz','P1','CP1','Pz','CP2','P2'};
% chan={'CPz','CP1','CP3','CP5'};
chan={'CP1','CP2','C2','C1','CPz','Cz'};
chan={'CPz','CP1','CP3','CP5','Cz','C1','C3','C5',};
chanlocs= channels;%上一个脚本的channels
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
 subplot(221);imagesc(t,f,squeeze(mean(tempsCCc1,3)));axis xy;colorbar;title('CC-c1');caxis([-0.8 0.8])%每个水平的时频分布图
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
 subplot(221);imagesc(t,f,squeeze(mean(tempsSSc1,3)));axis xy;colorbar;title('SS-c1');caxis([-0.8 0.8])%每个水平的时频分布图
 subplot(222);imagesc(t,f,squeeze(mean(tempsSSc2,3)));axis xy;colorbar;title('SS-c2');caxis([-0.8 0.8])
 subplot(223);imagesc(t,f,squeeze(mean(tempsSSe1,3)));axis xy;colorbar;title('SS-e1');caxis([-0.8 0.8])
 subplot(224);imagesc(t,f,squeeze(mean(tempsSSe2,3)));axis xy;colorbar;title('SS-e2');caxis([-0.8 0.8])

%group SD
tempsSDc1=squeeze(mean(datasSDc1(chan_idx,:,:,:),1));
tempsSDc2=squeeze(mean(datasSDc2(chan_idx,:,:,:),1));
tempsSDe1=squeeze(mean(datasSDe1(chan_idx,:,:,:),1));
tempsSDe2=squeeze(mean(datasSDe2(chan_idx,:,:,:),1));


 figure;hold on;
 subplot(221);imagesc(t,f,squeeze(mean(tempsSDc1,3)));axis xy;colorbar;title('SD-c1');caxis([-0.8 0.8])%每个水平的时频分布图
 subplot(222);imagesc(t,f,squeeze(mean(tempsSDc2,3)));axis xy;colorbar;title('SD-c2');caxis([-0.8 0.8])
 subplot(223);imagesc(t,f,squeeze(mean(tempsSDe1,3)));axis xy;colorbar;title('SD-e1');caxis([-0.8 0.8])
 subplot(224);imagesc(t,f,squeeze(mean(tempsSDe2,3)));axis xy;colorbar;title('SD-e2');caxis([-0.8 0.8])



