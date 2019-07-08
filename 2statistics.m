%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group CC    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%画P值图
N_Subs = 13;% ？？？？分组                                           %被试数
t=[-600:2:998];
f=[1:0.58:30];
t_base_lim=[-0.55 -0.15]; % t=EEG.times/1000;
% {#Subject x 1}, each subject having {#Sources x #Sources} cells, each cell having a #Frequency by #Time matrix
t_base_idx = find((t/1000>=t_base_lim(1)) & (t/1000<=t_base_lim(2))); % baseline area, unit: sec
N_Bootstrap = 5000; % number of bootstraping

P_QHCC1=(tempsCCc2-tempsCCc1)/2+(tempsCCe2-tempsCCe1)/2;     %control主效应
                                    
for i=1:N_Subs
    P_QHCC(:,:,i)=squeeze(P_QHCC1(:,:,i));
end
[pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l] = sub_tfd_bootstrp(P_QHCC1(:,t_base_idx,:), P_QHCC1, N_Bootstrap);
% 
% figure;imagesc(EEG.times,f,pvals_btstrp{ii});axis xy;caxis([0 0.05]);xlim([-400 900]);colorbar;
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('QHCC');
figure;imagesc(t,f,(mean(tempsCCc2,3)-mean(tempsCCc1,3)-mean(tempsCCe1,3)+mean(tempsCCe2,3))/2);axis xy;caxis([-0.5 0.5]);colorbar;title('QHCC');




P_ECCC1=(tempsCCe1-tempsCCc1)/2+(tempsCCe2-tempsCCc2)/2;;    %error/correct主效应
            
for i=1:N_Subs
    P_ECCC(:,:,i)=squeeze(P_ECCC1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ECCC1(:,t_base_idx,:), P_ECCC1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('ECCC');
figure;imagesc(t,f,(mean(tempsCCe1,3)-mean(tempsCCc1,3)-mean(tempsCCc2,3)+mean(tempsCCe2,3))/2);axis xy;caxis([-0.5 0.5]);colorbar;title('ECCC');



P_interCC1=(tempsCCe2-tempsCCc2)/2-(tempsCCe1-tempsCCc1)/2;    %两因素交互效应
            
for i=1:N_Subs
    P_interCC(:,:,i)=squeeze(P_interCC1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_interCC1(:,t_base_idx,:), P_interCC1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('InteractionCC');
figure;imagesc(t,f,(mean(tempsCCe2,3)-mean(tempsCCc2,3)-mean(tempsCCe1,3)+mean(tempsCCc1,3))/2);axis xy;caxis([-0.2 0.2]);colorbar;title('InteractionCC');


P_QCC1=tempsCCe1-tempsCCc1;                          %前测
for i=1:N_Subs
    P_QCC(:,:,i)=squeeze(P_QCC1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_QCC1(:,t_base_idx,:), P_QCC1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-500 1000]);colorbar;title('QCC');
figure;imagesc(t,f,mean(tempsCCe1,3)-mean(tempsCCc1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('QCC');

P_HCC1=tempsCCe2-tempsCCc2;                            %后测
for i=1:N_Subs
    P_HCC(:,:,i)=squeeze(P_HCC1(:,:,i));         
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_HCC1(:,t_base_idx,:), P_HCC1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('HCC');
figure;imagesc(t,f,mean(tempsCCe2,3)-mean(tempsCCc2,3));axis xy;caxis([-0.5 0.5]);colorbar;title('HCC');

P_ECC1=tempsCCe2-tempsCCe1;                             %错误    
for i=1:N_Subs
    P_ECC(:,:,i)=squeeze(P_ECC1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ECC1(:,t_base_idx,:), P_ECC1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('ECC');
figure;imagesc(t,f,mean(tempsCCe2,3)-mean(tempsCCe1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('ECC');

P_CCC1=tempsCCc2-tempsCCc1;                           %正确
for i=1:N_Subs
    P_CCC(:,:,i)=squeeze(P_CCC1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_CCC1(:,t_base_idx,:), P_CCC1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('CCC');
figure;imagesc(t,f,mean(tempsCCc2,3)-mean(tempsCCc1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('CCC');

%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group SS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%画P值图
N_Subs = 13;% 分组                                           %被试数
t=[-600:2:998];
f=[1:0.58:29.5];
t_base_lim=[-0.55 -0.15]; % t=EEG.times/1000;
% {#Subject x 1}, each subject having {#Sources x #Sources} cells, each cell having a #Frequency by #Time matrix
t_base_idx = find((t/1000>=t_base_lim(1)) & (t/1000<=t_base_lim(2))); % baseline area, unit: sec
N_Bootstrap = 5000; % number of bootstraping

P_QHSS1=(tempsSSc2-tempsSSc1)/2+(tempsSSe2-tempsSSe1)/2;     %stress主效应
                                    
for i=1:N_Subs
    P_QHSS(:,:,i)=squeeze(P_QHSS1(:,:,i));
end
[pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l] = sub_tfd_bootstrp(P_QHSS1(:,t_base_idx,:), P_QHSS1, N_Bootstrap);
% 
% figure;imagesc(EEG.times,f,pvals_btstrp{ii});axis xy;caxis([0 0.05]);xlim([-400 900]);colorbar;
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('QHSS');
figure;imagesc(t,f,(mean(tempsSSc2,3)-mean(tempsSSc1,3)-mean(tempsSSe1,3)+mean(tempsSSe2,3))/2);axis xy;caxis([-0.5 0.5]);colorbar;title('QHS');




P_ECSS1=(tempsSSe1-tempsSSc1)/2+(tempsSSe2-tempsSSc2)/2;;    %error/correct主效应
            
for i=1:N_Subs
    P_ECSS(:,:,i)=squeeze(P_ECSS1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ECSS1(:,t_base_idx,:), P_ECSS1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('ECSS');
figure;imagesc(t,f,(mean(tempsSSe1,3)-mean(tempsSSc1,3)-mean(tempsSSc2,3)+mean(tempsSSe2,3))/2);axis xy;caxis([-0.5 0.5]);colorbar;title('ECS');



P_interSS1=(tempsSSe2-tempsSSc2)/2-(tempsSSe1-tempsSSc1)/2;    %两因素交互效应
            
for i=1:N_Subs
    P_interS(:,:,i)=squeeze(P_interSS1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_interSS1(:,t_base_idx,:), P_interSS1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-500 1000]);colorbar;title('InteractionSS');
figure;imagesc(t,f,(mean(tempsSSe2,3)-mean(tempsSSc2,3)-mean(tempsSSe1,3)+mean(tempsSSc1,3))/2);axis xy;caxis([-0.2 0.2]);colorbar;title('InteractionS');


P_QSS1=tempsSSe1-tempsSSc1;                          %前测
for i=1:N_Subs
    P_QS(:,:,i)=squeeze(P_QSS1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_QSS1(:,t_base_idx,:), P_QSS1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-500 1000]);colorbar;title('QSS');
figure;imagesc(t,f,mean(tempsSSe1,3)-mean(tempsSSc1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('QSS');

P_HSS1=tempsSSe2-tempsSSc2;                            %后测
for i=1:N_Subs
    P_HS(:,:,i)=squeeze(P_HSS1(:,:,i));         
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_HSS1(:,t_base_idx,:), P_HSS1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('HSS');
figure;imagesc(t,f,mean(tempsSSe2,3)-mean(tempsSSc2,3));axis xy;caxis([-0.5 0.5]);colorbar;title('HSS');

P_ESS1=tempsSSe2-tempsSSe1;                             %错误    
for i=1:N_Subs
    P_ES(:,:,i)=squeeze(P_ESS1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ESS1(:,t_base_idx,:), P_ESS1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-600 1000]);colorbar;title('ESS');
figure;imagesc(t,f,mean(tempsSSe2,3)-mean(tempsSSe1,3));axis xy;caxis([-0.2 0.2]);colorbar;title('ESS');

P_CSS1=tempsSSc2-tempsSSc1;                           %正确
for i=1:N_Subs
    P_CS(:,:,i)=squeeze(P_CSS1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_CSS1(:,t_base_idx,:), P_CSS1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('CSS');
figure;imagesc(t,f,mean(tempsSSc2,3)-mean(tempsSSc1,3));axis xy;caxis([-0.8 0.8]);colorbar;title('CSS');
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    group SD    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%画P值图
N_Subs = 13;% ？？？？分组                                           %被试数
t=[-600:2:998];
f=[1:0.58:29.5];
t_baSDe_lim=[-0.45 -0.1]; % t=EEG.times/1000;
% {#Subject x 1}, each subject having {#Sources x #Sources} cells, each cell having a #Frequency by #Time matrix
t_base_idx = find((t/1000>=t_base_lim(1)) & (t/1000<=t_base_lim(2))); % baseline area, unit: sec
N_Bootstrap = 5000; % number of bootstraping

P_QHSD1=(tempsSDc2-tempsSDc1)/2+(tempsSDe2-tempsSDe1)/2;     %low stress主效应
                                    
for i=1:N_Subs
    P_QHSD(:,:,i)=squeeze(P_QHSD1(:,:,i));
end
[pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l] = sub_tfd_bootstrp(P_QHSD1(:,t_base_idx,:), P_QHSD1, N_Bootstrap);
% 
% figure;imagesc(EEG.times,f,pvals_btstrp{ii});axis xy;caxis([0 0.05]);xlim([-400 900]);colorbar;
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-500 1000]);colorbar;title('QHSD');
figure;imagesc(t,f,(mean(tempsSDc2,3)-mean(tempsSDc1,3)-mean(tempsSDe1,3)+mean(tempsSDe2,3))/2);axis xy;caxis([-0.5 0.5]);colorbar;title('QHSD');




P_ECSD1=(tempsSDe1-tempsSDc1)/2+(tempsSDe2-tempsSDc2)/2;;    %error/correct主效应
            
for i=1:N_Subs
    P_ECSD(:,:,i)=squeeze(P_ECSD1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ECSD1(:,t_base_idx,:), P_ECSD1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('ECSD');
figure;imagesc(t,f,(mean(tempsSDe1,3)-mean(tempsSDc1,3)-mean(tempsSDc2,3)+mean(tempsSDe2,3))/2);axis xy;caxis([-0.4 0.5]);colorbar;title('ECSD');



P_interSD1=(tempsSDe2-tempsSDc2)/2-(tempsSDe1-tempsSDc1)/2;    %两因素交互效应
            
for i=1:N_Subs
    P_interS(:,:,i)=squeeze(P_interSD1(:,:,i));
end

[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_interSD1(:,t_base_idx,:), P_interSD1, N_Bootstrap);
pvals_btstrp(find(pvals_btstrp>0.05))=1;
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('InteractionSD');
figure;imagesc(t,f,(mean(tempsSDe2,3)-mean(tempsSDc2,3)-mean(tempsSDe1,3)+mean(tempsSDc1,3))/2);axis xy;caxis([-0.2 0.2]);colorbar;title('InteractionSD');


P_QSD1=tempsSDe1-tempsSDc1;                          %前测
for i=1:N_Subs
    P_QSD(:,:,i)=squeeze(P_QSD1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_QSS1(:,t_base_idx,:), P_QSD1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.05]);xlim([-500 1000]);colorbar;title('QSD');
figure;imagesc(t,f,mean(tempsSDe1,3)-mean(tempsSDc1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('QSD');

P_HSD1=tempsSDe2-tempsSDc2;                            %后测
for i=1:N_Subs
    P_HSD(:,:,i)=squeeze(P_HSD1(:,:,i));         
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_HSD1(:,t_base_idx,:), P_HSD1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('HSD');
figure;imagesc(t,f,mean(tempsSDe2,3)-mean(tempsSDc2,3));axis xy;caxis([-0.5 0.5]);colorbar;title('HSD');

P_ESD1=tempsSDe2-tempsSDe1;                             %错误    
for i=1:N_Subs
    P_ES(:,:,i)=squeeze(P_ESD1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_ESD1(:,t_base_idx,:), P_ESD1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('ESD');
figure;imagesc(t,f,mean(tempsSDe2,3)-mean(tempsSDe1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('ESD');

P_CSD1=tempsSDc2-tempsSDc1;                           %正确
for i=1:N_Subs
    P_CSD(:,:,i)=squeeze(P_CSD1(:,:,i));
end
[ pvals_btstrp,pvals_btstrp_r,pvals_btstrp_l ] = sub_tfd_bootstrp(P_CSS1(:,t_base_idx,:), P_CSS1, N_Bootstrap);
figure;imagesc(t,f,pvals_btstrp);axis xy;caxis([0.0 0.01]);xlim([-500 1000]);colorbar;title('CSD');
figure;imagesc(t,f,mean(tempsSDc2,3)-mean(tempsSDc1,3));axis xy;caxis([-0.5 0.5]);colorbar;title('CSD');



