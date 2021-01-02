clear;
Maxbit = 1000;
Eb = 1;
% fs = 0.01:0.01:Maxbit; 
% f = cos(fs*2*pi+pi/2);
% fs = sin(fs*2*pi+pi/2);
for j=1:4   
    i = j*5-15;
    b = rand(1,Maxbit);         
    b_bin = round(b);                
    b2 = sign(b_bin - 0.5);
    %     b3 = repmat(b2,Maxbit,1);
    %     b4 = reshape(b3,1,[]);
    %     z = f.*b4;
    %     plot(z);


    SNR = 10 ^( 0.1 * i);           
    N0 = Eb/SNR;
    Sigma = sqrt(N0/2);

    Noise = Sigma*randn(1,Maxbit);
    Noises = Sigma*randn(1,Maxbit);
    %             
    %       Noise2 = repmat(Noise,Maxbit,1);
    %       Noise3 = reshape(Noise2,1,[]);
    %       
    %       Noises2 = repmat(Noises,Maxbit,1);
    %       Noises3 = reshape(Noises2,1,[]);

    %       zn = Noise3.*f + Noises3.*fs;


    Snt = b2 + Noise;

    subplot(2,2,j);
    scatter(Snt,Noises,'+');
    hold on;
    scatter(-1,0,'red');
    hold on;
    scatter(1,0,'red');
    axis([-5 5,-5 5])

end
Maxbit = 1000000;
for j=1:31
    i = j-16;
    b = rand(1,Maxbit);         
    b_bin = round(b);                
    b2 = sign(b_bin - 0.5);

    SNR = 10 ^( 0.1 * i);           
    N0 = Eb/SNR;
    Sigma = sqrt(N0/2);
    Noise = Sigma*randn(1,Maxbit);

    Snt = b2 + Noise;
    res(Snt<0) = -1;
    res(Snt>=0) = 1;

    St = res .* b2;
    err(j) = length(find(St<=0));
    Pb(j) = err(j)/Maxbit*100;

end
figure(2);
semilogy(-15:1:15,Pb);
grid on;
xlabel('ÐÅÔë±È(dB)');
ylabel('ÎóÂëÂÊPe')