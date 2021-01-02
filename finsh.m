close all;
clear
clc; 

%%
max=10; 
s = round(rand(1,max)) %产生介于0-1之间的长度为max的1列随机序列
Sinput=[] ; 
for n=1:length(s)
    if s(n)==0
        A=zeros(1,2000);    %码元宽度为2000
    else
        s(n)=1;
        A=ones(1,2000);
    end 
    Sinput=[Sinput A]; 
end  
% Sinput      %Sinput包含22000列个二进制数字
figure(1);
subplot(2,1,1);
plot(Sinput);
grid on 
axis([0,2000*length(s),-2,2]);
title('输入信号波形'); 
Sbianma=encode(s,15,11,'hamming') %汉明码编码后序列，一行15列的二进制数字
a1=[];
b1=[];
f=1000; 
t=0:2*pi/1999:2*pi; 
for n=1:length(Sbianma)
    if Sbianma(n)==0
        B=zeros(1,2000);  %每个值2000个点
    else
        Sbianma(n)=1; 
        B=ones(1,2000);
    end 
    a1=[a1 B];  %s(t),码元宽度2000
    c=cos(2*pi*t);  %载波信号 
    b1=[b1 c];  %与s(t)等长的载波信号，变为矩阵形式
end 
figure(10);
c=cos(2*pi*t);  %载波信号
plot(c);
xlabel('t/s');
ylabel('幅值');
title('载波信号');
%%
se1 = [];
se1 = [se1 2*s-1];
% figure
% plot(se1);
% title('双极性不归零码');
% xlabel('t/s');
% ylabel('码值');
% axis([0,5,-2,2]);
%%
figure(2);
subplot(2,1,1)
plot(a1);
grid on; 
axis([0 2000*length(Sbianma) -2 2]);
title('编码后二进制信号序列');
subplot(2,1,2); 
plot(abs(fft(a1)));
axis([0 2000*length(Sbianma) 0 400]);
title('编码后二进制信号序列频谱');
a2=[];
b2=[];
for n=1:length(Sbianma)
    if Sbianma(n)==0
        C=ones(1,2000);  %每个值2000点
        d=cos(2*pi*t);  %载波信号
    else
        Sbianma(n)=1; 
        C=ones(1,2000);
        d=cos(2*pi*t+pi);  %载波信号
    end 
    a2=[a2 C];  %s(t),码元宽度2000
    b2=[b2 d];  %与s(t)等长的载波信号 
end 
tiaoz=a2.*b2;  %e(t)调制
figure(3);
subplot(2,1,1);
plot(tiaoz);
grid on; 
axis([0 2000*length(Sbianma) -2 2]);
title('2psk已调制信号');
subplot(2,1,2); 
plot(abs(fft(tiaoz))); 
axis([0 2000*length(Sbianma) 0 400]);
title('2psk信号频谱') 
%-----------------带有高斯白噪声的信道---------------------
tz=awgn(tiaoz,10);  %信号tiaoz加入白噪声,信噪比为10
figure(4);
subplot(2,1,1);
plot(tz);
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('通过高斯白噪声后的信号');
subplot(2,1,2); 
plot(abs(fft(tz))); 
axis([0 2000*length(Sbianma) 0 800]);
title('加入白噪声的2psk信号频谱'); 
%-------------------同步解调-------------
jiet=2*b1.*tz;  %同步解调
figure(5); 
subplot(2,1,1);
plot(jiet);
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('加入噪声相干解调后的信号波形')
subplot(2,1,2);
plot(abs(fft(jiet))); 
axis([0 2000*length(Sbianma) 0 800]);
title('加入噪声相干解调后的信号频谱');
%--------------------------------没加噪声---------
jiet1=2*b1.*tiaoz;  %同步解调
figure(9); 
subplot(2,1,1);
plot(jiet1);
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('未加噪声相干解调后的信号波形')
subplot(2,1,2);
plot(abs(fft(jiet1))); 
axis([0 2000*length(Sbianma) 0 800]);
title('未加噪声相干解调后的信号频谱');
%----------------------低通滤波器--------------------------- 
fp=500;
fs=700;
rp=3;
rs=20;
fn=11025; 
ws=fs/(fn/2); 
wp=fp/(fn/2);  %计算归一化角频率 
[n,wn]=buttord(wp,ws,rp,rs);  %计算阶数和截止频率
[b,a]=butter(n,wn);  %计算H(z)
figure(6);
freqz(b,a,1000,11025);      %绘制低通滤波器的幅频特性曲线
% subplot(2,1,1); 
axis([0 40000 -100 3])
title('低通滤波器频谱图');
jt=filter(b,a,jiet);
figure(12);
subplot(2,1,1);
plot(jt);
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('经低通滤波器后的解调信号波形');
subplot(2,1,2);
plot(abs(fft(jt))); 
axis([0 2000*length(Sbianma) 0 800]);
title('经低通滤波器后的解调信号频谱'); 
%%--------------------未加噪声的低通滤波器输出-----------------------
fp=500;
fs=700;
rp=3;
rs=20;
fn=11025; 
ws=fs/(fn/2); 
wp=fp/(fn/2);  %计算归一化角频率 
[n,wn]=buttord(wp,ws,rp,rs);  %计算阶数和截止频率
[b,a]=butter(n,wn);  %计算H(z)
figure(11);
freqz(b,a,1000,11025);      %绘制低通滤波器的幅频特性曲线
% subplot(2,1,1); 
axis([0 40000 -100 3])
title('未加噪声的低通滤波器频谱图');
jt=filter(b,a,jiet1);
figure(7);
subplot(2,1,1);
plot(jt);
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('未加噪声经低通滤波器后的解调信号波形');
subplot(2,1,2);
plot(abs(fft(jt))); 
axis([0 2000*length(Sbianma) 0 800]);
title('未加噪声经低通滤波器后的解调信号频谱'); 
%-----------------------抽样判决--------------------------
for m=1:2000*length(Sbianma)
    if jt(m)<0
        jt(m)=1;
    else jt(m)>0
        jt(m)=0;
    end
