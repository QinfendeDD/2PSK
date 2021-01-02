clear;
%随机产生长度大于1000的‘0’、‘1’信号序列，对其进行16QAM调制
%定义待仿真序列的维数 N
global N
N=2000;
%定义产生‘1’的概率为 p
global p
p=0.5;
%产生随机二进制序列
s_16Qam=randsrc(1,N,[1,0;p,1-p]);
%画出生成的随机序列图
figure(1);
stem(s_16Qam);
axis([0 50 -0.5 1.5]);
xlabel('维数N')
ylabel('信号强度')
title('0/1等概分布的信号')

%********16QAM信号的数字调制********
[m_16Qam1,m_16Qam2]=sixteenQam_modulation(s_16Qam);
figure(2);
plot(m_16Qam1,m_16Qam2,'r*');
axis([-4 4 -4 4]);
title('16QAM的信号空间图');

%********插值，相邻信号间插入7个零点********
insert_16Qam1=upsample(m_16Qam1,8);
insert_16Qam2=upsample(m_16Qam2,8);
%画出插值后的序列
figure(3);
subplot(2,1,1);
plot(insert_16Qam1(1:90),'ro');
axis([0 100 -1.5 1.5]);
hold on;
plot(insert_16Qam1(1:90));
xlabel('实部信号');
axis([0 100 -5 5]);
title('16QAM插值后序列');
subplot(2,1,2);
plot(insert_16Qam2(1:90),'yo');
axis([0 100 -1.5 1.5]);
hold on;
plot(insert_16Qam2(1:90));
xlabel('虚部信号');
axis([0 100 -5 5]);

%********升余弦滤波器滤波********
out_16Qam1=rise_cos(insert_16Qam1,N,8*N);
out_16Qam2=rise_cos(insert_16Qam2,N,8*N);
%画出滤波后的信号
figure(5);
subplot(2,1,1);
n=1:100;
plot(n,out_16Qam1(1:100),'.-r');
hold on;
m=25:104;
stem(m,insert_16Qam1(1:80),'o');
legend('滤波输出信号','输入信号');
title('通过平方根升余弦滤波器滤波得到16QAM实部输出信号（10个周期）');
subplot(2,1,2);
plot(n,out_16Qam2(1:100),'.-r');
hold on;
stem(m,insert_16Qam2(1:80),'y');
legend('滤波输出信号','输入信号');
title('通过平方根升余弦滤波器滤波得到16QAM虚部输出信号（10个周期）');

%********输出信号眼图********
%滤波后两路信号合并，表达成复数形式
eyediagram(out_16Qam1,5*8);
title('16QAM实部眼图');
eyediagram(out_16Qam2,5*8);
title('16QAM虚部眼图');

%********输出信号功率谱密度********
out_16Qam=out_16Qam1+i*out_16Qam2;
R_I=xcorr(out_16Qam);
power_16Qam=fft(R_I);
figure(8);
plot(10*log10(abs(power_16Qam(1:(length(power_16Qam)+1)/2)))-max(10*log10(abs(power_16Qam(1:(length(power_16Qam)+1)/2)))));
grid on;
xlabel('频率');
ylabel('dB');
title('16QAM功率谱密度');
