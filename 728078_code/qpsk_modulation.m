%对输入随机序列进行QPSK调制
function [y1,y2]=qpsk_modulation(x)
N=length(x);
a=1:2:N;
z1=x(a);
z2=x(a+1);
%按照格雷码的规则进行映射
y1(find(z1==0))=-1;
y1(find(z1==1))=1;
y2(find(z2==0))=-1;
y2(find(z2==1))=1;
