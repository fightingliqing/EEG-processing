%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group CC    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

%data_new(�������������������缫������Ƶ��ֵ������ʱ���),
condition={'c1','c2','e1','e2'};
for i = 1:(length(file_nameCC)/4)
    for j = 1:4 %����
       load(file_nameCC{(i-1)*4+j});
       topoCC_new (j,i,:,:,:) = squeeze(eeg.data);
    end
end

avg=squeeze((mean(topoCC_new,2)));
tlim=[-0.55 -0.15];
t=-0.6:1/500:1.0-1/500;
f=1:29/49:30;
tindex=find(t>=tlim(1) & t<=tlim(2));

%data_new(�������������������缫������Ƶ��ֵ������ʱ���)
dataCC_base = topoCC_new;
tlim1=[0.2 0.6];
flim1=[8 12];
tindex1=find(t>=tlim1(1) & t<=tlim1(2));
findex1=find(f>=flim1(1) & f<=flim1(2));
dataCC=dataCC_base(:,:,:,findex1,tindex1);%tlim1ʱ��Σ�flim1Ƶ��
ERO1=squeeze(mean(mean(mean(dataCC,4),5),2));%����Ƶ��ƽ��������ʱ���ƽ����������ƽ�����õ������� ����*�缫�� ��ֵ
%ERO:4������*58���缫�㣬ERO(1,:)���ǵ�һ�������£����е缫�������



%��eeglab
%��һ��
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 4;
EEGt.xmax = -0.594;
EEGt.data = ones(58,4,1);
for i = 1:4
    for j = 1:58
        EEGt.data(j,i,1) = ERO1(i,j);
    end
end

pop_topoplot(EEGt,1,[-600 -598 -596 -594],  'all type',[1 4] ,0, 'electrodes', 'off','maplimits',[-0.8 0.8]  );%ÿ��������topo


for i=1:size(EEGt.data,3)
       EEGt.data(:,1,i)=(ERO1(2,:)-ERO1(1,:))/2+(ERO1(4,:)-ERO1(3,:))/2; %control main effects    
end
pop_topoplot(EEGt,1, [-600 -598] , 'QHCC',[1 2] ,0, 'electrodes', 'off', 'maplimits',[-0.1 0.1] );%every 2 ms


for i=1:size(EEGt.data,3)
   EEGt.data(:,1,i)=(ERO1(3,:)-ERO1(1,:))/2+(ERO1(4,:)-ERO1(2,:))/2; %EC effects    
    
end
pop_topoplot(EEGt,1, [-600 -598], 'ECCC',[1 2] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
  EEGt.data(:,1,i)=(ERO1(4,:)-ERO1(2,:))/2-(ERO1(3,:)-ERO1(1,:))/2; %Interaction effects
    
end
pop_topoplot(EEGt,1, [-600 -598] , 'InterCC',[1 2],0, 'electrodes', 'on', 'maplimits',[-0.2 0.2] );%every 2 ms


for i=1:size(EEGt.data,3) 
        EEGt.data(:,1,i)=(ERO1(3,:)-ERO1(1,:)); %ǰ������
end
pop_topoplot(EEGt,1, [-600 -598] , 'QCC',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO1(4,:)-ERO1(2,:)); %�������
end
pop_topoplot(EEGt,1, [-600 -598] , 'HCC',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO1(4,:)-ERO1(3,:)); %����
end
pop_topoplot(EEGt,1, [-600 -598] , 'errorCC',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO1(2,:)-ERO1(1,:)); %��ȷ
end
pop_topoplot(EEGt,1, [-600 -598] , 'correctCC',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms
%
%
%

%% ��CC��F value

data4anovaCC= squeeze(mean(mean(dataCC_base(:,:,:,findex1,tindex1),4),5));
FvaluesCC = zeros(1,58);
FpvaluesCC = zeros(1,58);
FdatasCC = zeros(1,60);
Fg1 = {};
for i = 1:30
    Fg1{1,i} = 'c'
end
for i = 31:60
    Fg1{1,i} = 'e'
end
Fg2 = [ones(1,15) 2*ones(1,15) ones(1,15) 2*ones(1,15)];
for i = 1:58
    for j = 1:15      
        FdatasCC(1,j) = data4anovaCC(1,j,i);
        FdatasCC(1,j+15) = data4anovaCC(2,j,i);
        FdatasCC(1,j+30) = data4anovaCC(3,j,i);
        FdatasCC(1,j+45) = data4anovaCC(4,j,i);
    end
    
    [p,table,stats] = anovan(FdatasCC,{Fg1,Fg2},'model','interaction');
    FvaluesCC(1,i) = table{4,6};%F
    FpvaluesCC(1,i) = table{4,7};%P
end

% plot F-value interaction
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%F
 for j = 1:58
     EEGt.data(j,1,1) = FvaluesCC(1,j);%F
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 2]  );%ÿ��������topo

