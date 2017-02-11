function [PSD]=small_batch_FFT(input_signal,sample_per_batch)
%%%samples_per_batch must divisible by 2
N=floor(length(input_signal)/sample_per_batch);
%%THIS WILL ONLY PROCESS AN NUMBER OF SAMPLES THAT IS A MULTIPLE OF SAMPLES
%%PER BATCH, I.E. N
window=hamming(sample_per_batch).';
window=blackman(sample_per_batch).';
OFFSET=sample_per_batch/2;
s=0; VSD=zeros(1,sample_per_batch);
for s=0:1:((N-1)*2)
    VSD=VSD+abs(fft(window.*input_signal(((sample_per_batch*(s))+1-(s*OFFSET)):(sample_per_batch*(s+1))-(s*OFFSET)),sample_per_batch));
end
VSD=VSD./(sample_per_batch*(((N-1)*2)+1));
PSD=10*log10(power(abs(fftshift(VSD)),2)/(0.001*50));
end