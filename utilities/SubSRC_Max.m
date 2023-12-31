function [pred_ttls, pre_matrix] = SubSRC_Max(coefs, data, params)

class_num  =  params.class_num;
tr_descr   =  data.tr_descr;
tr_label   =  data.tr_label;
tt_descr   =  data.tt_descr;
tt_num     =  length(data.tt_label);

%% perform prediction class-by-class
pre_matrix      =   zeros(class_num, tt_num);

for ci = 1:class_num
    loss_ci = tt_descr - tr_descr(:, tr_label == ci) * coefs(tr_label == ci,:);
    pci = sum(loss_ci.^2, 1);
    pre_matrix(ci,:) = pci;
end

[~,pred_ttls] = min(pre_matrix,[],1);

end