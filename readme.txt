�뽫�÷����ű����ڵ�·��������·�����������·���С�

addpath(genpath(pwd));
savepath;

1��./dependencies/ ��·�����Ƿ����ű������ĺ������ļ���

2��step1_preEpoch.m ���ڶ����ݽ��г�����Ԥ����1Hz�ĸ�ͨ�˲����Ա��������ICA����������ѡ�����40Hz�ĵ�ͨ�˲���

3��Step2_replace_mark.m �ǽ���Ϊ��EEG��Mark���Ӧ��
   Step2_apply_mark.m �����ĺõ�Mark�滻��step1Ԥ����õ�������

4��Step3_ICA2.m  �����ɷַ�����ע�⣬����ICA��������Ҫ1Hz��ͨ�˲�����
  ����õ���������ICA weights matrices �� sphere matrices���������������Ӧ�õ�ͬһ�������У�
  �����ظ����ж����ɷַֽ⡣

5��step4_preprocess.m  Ԥ����0.1-40Hz  ��ѡ������Ҫ���˲���ʽ��    

6��step5_applyICA.m �� WM_ica.m �������õ������ݾ���Ӧ�õ�δ���� 1Hz ��ͨ�˲��������У���step4�����ݣ���
   
   ADJUST & visual inspection & reject bad ICA component���ֶ����գ�ۣ���ֱ�۶������۾����ƣ�ˮƽ �۶�����α����

7��step6_study.m


