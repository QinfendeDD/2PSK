%对输入随机序列进行16QAM调制
function [y1,y2]=sixteenQam_modulation(x)
%首先进行串并转换，将原二进制序列转换成两路信号
N=length(x);
a=1:2:N;
z1=x(a);
z2=x(a+1);
%分别对两路信号进行QPSK调制
%对两路信号分别进行2－4电平变换
b=1:2:N/2;
temp1=z1(b);
temp2=z1(b+1);
y11=temp1*2+temp2;

temp1=z2(b);
temp2=z2(b+1);
y22=temp1*2+temp2;

%按照格雷码的规则进行映射
y1(find(y11==0))=-3;
y1(find(y11==1))=-1;
y1(find(y11==3))=1;
y1(find(y11==2))=3;

y2(find(y22==0))=-3;
y2(find(y22==1))=-1;
y2(find(y22==3))=1;
y2(find(y22==2))=3;
