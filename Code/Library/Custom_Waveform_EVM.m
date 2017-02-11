function [EVM_dB]=Custom_Waveform_EVM(rx_waveform,expected_waveform)
EVM_dB=[]; PERROR_Vector=[]; PREF_Vector=[];

VERROR=[];
VERROR=rx_waveform-expected_waveform;
PERROR_Vector=VERROR.*VERROR'.';
PREF_Vector=expected_waveform.*expected_waveform'.';

RMS_PERROR=sqrt((1/length(PERROR_Vector))*sum(PERROR_Vector));
RMS_PREF=sqrt((1/length(PREF_Vector))*sum(PREF_Vector));
EVM_dB=10*log10(RMS_PERROR/RMS_PREF);

end