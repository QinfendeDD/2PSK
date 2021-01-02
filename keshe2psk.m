clear all; 
close all;
clc;
%%
max=10;
g=zeros(1,max);
g=randi([0 1],max,1)     %长度为max的随机二进制序列
cp=[];
mod1=[];
f=2*pi;                    
fc=10000;                  %载波频率
fs=90000;                  %采样率
Sp=200;                     %每个值100个采样点
t=0:2*pi/199:2*pi;
for n=1:length(g)
    if g(n)==0 
        A=zeros(1,Sp);   %每个值100个点          
    else g(n)=1;
        A=ones(1,Sp);          
    end
    cp=[cp A];                   %码元宽度100  
    c=cos(f*t*fc);                   %载波信号  
    mod1=[mod1 c];         %与s(t)等长的载波信号,变为矩阵形式
end
 figure(1);subplot(4,2,1);plot(cp);grid on;
 axis([0 200*length(g) -2 2]);title('二进制信号序列');
 xlabel("t/s");
 ylabel('码值');
 se1 = [];
 se1 = [se1 2*g-1];
%%
cm=[];mod=[];
for n=1:length(g)
    if g(n)==0; 
        B=ones(1,Sp);      %每个值200个点 
        c=cos(f*t);            %载波信号
    else g(n)=1;
        B=ones(1,Sp); 
        c=cos(f*t+pi);      %载波信号
    end
    cm=[cm B];              %s(t)码元宽度200   
    mod=[mod c];          %与s(t)等长的载波信号
end
tiaoz=cm.*mod;          %e(t)调制
%% 绘图
figure(1) ; subplot (4, 2, 2);plot(tiaoz) ;grid on;
axis([0 200*length(g) -2 2]);title( '2PSK调制信号');
 xlabel("t/s");
 ylabel('码值');
figure (2) ; subplot (4, 2, 1) ;plot (abs(fft(cp)));
axis([0 200*length(g) 0 400]) ;title('原始信号频谱');
 xlabel("t/s");
 ylabel('幅值');
figure(2) ; subplot (4, 2, 2) ;plot (abs(fft(tiaoz)));
axis([0 200*length(g) 0 400]);title('2PSK信号频谱');
 xlabel("t/s");
 ylabel('幅值');
%带有高斯白噪声的信道
tz=awgn(tiaoz, 10) ;%信号tiaoz中加入白噪声，信噪比为10
figure (1) ;subplot (4, 2, 3) ;plot(tz);grid on
axis([0 200*length(g) -2 2]);
 xlabel("t/s");
 ylabel('码值');
title('通过高斯白噪声信道后的信号');
figure (2) ;subplot (4, 2, 3) ;plot (abs(fft(tz)));
axis([0 200*length(g) 0 400]);
 xlabel("t/s");
 ylabel('幅值');
title('加入白噪声的2PSK信号频谱');
jiet=2*mod1.*tz;%同步解调
figure(1) ; subplot (4, 2, 4) ;plot (jiet);grid on
axis([0 200*length(g) -2 2]);
 xlabel("t/s");
 ylabel('码值');
title('相乘后信号波形');
figure(2) ; subplot (4, 2, 4) ;plot (abs (fft (jiet)));
axis([0 200*length(g) 0 400]) ;
xlabel("t/s");
 ylabel('幅值');
 title('相乘后信号频谱');
%低通滤波器
fp=500; fs=700;rp=3;rs=20;fn=11025;
ws=fs/(fn/2); wp=fp/(fn/2) ;%计算归-一化角频率
[n, wn]=buttord(wp, ws, rp, rs) ;%计算阶数和截止频率
[b, a]=butter (n, wn) ;%计算H(z)
% figure(4) ;freqz (b, a, 1000, 11025) ;subplot(2, 1, 1);
% axis([0 4000 -100 3 ])
% title(' LPF幅频相频图' );
jt=filter(b, a, jiet);
figure(1) ; subplot (4, 2, 5) ;plot(jt);grid on
axis([0 200*length(g) -2 2]) ;
 xlabel("t/s");
 ylabel('码值');
title('经低通滤波器后信号波形')
figure (2) ;subplot (4, 2, 5) ;plot (abs (fft(jt)));
axis([0 200*length(g) 0 400]);
 xlabel("t/s");
 ylabel('幅值');
title('经低通滤波器后信号频谱');
%抽样判决
for m=1:200*length(g);
    if jt(m)<0;
        jt(m)=1;
    else jt(m)>=0;
        jt (m)=0;
    end
end
figure(1) ;subplot (4, 2, 6) ;plot(jt);grid on;
axis([0 200*length(g) -2 2]);
 xlabel("t/s");
 ylabel('码值');
title(' 经抽样判决后信号s^ (t)波形')
figure (2) ; subplot (4, 2, 6) ;plot (abs (fft(jt)));
axis([0 200*length(g) 0 400]) ;
 xlabel("t/s");
 ylabel('幅值');
title('经抽样判决后信号频谱');
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
legend('BPSK仿真误码率','BPSK理论误码率');