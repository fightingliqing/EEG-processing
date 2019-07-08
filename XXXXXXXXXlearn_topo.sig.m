
% ���������Ե缫�㲻ͬ�����Ĳ���ʱƵͼ

chan={'C1','C3','FC1','C5','CP1','FC3','CP3','FC5','CP5'};                  
chanlocs= channels;%��һ���ű���channels
index_chan = [];
for i=1:length(chan)
    for j=1:length(chanlocs)
        if strcmp(chan{i},chanlocs(j))
            index_chan(i)=j;
        end
    end
end


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group CC    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

 condition={'c1','c2','e1','e2'};
 dataCC_new = [];
for i = 1:(length(file_nameCC)/4)
    for j = 1:4 %����
       load(file_nameCC{(i-1)*4+j});
       temp_data = squeeze(eeg.data);
       dataCC_new (j,i,:,:,:) = temp_data(index_chan,:,:);%  ����*����*�缫��*Ƶ��*ʱ���
    end
end

avg1=squeeze((mean(mean(dataCC_new,3),2))); % ���б�����ָ���缫���ƽ����Ϊʲô�ĳ�3����Ϊ�缫���ǵ�����ά�ȡ��ȶԵ缫����ƽ�����ٶԱ�����
% avg�����˱��Ժ͵缫��������ά�ȣ����ԣ�avg��  ����*Ƶ��*ʱ���  4*50*750
CCc1=squeeze(avg1(1,:,:));%avg(1,:,:)������1��c1����Ƶ��*�缫������ݡ�������mean�����е���ࡣ��Ϊ��һ��ά�ȶ��Ѿ�ֻ��һ���ˣ�����mean������
CCc2=squeeze(avg1(2,:,:));%
CCe1=squeeze(avg1(3,:,:));%
CCe2=squeeze(avg1(4,:,:));%

t=-0.6:1/500:1.0-1/500;
f=1:29/49:30;

figure;
imagesc(t,f,CCc1);axis xy;caxis([-0.5 0.5]);colorbar;title('CCc1');
saveas(gcf,'CCc1.tif')
figure;
imagesc(t,f,CCc2);axis xy;caxis([-0.5 0.5]);colorbar;title('CCc2');
saveas(gcf,'CCc2.tif')
figure;
imagesc(t,f,CCe1);axis xy;caxis([-0.5 0.5]);colorbar;title('CCe1');
saveas(gcf,'CCe1.tif')
figure;
imagesc(t,f,CCe2);axis xy;caxis([-0.5 0.5]);colorbar;title('CCe2');
saveas(gcf,'CCe2.tif')
figure;
imagesc(t,f,CCc2-CCc1+CCe2-CCe1);axis xy;caxis([-0.1 0.1]);colorbar;title('QHCC');
saveas(gcf,'QHCC.tif')
figure;
imagesc(t,f,CCe1-CCc1+CCe2-CCc2);axis xy;caxis([-0.1 0.1]);colorbar;title('ECCC');
saveas(gcf,'ECCC.tif')
figure;
imagesc(t,f,CCe2-CCc2-CCe1+CCc2);axis xy;caxis([-0.1 0.1]);colorbar;title('InteractionCC');
saveas(gcf,'IntercationCC.tif')

data_baseCC = dataCC_new;
tlim1=[0.5 0.8];
flim1=[10 13];

