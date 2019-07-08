%% replace the old_mark by beavior * EEG.epoch

folder1 = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\match\behavior';
folder2 = 'E:\paper\WM_attention\data_WM and attention\data\EEGlab\epochmat';
mark2 = [];
fimark = {};
newfolder = [folder2,'\newres']
mkdir(newfolder)
for i  = 1:24
    load([folder1,'\',num2str(i),'.mat']);
    load([folder2,'\',num2str(i,'%02d'),'_epoch.mat']);
    temp = epoch.types;
    for ii = 1:length(temp)
        mark2(ii) = str2num(temp{ii}(4));
    end
    mark2 = int64(mark2);
    mark2(mark2 == 3) = 5;    % neutral
    mark2(mark2 == 2) = 4;    % uncued
    mark2(mark2 == 1) = 3;    % cued
    tmark = mark.*mark2;
    for iii = 1:length(tmark)
        fimark{iii} = ['S  ',num2str(tmark(iii))];
    end
    epoch.types = fimark;   % search.Left * cued=6, search.Left * uncued=8, search.Left * neutral=10;
                            % search.Right * cued=3, search.Right * uncued=4, search.Right * neutral=5 
    save([newfolder,'\',num2str(i),'.mat'],'epoch')
end