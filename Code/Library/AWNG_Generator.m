function [Channel_With_Addative_White_Gaussian_Noise]=AWNG_Generator(channel,EbNo_dB,USAMPR,h,BITS_PER_WORD)
% Eb=length(channel)*((channel*channel')/length(channel))/(BITS_PER_WORD*length(channel)/USAMPR);
% No=Eb/power(10,EbNo/20);
% sigma=sqrt(No*SYMBOL_RATE/USAMPR);
cpawgn=[];
CHOPNP=(length(h)-1)/2;
cpawgn=channel((1+(CHOPNP)):1:(end-(CHOPNP)));
EbNo=power(10,EbNo_dB/10);
EsNo=EbNo*BITS_PER_WORD;
mup2=(1/length(cpawgn))*(cpawgn*cpawgn'); %RMS Power squared i.e. mean squared power
mup2=mup2*(USAMPR);
%sigma=sqrt(mup2/(2*(power(10,EbNo/10))*BITS_PER_WORD));  %must multiply bits per words linear or add 10log10 of to ebno in db
sigma=sqrt(mup2/(2*EsNo));  %must multiply bits per words linear or add 10log10 of to ebno in db
%sigma=sqrt(mup2/(EsNo));  %must multiply bits per words linear or add 10log10 of to ebno in db
%randn is a uniform random signal generator with mean=0
%unit variance (i.e. var = std ^2 therefor also std=1)
%also since it is unit variance, x*randn has a stx=x and var=x^2
%also for real systems var=No and for complex systems var=No/2
if isreal(channel)
    Addative_White_Gaussian_Noise=sigma*randn(1,size(channel,2));
else
    Addative_White_Gaussian_Noise=sigma*randn(1,size(channel,2)) +i*sigma*randn(1,size(channel,2));
end
Channel_With_Addative_White_Gaussian_Noise=channel+Addative_White_Gaussian_Noise;
end