end
figure(8);
subplot(2,1,1);
plot(jt)
grid on 
axis([0 2000*length(Sbianma) -2 2]);
title('经抽样判决后信号jt(t)波形')
subplot(2,1,2); 
plot(abs(fft(jt))); 
axis([0 2000*length(Sbianma) 0 800]); 
title('经抽样判决后的信号频谱');
grid on;
n=1:2000:2000*length(Sbianma);
a5=[]; 
a5=[a5 jt(n)]; 
s1=decode(a5,15,11,'hamming');
a6=[]; 
for n=1:length(s1)
    if s1(n)==0 
        G=zeros(1,2000);
    else
        s1(n)=1;
        G=ones(1,2000);
    end 
    a6=[a6 G];
end 
figure(1);
subplot(2,1,2);
plot(a6);
grid on
axis([0 2000*length(s) -2 2]);
title('汉明码译码后的波形')
grid on
snr_dB=1:10;  %信噪比范围
snr = 10.^(snr_dB/10); %单位换算
delt_fa = 10.^(-snr_dB/10);  %白噪声的方差  即噪声功率
delt = sqrt(delt_fa);  %噪声幅值（强度）
Pe = zeros(1,length(snr_dB));   %定义存放误码率的矩阵
for iter  = 1:length(snr_dB)
N = 100000; %二进制序列长度
fa_bit = randi([0 1],[1 N]); %bit stream 产生二进制随机序列，长度为N
fa_key = randi([0 1],[1 N]);  %密钥序列
fa_enc = bitxor(fa_bit,fa_key); %已加密钥序列
% m_s =2*fa_bit-1;  %double polar
m_s =2*fa_enc-1;  %double polar   加密钥后的双极性序列（BPSK信号）
me = mean(fa_key);  %求均值
av = var(fa_key);  %求方差
n =delt(iter)*(randn(1,N) + sqrt(-1)*randn(1,N))/sqrt(2); %复噪声
r = m_s + n; % BPSK信号加信道噪声
es_fa = sign(real(r));  %抽样判决
es_bit = (1+es_fa)/2;  %二进制序列（解调）
de_enc = bitxor(es_bit,fa_key);  %解密
Pe(iter) = sum(fa_bit~=de_enc)/N; %计算误码率
theory_Pe = erfc(sqrt(snr))/2; %计算理论误码率
end
figure
semilogy(snr_dB,Pe,'r-o',snr_dB,theory_Pe,'*-b');%画曲线
xlabel('信噪比SNR (dB) ');                          
ylabel('误码率BER'); 
title('误码率曲线 SNR/10dB')
legend('2PSK加噪误码率','2PSK理论误码率');