%p
for j = 1:58
     EEGt.data(j,1,1) = FpvaluesCC(1,j);%P
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo

%% CC��t����
Ttestc2c1=zeros(1,58);
Tteste1c1=zeros(1,58);
Tteste2c2=zeros(1,58);
Tteste2e1=zeros(1,58);

for i = 1:58
    Ttestc1=squeeze(data4anovaCC(1,:,i));
    Ttestc2=squeeze(data4anovaCC(2,:,i));
    Tteste1=squeeze(data4anovaCC(3,:,i));
    Tteste2=squeeze(data4anovaCC(4,:,i));
    
    [h,p,ci,stats] = ttest(Tteste1,Ttestc1);
    Tteste1c1(1,i)=p;
    Tteste1c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Ttestc2);
    Tteste2c2(1,i)=p;
    Tteste2c2(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Ttestc2,Ttestc1);
    Ttestc2c1(1,i)=p;
    Ttestc2c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Tteste1);
    Tteste2e1(1,i)=p;
    Tteste2e1(2,i)=stats.tstat;   
end

% plot
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%p
 for j = 1:58
     EEGt.data(j,1,1) = Tteste1c1(1,j);%ǰ��
 end
pop_topoplot(EEGt,1,[-600 -598],  'e1c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo

 for j = 1:58
     EEGt.data(j,1,1) = Tteste2c2(1,j);%���
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2c2',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo
 for j = 1:58
     EEGt.data(j,1,1) = Ttestc2c1(1,j);%��ȷ
 end
pop_topoplot(EEGt,1,[-600 -598],  'c2c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo
 for j = 1:58
     EEGt.data(j,1,1) = Tteste2e1(1,j);%����
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2e1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo


%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group SS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

%data_new(�������������������缫������Ƶ��ֵ������ʱ���),����Ҫ���е缫�㣬���Բ��ã���
condition={'c1','c2','e1','e2'};
for i = 1:(length(file_nameSS)/4)
    for j = 1:4 %����
       load(file_nameSS{(i-1)*4+j});
       topoSS_new (j,i,:,:,:) = squeeze(eeg.data);
    end
end

avg=squeeze((mean(topoSS_new,2)));
tlim=[-0.55 -0.15];
t=-0.6:1/500:1.0-1/500;
f=1:29/49:30;
tindex=find(t>=tlim(1) & t<=tlim(2));


%data_new(�������������������缫������Ƶ��ֵ������ʱ���)
dataSS_base = topoSS_new;
tlim1=[-0.1 0.3];
flim1=[5 7];
tindex1=find(t>=tlim1(1) & t<=tlim1(2));
findex1=find(f>=flim1(1) & f<=flim1(2));
dataSS=dataSS_base(:,:,:,findex1,tindex1);%tlim1ʱ��Σ�flim1Ƶ��
ERO2=squeeze(mean(mean(mean(dataSS,4),5),2));%����Ƶ��ƽ��������ʱ���ƽ����������ƽ�����õ������� ����*�缫�� ��ֵ
%ERO:4������*58���缫�㣬ERO(1,:)���ǵ�һ�������£����е缫�������



%��eeglab
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 4;
EEGt.xmax = -0.594;
EEGt.data = ones(58,4,1);
for i = 1:4
    for j = 1:58
        EEGt.data(j,i,1) = ERO2(i,j);
    end
end
pop_topoplot(EEGt,1,[-600 -598 -596 -594],  'all type',[1 4] ,0, 'electrodes', 'off','maplimits',[-0.4 0.4] );%ÿ��������topo


for i=1:size(EEGt.data,3)
       EEGt.data(:,1,i)=(ERO2(2,:)-ERO2(1,:))/2+(ERO2(4,:)-ERO2(3,:))/2; %STRESS main effects    
end
pop_topoplot(EEGt,1, [-600 -598] , 'QHSS',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms


for i=1:size(EEGt.data,3)
   EEGt.data(:,1,i)=(ERO2(3,:)-ERO2(1,:))/2+(ERO2(4,:)-ERO2(2,:))/2; %EC effects    
    
end
pop_topoplot(EEGt,1, [-600 -598] , 'ECSS',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
  EEGt.data(:,1,i)=(ERO2(4,:)-ERO2(2,:))/2-(ERO2(3,:)-ERO2(1,:))/2; %Interaction effects
    
end
pop_topoplot(EEGt,1, [-600 -598] , 'InterSS',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.2 0.2] );%every 2 ms


for i=1:size(EEGt.data,3) 
        EEGt.data(:,1,i)=(ERO2(3,:)-ERO2(1,:)); %��������Ķ�һ��������Ĳ���
end
 pop_topoplot(EEGt,1, [-600 -598] , 'QSS',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO2(4,:)-ERO2(2,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'HSS',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO2(4,:)-ERO2(3,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'errorSS',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO2(2,:)-ERO2(1,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'correctSS',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms
%
%
%
%
%% ��SS��F value

data4anovaSS= squeeze(mean(mean(dataSS_base(:,:,:,findex1,tindex1),4),5));
FvaluesSS = zeros(1,58);
FpvaluesSS = zeros(1,58);
FdatasSS = zeros(1,52);%13*4?
Fg1 = {};
for i = 1:26
    Fg1{1,i} = 'c'
end
for i = 27:52
    Fg1{1,i} = 'e'
end
Fg2 = [ones(1,13) 2*ones(1,13) ones(1,13) 2*ones(1,13)];
for i = 1:58
    for j = 1:13      
        FdatasSS(1,j) = data4anovaSS(1,j,i);
        FdatasSS(1,j+13) = data4anovaSS(2,j,i);
        FdatasSS(1,j+26) = data4anovaSS(3,j,i);
        FdatasSS(1,j+39) = data4anovaSS(4,j,i);
    end
    
    [p,table,stats] = anovan(FdatasSS,{Fg1,Fg2},'model','interaction');
    FvaluesSS(1,i) = table{4,6};%F
    FpvaluesSS(1,i) = table{4,7};%P
end

% plot F-value interaction
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%F
 for j = 1:58
     EEGt.data(j,1,1) = FvaluesSS(1,j);%F
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 2]  );%ÿ��������topo

%p
for j = 1:58
     EEGt.data(j,1,1) = FpvaluesSS(1,j);%P
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.1] );%ÿ��������topo


%% SS��t����
Ttestc2c1=zeros(1,58);
Tteste1c1=zeros(1,58);
Tteste2c2=zeros(1,58);
Tteste2e1=zeros(1,58);

for i = 1:58
    Ttestc1=squeeze(data4anovaSS(1,:,i));
    Ttestc2=squeeze(data4anovaSS(2,:,i));
    Tteste1=squeeze(data4anovaSS(3,:,i));
    Tteste2=squeeze(data4anovaSS(4,:,i));
    
    [h,p,ci,stats] = ttest(Tteste1,Ttestc1);
    Tteste1c1(1,i)=p;
    Tteste1c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Ttestc2);
    Tteste2c2(1,i)=p;
    Tteste2c2(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Ttestc2,Ttestc1);
    Ttestc2c1(1,i)=p;
    Ttestc2c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Tteste1);
    Tteste2e1(1,i)=p;
    Tteste2e1(2,i)=stats.tstat;    
end

% plot
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%p
 for j = 1:58
     EEGt.data(j,1,1) = Tteste1c1(1,j);%ǰ��
 end
pop_topoplot(EEGt,1,[-600 -598],  'e1c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo

 for j = 1:58
     EEGt.data(j,1,1) = Tteste2c2(1,j);%���
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2c2',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo

 for j = 1:58
     EEGt.data(j,1,1) = Ttestc2c1(1,j);%��ȷ
 end
pop_topoplot(EEGt,1,[-600 -598],  'c2c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo

 for j = 1:58
     EEGt.data(j,1,1) = Tteste2e1(1,j);%����
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2e1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.01]  );%ÿ��������topo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group SD   %%%%%%%%%%%%%%%%%%%%%p%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

%data_new(�������������������缫������Ƶ��ֵ������ʱ���),����Ҫ���е缫�㣬���Բ��ã���
condition={'c1','c2','e1','e2'};
for i = 1:(length(file_nameSD)/4)
    for j = 1:4 %����
       load(file_nameSD{(i-1)*4+j});
       topoSD_new (j,i,:,:,:) = squeeze(eeg.data);
    end
end

avg=squeeze((mean(topoSD_new,2)));
tlim=[-0.55 -0.15];
t=-0.6:1/500:1.0-1/500;
f=1:29/49:30;
tindex=find(t>=tlim(1) & t<=tlim(2));


%data_new(�������������������缫������Ƶ��ֵ������ʱ���)
dataSD_base = topoSD_new;
tlim1=[-0.1 0.3];
flim1=[5 7];
tindex1=find(t>=tlim1(1) & t<=tlim1(2));
findex1=find(f>=flim1(1) & f<=flim1(2));
dataSD=dataSD_base(:,:,:,findex1,tindex1);%tlim1ʱ��Σ�flim1Ƶ��
ERO3=squeeze(mean(mean(mean(dataSD,4),5),2));%����Ƶ��ƽ��������ʱ���ƽ����������ƽ�����õ������� ����*�缫�� ��ֵ
%ERO:4������*58���缫�㣬ERO(1,:)���ǵ�һ�������£����е缫�������



%��eeglab
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 4;
EEGt.xmax = -0.594;
EEGt.data = ones(58,4,1);
for i = 1:4
    for j = 1:58
        EEGt.data(j,i,1) = ERO3(i,j);
    end
end
pop_topoplot(EEGt,1,[-600 -598 -596 -594],  'all type',[1 4] ,0, 'electrodes', 'off','maplimits',[-0.4 0.4] );%ÿ��������topo


for i=1:size(EEGt.data,3)
       EEGt.data(:,1,i)=(ERO3(2,:)-ERO3(1,:))/2+(ERO3(4,:)-ERO3(3,:))/2; %STRESS main effects    
end
pop_topoplot(EEGt,1, [-600 -598] , 'QHSD',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms


for i=1:size(EEGt.data,3)
   EEGt.data(:,1,i)=(ERO3(3,:)-ERO3(1,:))/2+(ERO3(4,:)-ERO3(2,:))/2; %EC effects    
    
end
pop_topoplot(EEGt,1, [-600 -598] , 'ECSD',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
  EEGt.data(:,1,i)=(ERO3(4,:)-ERO3(2,:))/2-(ERO3(3,:)-ERO3(1,:))/2; %Interaction effects
    
end
pop_topoplot(EEGt,1, [-600 -598] , 'InterSD',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms


for i=1:size(EEGt.data,3) 
        EEGt.data(:,1,i)=(ERO3(3,:)-ERO3(1,:)); %��������Ķ�һ��������Ĳ���
end
 pop_topoplot(EEGt,1, [-600 -598] , 'QSD',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO3(4,:)-ERO3(2,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'HSD',[1 4] ,0, 'electrodes', 'off', 'maplimits',[-0.2 0.2] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO3(4,:)-ERO3(3,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'errorSD',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

for i=1:size(EEGt.data,3)
        EEGt.data(:,1,i)=(ERO3(2,:)-ERO3(1,:)); 
end
pop_topoplot(EEGt,1, [-600 -598] , 'correctSD',[1 4] ,0, 'electrodes', 'on', 'maplimits',[-0.1 0.1] );%every 2 ms

%% ��SD��F value

data4anovaSD= squeeze(mean(mean(dataSD_base(:,:,:,findex1,tindex1),4),5));
FvaluesSD = zeros(1,58);
FpvaluesSD = zeros(1,58);
FdatasSD = zeros(1,52);
Fg1 = {};
for i = 1:26
    Fg1{1,i} = 'c'
end
for i = 27:52
    Fg1{1,i} = 'e'
end
Fg2 = [ones(1,13) 2*ones(1,13) ones(1,13) 2*ones(1,13)];
for i = 1:58
    for j = 1:13      
        FdatasSD(1,j) = data4anovaSD(1,j,i);
        FdatasSD(1,j+13) = data4anovaSD(2,j,i);
        FdatasSD(1,j+26) = data4anovaSD(3,j,i);
        FdatasSD(1,j+39) = data4anovaSD(4,j,i);
    end
    
    [p,table,stats] = anovan(FdatasSD,{Fg1,Fg2},'model','interaction');
    FvaluesSD(1,i) = table{4,6};%F
    FpvaluesSD(1,i) = table{4,7};%P
end

% plot F-value interaction
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%F
 for j = 1:58
     EEGt.data(j,1,1) = FvaluesSD(1,j);%F
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 3]  );%ÿ��������topo

%p
for j = 1:58
     EEGt.data(j,1,1) = FpvaluesSD(1,j);%P
 end

pop_topoplot(EEGt,1,[-600 -598],  'all type',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.05]  );%
%% SD��t����
Ttestc2c1=zeros(1,58);
Tteste1c1=zeros(1,58);
Tteste2c2=zeros(1,58);
Tteste2e1=zeros(1,58);

for i = 1:58
    Ttestc1=squeeze(data4anovaSD(1,:,i));
    Ttestc2=squeeze(data4anovaSD(2,:,i));
    Tteste1=squeeze(data4anovaSD(3,:,i));
    Tteste2=squeeze(data4anovaSD(4,:,i));
    
    [h,p,ci,stats] = ttest(Tteste1,Ttestc1);
    Tteste1c1(1,i)=p;
    Tteste1c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Ttestc2);
    Tteste2c2(1,i)=p;
    Tteste2c2(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Ttestc2,Ttestc1);
    Ttestc2c1(1,i)=p;
    Ttestc2c1(2,i)=stats.tstat;
    [h,p,ci,stats] = ttest(Tteste2,Tteste1);
    Tteste2e1(1,i)=p;
    Tteste2e1(2,i)=stats.tstat;   
end

% plot
EEG = pop_loadset('O:\huan-eeg\eegrawdata\��24��\K19c1.set'); %  
EEG = eeg_checkset( EEG );
EEGt = EEG;
EEGt.trials = 1;
EEGt.pnts = 2;
EEGt.xmax = -0.598;
EEGt.data = ones(58,2,1);
%p
 for j = 1:58
     EEGt.data(j,1,1) = Tteste1c1(1,j);%ǰ��
 end
pop_topoplot(EEGt,1,[-600 -598],  'e1c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.05]  );%ÿ��������topo

 for j = 1:58
     EEGt.data(j,1,1) = Tteste2c2(1,j);%���
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2c2',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.05]  );%ÿ��������topo
 for j = 1:58
     EEGt.data(j,1,1) = Ttestc2c1(1,j);%��ȷ
 end
pop_topoplot(EEGt,1,[-600 -598],  'c2c1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.05]  );%ÿ��������topo
 for j = 1:58
     EEGt.data(j,1,1) = Tteste2e1(1,j);%����
 end
pop_topoplot(EEGt,1,[-600 -598],  'e2e1',[1 2] ,0, 'electrodes', 'on','maplimits',[0 0.05]  );%ÿ��������topo


