请将该分析脚本所在的路径和其子路径添加至搜索路径中。

addpath(genpath(pwd));
savepath;

1、./dependencies/ 该路径下是分析脚本依赖的函数和文件。

2、step1_preEpoch.m 用于对数据进行初步的预处理。1Hz的高通滤波，以便进行随后的ICA分析，还可选择进行40Hz的低通滤波。

3、Step2_replace_mark.m 是将行为和EEG的Mark相对应；
   Step2_apply_mark.m 将更改好的Mark替换到step1预处理好的数据中

4、Step3_ICA2.m  独立成分分析（注意，进行ICA的数据需要1Hz高通滤波），
  计算得到两个矩阵：ICA weights matrices 和 sphere matrices。这两个矩阵可以应用到同一批数据中，
  无需重复进行独立成分分解。

5、step4_preprocess.m  预处理。0.1-40Hz  （选择你需要的滤波方式）    

6、step5_applyICA.m 将 WM_ica.m 计算所得到的数据矩阵应用到未进行 1Hz 高通滤波的数据中（即step4的数据）。
   
   ADJUST & visual inspection & reject bad ICA component。手动标记眨眼（垂直眼动）和眼睛横移（水平 眼动）的伪迹。

7、step6_study.m


