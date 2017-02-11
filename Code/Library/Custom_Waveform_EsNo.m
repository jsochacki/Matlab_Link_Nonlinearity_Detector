function [EsNo_dB]=Custom_Waveform_EsNo(rx_waveform,expected_waveform)
EsNo_dB=[]; PERROR_Vector=[]; PREF_Vector=[];

VERROR=[];
VERROR=rx_waveform-expected_waveform;
PERROR_Vector=VERROR.*VERROR'.';
PREF_Vector=expected_waveform.*expected_waveform'.';

RMS_PERROR=sqrt((1/length(PERROR_Vector))*sum(PERROR_Vector));
RMS_PREF=sqrt((1/length(PREF_Vector))*sum(PREF_Vector));
EsNo_dB=10*log10(RMS_PREF/RMS_PERROR);

end