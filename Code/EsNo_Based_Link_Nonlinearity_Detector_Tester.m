clear all

EsNo_base=5; ERROR_LIMIT=100;
JUMP=0; AWGN=1;

%PA stuff for tot deg
pa_coefficients=[(1.1500+j*0.7715) (0.1482-j*1.6597) (-0.5407+j*1.2630) (0.3631-j*0.4015) (-0.0903+j*0.0342)];
OBO_FROM_P1DB_vec=[4:-1:-3];
GINIT=0.1;

NSYMBOLS=2994*10; %10 D&I++ Frames
NSYMBOLS_LONG_FILTER=24; 
%24 is fine for 25 percent rolloff 4*24 is fine for 5 percent
%Standard at comtech %USAMPR is variable however at comtech but around 8 to 50 mean 24
USAMPR=8; ROLLOFF=0.25; ORDER=USAMPR*NSYMBOLS_LONG_FILTER;
SYMBOL_RATE=1; MOD_COD=1;
Fc=SYMBOL_RATE/2;

h=(firrcos(ORDER,Fc,ROLLOFF,USAMPR,'rolloff','sqrt'));

[complex_mapping Binary_Alphabet Decimal_Alphabet BITS_PER_WORD PARR_Remapping_Vector]=dvbs2_CBAM(MOD_COD);
Binary_Alphabet=custom_data_stream_to_words(Binary_Alphabet,BITS_PER_WORD);

for zzz=1:1:length(OBO_FROM_P1DB_vec)
BERCUR=0; BERVEC(zzz)=0;

ii=0; ERRORS=0; OBO_FROM_P1DB=OBO_FROM_P1DB_vec(zzz);
EsNo=EsNo_base-(OBO_FROM_P1DB_vec(1)-OBO_FROM_P1DB);

while ERRORS < ERROR_LIMIT
    clearvars -except sigma EsNo EsNo_base JUMP ERROR_LIMIT AWGN NSYMBOLS USAMPR h zzz BERVEC BERCUR ERRORS ii GAIN PAVGIN OBO_FROM_P1DB_vec OBO_FROM_P1DB pa_coefficients GINIT complex_mapping Binary_Alphabet Decimal_Alphabet BITS_PER_WORD PARR_Remapping_Vector MOD_COD
    
if 0==mod(ii,2)
    CONT=input('1 for jump out 0 for continue');
    if CONT
        JUMP=1;
    end
end

ii=ii+1;

s=randsrc(1,NSYMBOLS,complex_mapping);
unmapped_symbol_stream=s;