tindex1=find(t>=tlim1(1) & t<=tlim1(2));
findex1=find(f>=flim1(1) & f<=flim1(2));
dataCC=data_baseCC(:,:,:,findex1,tindex1);
ERDCC=squeeze(mean(mean(dataCC,4),5));%Ƶ��,time,ʣ��:tiaojian * beishi * dianjidian 
ERDCCall=squeeze(mean(ERDCC,3));%�Ե缫��   ��ʣ��: tiaojian*beishi
%������Ҫ�Ա�����ƽ��
ERDCC_CCc1=mean(ERDCCall(1,:),2);
ERDCC_CCc2=mean(ERDCCall(2,:),2);
ERDCC_CCe1=mean(ERDCCall(3,:),2);
ERDCC_CCe2=mean(ERDCCall(4,:),2);
%% t����
[t,p]=ttest(ERDCC_CCc1,ERDCC_CCe1) 
[t,p]=ttest(ERDCC_CCc2,ERDCC_CCe2)
%% ��������������������ݵ���SPSS��
CCc1pre = squeeze(mean(squeeze(mean(squeeze(data_baseCC(1,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
CCc1 = squeeze(mean(CCc1pre(findex1,:),1)) ;
CCc2pre = squeeze(mean(squeeze(mean(squeeze(data_baseCC(2,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
CCc2 = squeeze(mean(CCc2pre(findex1,:),1)) ;
CCe1pre = squeeze(mean(squeeze(mean(squeeze(data_baseCC(3,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
CCe1 = squeeze(mean(CCe1pre(findex1,:),1)) ;
CCe2pre = squeeze(mean(squeeze(mean(squeeze(data_baseCC(4,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
CCe2 = squeeze(mean(CCe2pre(findex1,:),1)) ;
%% ������ͼ
%������ͼaxis([-0.4 1.0 -0.05 0.2])
figure;hold on;axis([-0.4 1.0 -0.05 0.2])
plot(t,CCc1,'r','linewidth',2);
plot(t,CCc2,'g','linewidth',2);
plot(t,CCe1,'b','linewidth',2);
plot(t,CCe2,'k','linewidth',2);
legend('CCc1','CCc2','CCe1','CCe2');
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group SS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

 condition={'c1','c2','e1','e2'};
 dataSS_new = [];
for i = 1:(length(file_nameSS)/4)
    for j = 1:4 %����
       load(file_nameSS{(i-1)*4+j});
       temp_data = squeeze(eeg.data);
       dataSS_new (j,i,:,:,:) = temp_data(index_chan,:,:);% data_new1: ����*����*�缫��*Ƶ��*ʱ���
    end
end

avg2=squeeze((mean(mean(dataSS_new,3),2))); % ���б�����ָ���缫���ƽ����Ϊʲô�ĳ�3����Ϊ�缫���ǵ�����ά�ȡ��ȶԵ缫����ƽ�����ٶԱ�����
% avg�����˱��Ժ͵缫��������ά�ȣ����ԣ�avg��  ����*Ƶ��*ʱ���  4*50*750
SSc1=squeeze(avg2(1,:,:));%avg(1,:,:)������1��c1����Ƶ��*�缫������ݡ�������mean�����е���ࡣ��Ϊ��һ��ά�ȶ��Ѿ�ֻ��һ���ˣ�����mean������
SSc2=squeeze(avg2(2,:,:));%
SSe1=squeeze(avg2(3,:,:));%
SSe2=squeeze(avg2(4,:,:));%

% tlim=[-0.45 -0.1];%��Ҫ��ʱ��㣬�ⲻ�ǻ������ǵġ��㿴������ظ�forѭ���������ǻ��߽��������ǲ�������һ����
t=-0.6:1/500:1.0-1/500;
f=1:29/49:30;
% tindex=find(t>=tlim(1) & t<=tlim(2));
% 
% 
% for i=1:size(s11,2)%S11������������size��Ҫ��ɶ����������ʾһ��
%     c1(:,i)=(c1(:,i)-mean(c1(tindex,i)))/mean(c1(tindex,i));
%     c2(:,i)=(c2(:,i)-mean(c2(tindex,i)))/mean(c2(tindex,i));
%     e1(:,i)=(e1(:,i)-mean(e1(tindex,i)))/mean(e1(tindex,i));
%     e2(:,i)=(e2(:,i)-mean(e2(tindex,i)))/mean(e2(tindex,i));
% end
%��ȥ�������ݣ����Ի��ߡ�ע�⣬�����ﲢû�г���100�����ԣ��������20������20%������20
figure;
imagesc(t,f,SSc1);axis xy;caxis([-0.5 0.5]);colorbar;title('SSc1');
saveas(gcf,'SSc1.tif')
figure;
imagesc(t,f,SSc2);axis xy;caxis([-0.5 0.5]);colorbar;title('SSc2');
saveas(gcf,'SSc2.tif')
figure;
imagesc(t,f,SSe1);axis xy;caxis([-0.5 0.5]);colorbar;title('SSe1');
saveas(gcf,'SSe1.tif')
figure;
imagesc(t,f,SSe2);axis xy;caxis([-0.5 0.5]);colorbar;title('SSe2');
saveas(gcf,'SSe2.tif')
figure;
imagesc(t,f,SSc2-SSc1+SSe2-SSe1);axis xy;caxis([-0.1 0.1]);colorbar;title('QHSS');
saveas(gcf,'QHSS.tif')
figure;
imagesc(t,f,SSe1-SSc1+SSe2-SSc2);axis xy;caxis([-0.1 0.1]);colorbar;title('ECSS');
saveas(gcf,'ECSS.tif')
figure;
imagesc(t,f,SSe2-SSc2-SSe1+SSc2);axis xy;caxis([-0.1 0.1]);colorbar;title('InteractionSS');
saveas(gcf,'IntercationSS.tif')


data_baseSS = dataSS_new;
tlim1=[0.5 0.8];
flim1=[10 13];

tindex1=find(t>=tlim1(1) & t<=tlim1(2));
findex1=find(f>=flim1(1) & f<=flim1(2));
dataSS=data_baseSS(:,:,:,findex1,tindex1);
ERDSS=squeeze(mean(mean(dataSS,4),5));%Ƶ��,time,ʣ��:tiaojian * beishi * dianjidian 
ERDSSall=squeeze(mean(ERDSS,3));%�Ե缫��   ��ʣ��: tiaojian*beishi
%������Ҫ�Ա�����ƽ��
ERDSS_SSc1=mean(ERDSSall(1,:),2);
ERDSS_SSc2=mean(ERDSSall(2,:),2);
ERDSS_SSe1=mean(ERDSSall(3,:),2);
ERDSS_SSe2=mean(ERDSSall(4,:),2);

[t,p]=ttest(ERDSS_SSc1,ERDSS_SSe1) 
[t,p]=ttest(ERDSS_SSc2,ERDSS_SSe2)
%t����
% ��������������������ݵ���SPSS��
SSc1pre = squeeze(mean(squeeze(mean(squeeze(data_baseSS(1,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
SSc1 = squeeze(mean(SSc1pre(findex1,:),1)) ;
SSc2pre = squeeze(mean(squeeze(mean(squeeze(data_baseSS(2,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
SSc2 = squeeze(mean(SSc2pre(findex1,:),1)) ;
SSe1pre = squeeze(mean(squeeze(mean(squeeze(data_baseSS(3,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
SSe1 = squeeze(mean(SSe1pre(findex1,:),1)) ;
SSe2pre = squeeze(mean(squeeze(mean(squeeze(data_baseSS(4,:,:,:,:,:)),1)),1));%zheliixiedeilan,danshi yisi shiduide
SSe2 = squeeze(mean(SSe2pre(findex1,:),1)) ;


%������ͼaxis([-0.4 1.0 -0.05 0.2])
figure;hold on;
plot(t,SSc1,'r','linewidth',2);
plot(t,SSc2,'g','linewidth',2);
plot(t,SSe1,'b','linewidth',2);
plot(t,SSe2,'k','linewidth',2);
legend('SSc1','SSc2','SSe1','SSe2');