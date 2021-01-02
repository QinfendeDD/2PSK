%用有限冲击响应平方根升余弦滤波器进行低通滤波
%x输入信号，fd是输入信号的采样频率，fs是滤波后得到的信号的采样频率。
function y=rise_cos(x,fd,fs)
%生成平方根升余弦滤波器
[yf, tf]=rcosine(fd,fs, 'fir/sqrt');
%对信号进行滤波
[y, t]=rcosflt(x, fd,fs,'filter/fs',  yf);
figure(4);
stem(yf,'.');
title('升余弦滤波器的冲击响应');
grid on;


