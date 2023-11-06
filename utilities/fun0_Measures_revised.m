function [acc,recall,precision,F_measure,G_mean] = fun0_Measures_revised( pred_label, true_label )
% measures for classifier
% g-mean,recall,precision,F_measure,G_mean

% general accuracy
acc = sum(pred_label==true_label) / length(true_label);
cnum = max(true_label);
if cnum==2
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
else if cnum>2
for i = 1 : cnum
    % the i_th class true label
    cur_tl = true_label(true_label==i);
    % the corresponding predicted label
    cur_pl = pred_label(true_label==i);
    cur_tlF = pred_label(true_label~=i);
    cur_tlN = true_label(true_label~=i);
    % true rate
    %真阳性
    TP(i)=sum(cur_pl==i);
    %假阴性
    FN(i)=sum(cur_pl~=i);
    %假阳性
    FP(i)=sum(cur_tlF==i);
    %真阴性
    TN(i)=sum(cur_tlF==cur_tlN);
%     ctr_vec(i) = TP(i) / length(cur_tl);
end

    end
end
%recall
R=TP./(TP+FN);
%precision
P=TP./(TP+FP);
%F_measure
F=2.*R.*P./(R+P);
% G_mean
G=sqrt(R.*(TN./(TN+FP)));
% %分母有零时
% recall
R=TP./(TP+FN+0.0001);
% precision
P=TP./(TP+FP+0.0001);
% F_measure
F=2.*R.*P./(R+P+0.0001);
% G_mean
G=sqrt(R.*(TN./(TN+FP+0.0001)));
recall=mean(R);
precision=mean(P);
F_measure=mean(F);
G_mean=mean(G);
end

