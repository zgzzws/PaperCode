
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
   [~,P{i}] = knnsearch(each_tr_descr{ci}',eachclass_tr_descr{ci}(:,i)','k',x);%ȡ���������k�������ľ���
   [~,N{i}] = knnsearch(eachclass_tr_descr{ci}(:,1:each_num(ci))',eachclass_tr_descr{ci}(:,i)','k',min(k,each_num(ci)));%ȡ���������k�������ľ���
   distan_out{ci}(1,i)=omega/(sum(P{i})/x);%��ʾÿ���������������
   %������ڵ�������Ϊ1�������������ھ��븳ֵΪ0.1
   if each_num(ci)==1| N{i}==0
       N{i}=0.1;
       k=1;
   end
   distan_in{ci}(1,i)= (1-omega)/(sum(N{i})/k);%ÿ�����������ھ���
  end
end
R=cell(1,cnum);
for ci = 1: cnum 
% ������ƽ����������������������
R{ci}=distan_in{ci}+distan_out{ci};
end
%��N_ik
for ci=1:cnum
    if ci==1
            b(1:each_num(1))= 1/(each_num(1)^0.5);
    else
        b(num_total(ci-1)+1:num_total(ci))=1/(each_num(ci)^0.5);%bΪÿ����������֮һ
    end
end
%ת��Ϊ�Խ���
q=cell2mat(R);%��Ԫ������ת��Ϊ����
%  q=q/sum(q);
%��ÿ�������ĸ��������ܶȽ��
w=q.*b;
W=diag(w,0);



