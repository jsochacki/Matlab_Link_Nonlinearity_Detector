function [decoded_complex_stream]=AWGN_maximum_likelyhood_decoder(received_baseband_data,Constellation,complex_mapping)
trn=0;
if size(received_baseband_data,1) > size(received_baseband_data,2), received_baseband_data=received_baseband_data.';, trn=1;, end;

decoded_complex_stream=[];

for n=1:1:length(received_baseband_data)
    MAG=[]; IND=[]; EUCDIS=[];
    EUCDIS=(received_baseband_data(1,n)-Constellation).*(received_baseband_data(1,n)-Constellation)'.';
    [MAG IND]=sort(EUCDIS,'ascend');
    if sum(MAG(1)==MAG(2:1:length(MAG)))
        decoded_complex_stream=[decoded_complex_stream randsrc(1,1,complex_mapping(EUCDIS==MAG(1)))];
    else
        decoded_complex_stream=[decoded_complex_stream complex_mapping(IND(1))];
    end
end

if trn, decoded_complex_stream=decoded_complex_stream.';, end;

end