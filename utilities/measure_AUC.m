function [result]=measure_AUC( pred_label, true_label)
%% ����ָ��AUC����⣬�˴���ֻ�����������࣬�����ö��������
    % labelΪ1�����ԣ���������
    cur_tl = true_label(true_label==1);
    % the corresponding predicted label
    cur_pl = pred_label(true_label==1);
    cur_tlF = pred_label(true_label==2);
    cur_tlN = true_label(true_label==2);
    % true rate
    %������
    TP=sum(cur_pl==1);
    %������
    FN=sum(cur_pl==2);
    %������
    FP=sum(cur_tlF==1);
    %������
    TN=sum(cur_tlF==2);
    Sens=TP./(TP+FN+0.0001);
    Spec=TN./(TN+FP+0.0001);
    result=(Sens+Spec)/2;