%Add pilot symbols (the modem does this for the pll (I do it to absorb
%any symbols that arent fully filtered yet (I.e. the BER was non zero
%untill i added these as there were a few screwed up symbols at
%the beginning of each batch as the filtere was not fully formed
%If you get non zero BER then make the PS longer
%Add pilot symbols 
PS=exp(1j*([0,3,1,2].'*pi/2+pi/4)).';
DATA_GOOD_AT_NP=(length(PS)*USAMPR)+(length(h)-1)/2;
unmapped_symbol_stream=[PS unmapped_symbol_stream PS];

sup=upsample(unmapped_symbol_stream,USAMPR);
sout=lconv(sup,h,'full');

%Normalize
sout=sout./max(abs(sout));

%Set OBO
if ii==1
    [GAIN]=set_OBO(sout,OBO_FROM_P1DB,pa_coefficients,GINIT);
    PAVGIN=10*log10((sout*sout')/(length(sout)*50*0.001));
else
    %SET INPUT POWER TO APPROPRIATE LEVEL
    INGAIN=0.01; temp_LIN=[];
    temp_LIN=sout*INGAIN;
    NPAVGIN=10*log10((temp_LIN*temp_LIN')/(length(temp_LIN)*50*0.001));
    %FIND P1DB
    while NPAVGIN < PAVGIN
    INGAIN=INGAIN+0.01;
    temp_LIN=sout*INGAIN;
    NPAVGIN=10*log10((temp_LIN*temp_LIN')/(length(temp_LIN)*50*0.001));
    end
    sout=sout*INGAIN;
end
%Pass through PA
temp=[]; temp=sout*GAIN; sout=[];
sout=ooVSSPA(temp,pa_coefficients,[]);
%Sanity Check
%plot(10*log10((temp)/(50*0.001)),10*log10((sout)/(50*0.001))-10*log10((temp)/(50*0.001)),'b.')

%Rename to confuse you
sout_NP=sout;
%Rename to confuse you

sout_PAP2=sout;
DATA_GOOD_AT_AP=(length(PS)*USAMPR)+(length(h)-1)/2;
if AWGN
    %[sout_PAP2]=AWNG_Generator(sout_PAP2,EsNo/BITS_PER_WORD,USAMPR,h,BITS_PER_WORD);
    if zzz==1
        cpawgn=[];
        CHOPNP=(length(h)-1)/2;
        cpawgn=sout_PAP2((1+(CHOPNP)):1:(end-(CHOPNP)));
        EbNo=power(10,(EsNo/BITS_PER_WORD)/10);
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
    end
    if isreal(sout_PAP2)
        Addative_White_Gaussian_Noise=sigma*randn(1,size(sout_PAP2,2));
    else
        Addative_White_Gaussian_Noise=sigma*randn(1,size(sout_PAP2,2)) +i*sigma*randn(1,size(sout_PAP2,2));
    end
    sout_PAP2=sout_PAP2+Addative_White_Gaussian_Noise;
end


nn=1;

GAIN=0.1;
TX_POWER_OUT_dBm_NP=10*log10((sout_NP*sout_NP')/(length(sout_NP)*50*0.001));
TX_POWER_OUT_dBm_AP2=10*log10(((sout_PAP2)*((sout_PAP2')))/(length(sout_PAP2)*50*0.001));

[TX_POWER_OUT_dBm_NP;TX_POWER_OUT_dBm_AP2]

sout_NP_GDO=sout_NP;
sout_AP2_GDO=sout_PAP2;

bbdata_rx=lconv(sout_AP2_GDO,fliplr(h),'full');

expected_bbdata_rx=lconv(sout_NP_GDO,fliplr(h),'full');

%Align the processed vector
expected_bbdata_rx=circ_shift_2_to_1(sup,expected_bbdata_rx);
bbdata_rx=circ_shift_2_to_1(sup,bbdata_rx);

%Chop off ring up and down to pretend it is continuous signal
%Chop needs to be dynamic so it changes with the length of h and the QMF
%coeffs
expected_bbdata_rx=expected_bbdata_rx(1:1:(end-(length(expected_bbdata_rx)-length(sup))));
bbdata_rx=bbdata_rx(1:1:length(expected_bbdata_rx));
%Chop off ring up and down to pretend it is continuous signal

bbdata_rx=downsample(bbdata_rx./max(abs(bbdata_rx)),USAMPR);
expected_bbdata_rx=downsample(expected_bbdata_rx./max(abs(expected_bbdata_rx)),USAMPR);

%GetBBdata befor you chop ring off for power measurements

%Remove pilot symbols
bbdata_rx=bbdata_rx((1+length(PS)):1:(end-length(PS)));
expected_bbdata_rx=expected_bbdata_rx((1+length(PS)):1:(end-length(PS)));

%Normalize
bbdata_rx=bbdata_rx./max(abs(bbdata_rx));
expected_bbdata_rx=expected_bbdata_rx./max(abs(expected_bbdata_rx));

%Decode
%TO GET PROPER BER YOU MUST DO WHAT IS BELOW!!!!!!!
expected_decode_mapping=(mean(abs(expected_bbdata_rx))).*complex_mapping./max(abs(complex_mapping));
decode_mapping=(mean(abs(bbdata_rx))).*complex_mapping./max(abs(complex_mapping));
rescale=mean(abs(expected_decode_mapping))/mean(abs(decode_mapping));
[decoded_complex_stream]=AWGN_maximum_likelyhood_decoder(bbdata_rx,decode_mapping,complex_mapping);
decoded_binary_word_stream=custom_mapper(decoded_complex_stream.',complex_mapping,Binary_Alphabet);
[expected_unmapped_symbol_stream]=AWGN_maximum_likelyhood_decoder(expected_bbdata_rx,expected_decode_mapping,complex_mapping);
expected_decoded_binary_word_stream=custom_mapper(expected_unmapped_symbol_stream.',complex_mapping,Binary_Alphabet);
if length(decoded_complex_stream)>length(expected_unmapped_symbol_stream)
    Bit_Errors=sum(sum(abs(expected_decoded_binary_word_stream-decoded_binary_word_stream(1:1:length(expected_unmapped_symbol_stream),:))));
elseif length(decoded_complex_stream)<length(expected_unmapped_symbol_stream)
    Bit_Errors=sum(sum(abs(expected_decoded_binary_word_stream(1:1:length(decoded_complex_stream),:)-decoded_binary_word_stream)));
else
    Bit_Errors=sum(sum(abs(expected_decoded_binary_word_stream-decoded_binary_word_stream)));
end
BER=Bit_Errors/(size(expected_decoded_binary_word_stream,1)*size(expected_decoded_binary_word_stream,2));
[BER Bit_Errors]

ERRORS=ERRORS+Bit_Errors;
BERCUR=ERRORS/(ii*NSYMBOLS*BITS_PER_WORD);
[BERCUR ERRORS]
if JUMP
    ERRORS=ERROR_LIMIT;
    JUMP=0; 
end
EsNo
Custom_Waveform_EsNo(bbdata_rx.*rescale,expected_bbdata_rx)

BERVEC(zzz)=BERVEC(zzz)+Custom_Waveform_EsNo(bbdata_rx.*rescale,expected_bbdata_rx);
end

BERVEC(zzz)=BERVEC(zzz)/ii;
end
hold on
plot(OBO_FROM_P1DB_vec,BERVEC,'b-o')
grid on

%save('.///_1_25_PercentRO.mat')

% load('QPSK_Standard.mat')
% semilogy(EbNo_dB_vec,BERVEC,'b-o')
% hold on
% load('QPSK_TYPE_0_RED_1_25_PercentRO.mat')
% semilogy(EbNo_dB_vec,BERVEC,'r-o')
% load('QPSK_TYPE_1_RED_1_25_PercentRO.mat')
% semilogy(EbNo_dB_vec,BERVEC,'k-o')
% load('QPSK_TYPE_2_RED_1_25_PercentRO.mat')
% semilogy(EbNo_dB_vec,BERVEC,'m-o')
% legend('Standard RRC PSF','Modified RRC PSF TYPE 0','Modified RRC PSF TYPE 1','Modified RRC PSF TYPE 2','location','northeast')
% title(sprintf('%s Channel Bit Error Rate',MODCODNAME))
% ylabel('BER (Errors / Bits Transmitted)'), xlabel('Eb/No (dB)')
% grid on

% figure(nn+3)
% hold off, plot(bbdata_rx,'ro')
% hold on, plot(expected_bbdata_rx,'ko')
% MPSF_EVM_dB=Custom_Waveform_EVM((mean(abs(bbdata_rx))).*bbdata_rx./max(abs(bbdata_rx)),(mean(abs(bbdata_rx))).*decoded_complex_stream./max(abs(decoded_complex_stream)));
% SPSF_EVM_dB=Custom_Waveform_EVM((mean(abs(expected_bbdata_rx))).*expected_bbdata_rx./max(abs(expected_bbdata_rx)),(mean(abs(expected_bbdata_rx))).*expected_unmapped_symbol_stream./max(abs(expected_unmapped_symbol_stream)));
% text(-0.4,-0.05,sprintf('Modified RRC PSF EVM = %2.3f dB',MPSF_EVM_dB))
% text(-0.4,0.05,sprintf('Standard RRC PSF EVM = %2.3f dB',SPSF_EVM_dB))
% legend('Modified RRC PSF','Standard RRC PSF','location','north')
% title(sprintf('Single %s Channel Received Complex Voltage',MODCODNAME))
% ylabel('Imaginary Voltage'), xlabel('Real Voltage')
% axis([-0.8 0.8 -0.8 1])
% grid on
% [SPSF_EVM_dB,MPSF_EVM_dB]
