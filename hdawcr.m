 clear; clc;
tic
 addpath(genpath('utilities'));
addpath('increase_data');
load ('glass04vs5');
%设置三个参数的取值范围
gamma  = [1e-20 1e-19 1e-18 1e-17 1e-16 1e-15 1e-14 1e-13 1e-12 1e-11];
lambda =[1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1];
omega=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
nearest_n=[1 2 3 4 5 6 7 8];
nearest_out=[1 2 3 4 5 6 7 8];
% 样本集的总类别
nClass   =  max(trainlabels);  % the number of classes in the database
%结构体params
params.class_num   =   nClass;
%初始赋值
a=zeros(1,nClass);
acc=0;
recall=0;
precision=0;
F_measure=0;
G_mean=0;
AUC=0;
num_test=length(testlabels);
weight=zeros(num_test,nClass);
Weight=zeros(num_test,nClass);
%计算不平衡率IR
for ci=1:nClass
    a(ci)=length(find(trainlabels==ci));
    b(ci)=length(find(testlabels==ci));
end
IR=max(a+b)/min(a+b);
%测试数据和训练数据的归一化
tr_descr  =  NewTrain_DAT./( repmat(sqrt(sum(NewTrain_DAT.*NewTrain_DAT)), [size(NewTrain_DAT, 1),1]) );
 tt_descr  =  NewTest_DAT./( repmat(sqrt(sum(NewTest_DAT.*NewTest_DAT)), [size(NewTest_DAT, 1),1]) );
%所有的测试数据和训练数据及其分别的标签放到结构体fr_dat_split中
fr_dat_split.tr_descr = tr_descr;
fr_dat_split.tt_descr = tt_descr;
fr_dat_split.tr_label = trainlabels;
fr_dat_split.tt_label = testlabels;
%% 运行基于补子空间的加权协同表示分类方法
for m=1:length(nearest_n)
    params.nearest_n = nearest_n(m);
    for h=1:length(nearest_out)
         params.nearest_out = nearest_out(h);
        for n=1:length(omega)
        params.omega = omega(n);
    %求W
       [W]=Adaptive_Weighting(fr_dat_split.tr_descr,fr_dat_split.tr_label,params);%求权重矩阵
%     weight=ones(num_test,nClass);
     for k=1:length(lambda)
        params.lambda = lambda(k);                                                                                                                                                            
            for j = 1 : length(gamma)
                params.gamma = gamma(j);
                %求最优表示系数
                z = Optimal_coefficient(fr_dat_split, params,W,nClass);
                %预测测试样本的类别
                [pred_tt_label, ~] = SubSRC_Max(z, fr_dat_split, params);
               %% recognition rate
                [ac, r,p,F,G] = fun0_Measures_revised( pred_tt_label, fr_dat_split.tt_label );
                auc=measure_AUC(pred_tt_label,fr_dat_split.tt_label);
                %搜索不同参数下的最优值，得到最优的结果
                if  G_mean<=G||F_measure<=F
                   acc=ac;
                   recall=r;
                   precision=p;
                   F_measure=F;
                   G_mean=G;
                   AUC=auc;
                   Gamma=params.gamma;
                   Omega=params.omega;
                   Lambda=params.lambda;
                   Nearest_n=params.nearest_n;
                   Nearest_out=params.nearest_out;
                   Pred_tt_label=pred_tt_label;
                   Weight=weight;
                end
                end
            end
        end
   end
end
toc
%所有需要的数据保存到Result_SubCRC_NSC_weight_glass04vs5,glass04vs5是训练样本集，发生变化时相应改变
Result_SubCRC_NSC_weight_glass04vs5.class=nClass;
Result_SubCRC_NSC_weight_glass04vs5.eachclass=a+b;
Result_SubCRC_NSC_weight_glass04vs5.weight=Weight;
Result_SubCRC_NSC_weight_glass04vs5.gamma=Gamma;
Result_SubCRC_NSC_weight_glass04vs5.lambda=Lambda;
Result_SubCRC_NSC_weight_glass04vs5.omega=Omega;
Result_SubCRC_NSC_weight_glass04vs5.nearest_n=Nearest_n;
Result_SubCRC_NSC_weight_glass04vs5.nearest_out=Nearest_out;
Result_SubCRC_NSC_weight_glass04vs5.pred_tt_label=Pred_tt_label;
Result_SubCRC_NSC_weight_glass04vs5.IR=IR;
Result_SubCRC_NSC_weight_glass04vs5.acc=acc;
Result_SubCRC_NSC_weight_glass04vs5.precision=precision;
Result_SubCRC_NSC_weight_glass04vs5.recall=recall;
Result_SubCRC_NSC_weight_glass04vs5.F_measure=F_measure;
Result_SubCRC_NSC_weight_glass04vs5.G_mean=G_mean;
%保存数据
save Result_SubCRC_NSC_weight_glass04vs5   

