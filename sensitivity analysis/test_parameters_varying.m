clear; clc;
tic
addpath(genpath('utilities'));
addpath('increase_data');
load ('glass04vs5');
%设置参数
gamma  = [1e-20 1e-19 1e-18 1e-17 1e-16 1e-15 1e-14 1e-13 1e-12 1e-11];
% lambda =[1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1];
omega=[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
% nearest_n=[1 2 3 4 5 6 7 8 9 10];
% nearest_out=[1 2 3 4 5 6 7 8 9 10]; 
lambda=[1e-1];
nearest_n=[8];
nearest_out=[2];
% omega=[0.3];
nsize=length(gamma);
 F_measure_glass04vs5_fix_lambda=zeros(nsize,nsize);
nClass   =  max(trainlabels);  % the number of classes in the database
params.class_num   =   nClass;
a=zeros(1,nClass);
acc=0;
recall=0;
precision=0;
F_measure=0;
for ci=1:nClass
    a(ci)=length(find(trainlabels==ci));
    b(ci)=length(find(testlabels==ci));
end
IR=max(a+b)/min(a+b);

tr_descr  =  NewTrain_DAT./( repmat(sqrt(sum(NewTrain_DAT.*NewTrain_DAT)), [size(NewTrain_DAT, 1),1]) );
 tt_descr  =  NewTest_DAT./( repmat(sqrt(sum(NewTest_DAT.*NewTest_DAT)), [size(NewTest_DAT, 1),1]) );

% tr_descr  =  NewTrain_DAT;
% tt_descr  =  NewTest_DAT;

fr_dat_split.tr_descr = tr_descr;
fr_dat_split.tt_descr = tt_descr;
fr_dat_split.tr_label = trainlabels;
fr_dat_split.tt_label = testlabels;
%% run SubCRC
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
                F_measure_glass04vs5_fix_lambda(n,j)=F;
            end
     end
        end
    end
end
save F_measure_glass04vs5_fix_lambda

