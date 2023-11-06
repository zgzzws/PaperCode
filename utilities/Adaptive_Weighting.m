
function [W] = Adaptive_Weighting( tr_descr,trls,params)
cnum = length(unique(trls));
each_tr_descr=cell(1, cnum);
eachclass_tr_descr=cell(1,cnum);
each_num=zeros(1,cnum);
num_total=each_num;
a=0;
k=params.nearest_n;
omega=params.omega;
x=params.nearest_out;

for ci = 1: cnum
    each_num(ci)=length(find(trls==ci));
    each_tr_descr{ci}=tr_descr;
    a=a+each_num(ci);
    num_total(ci)=a;
end
for ci = 1: cnum
    if ci==1
        each_tr_descr{1}(:,1:each_num(1))=[];
    else 
     each_tr_descr{ci}(:,num_total(ci-1)+1:num_total(ci))=[];
    end
end
for ci = 1: cnum
    if ci==1
        eachclass_tr_descr{1}=tr_descr(:,1:each_num(1));
    else 
        eachclass_tr_descr{ci}=tr_descr(:,num_total(ci-1)+1:num_total(ci-1)+each_num(ci));
    end
end
P=cell(1,a);
N=cell(1,a);
distan_out=cell(1,cnum);
for ci = 1: cnum
  for i=1:each_num(ci)
   [~,P{i}] = knnsearch(each_tr_descr{ci}',eachclass_tr_descr{ci}(:,i)','k',x);%取出类外最近k个样本的距离
   [~,N{i}] = knnsearch(eachclass_tr_descr{ci}(:,1:each_num(ci))',eachclass_tr_descr{ci}(:,i)','k',min(k,each_num(ci)));%取出类内最近k个样本的距离
   distan_out{ci}(1,i)=omega/(sum(P{i})/x);%表示每个样本的类外距离
   %如果类内的样本数为1，该样本的类内距离赋值为0.1
   if each_num(ci)==1| N{i}==0
       N{i}=0.1;
       k=1;
   end
   distan_in{ci}(1,i)= (1-omega)/(sum(N{i})/k);%每个样本的类内距离
  end
end
R=cell(1,cnum);
for ci = 1: cnum 
% 将加入平衡参数后的类内类外距离相加
R{ci}=distan_in{ci}+distan_out{ci};
end
%求N_ik
for ci=1:cnum
    if ci==1
            b(1:each_num(1))= 1/(each_num(1)^0.5);
    else
        b(num_total(ci-1)+1:num_total(ci))=1/(each_num(ci)^0.5);%b为每类样本数分之一
    end
end
%转换为对角阵
q=cell2mat(R);%将元胞数组转化为矩阵
%  q=q/sum(q);
%将每类样本的个数与混合密度结合
w=q.*b;
W=diag(w,0);



