function [result]=measure_AUC( pred_label, true_label)
%% 度量指标AUC的求解，此代码只适用于两分类，不适用多分类问题
    % label为1是阳性，即少数例
    cur_tl = true_label(true_label==1);
    % the corresponding predicted label
    cur_pl = pred_label(true_label==1);
    cur_tlF = pred_label(true_label==2);
    cur_tlN = true_label(true_label==2);
    % true rate
    %真阳性
    TP=sum(cur_pl==1);
    %假阴性
    FN=sum(cur_pl==2);
    %假阳性
    FP=sum(cur_tlF==1);
    %真阴性
    TN=sum(cur_tlF==2);
    Sens=TP./(TP+FN+0.0001);
    Spec=TN./(TN+FP+0.0001);
    result=(Sens+Spec)/2;