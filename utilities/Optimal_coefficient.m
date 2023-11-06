function z = Optimal_coefficient(data, params,W,nClass)
tr_descr   =   data.tr_descr;
tt_descr   =   data.tt_descr;
tr_label   =   data.tr_label;
gamma      =   params.gamma;
lambda     =   params.lambda;
class_num  =   params.class_num;
[~,n]=size(tr_descr);
new_tr_descr=cell(1, class_num);
each_num=zeros(1,class_num);
num_total=each_num;
a=0;
for ci = 1: class_num
    each_num(ci)=length(find(tr_label==ci));
    a=a+each_num(ci);
    num_total(ci)=a;
end
for ci = 1: class_num
    if ci==1
        new_tr_descr{1}=tr_descr(:,1:each_num(1));
    else 
     new_tr_descr{ci}=tr_descr(:,num_total(ci-1)+1:num_total(ci));
    
    end
end
new_W=diag(W);
class_W=cell(1, class_num);
for ci = 1: class_num
    if ci==1
       class_W{1}=diag(new_W(1:each_num(1),:));
    else
        class_W{ci}=diag(new_W(num_total(ci-1)+1:num_total(ci),:));
    end
end
tr_blocks = cell(1, class_num);
for ci = 1: class_num
    tr_blocks{ci} =class_W{ci}'* new_tr_descr{ci}' * new_tr_descr{ci}*class_W{ci};
end
tr_block_diag_mat = blkdiag(tr_blocks{:});
XTXinv=(1+2*gamma)*(tr_descr*W)'*tr_descr*W+lambda*eye(n)+2*nClass*gamma*tr_block_diag_mat; 
z = XTXinv\(W'*tr_descr'*tt_descr);

    

