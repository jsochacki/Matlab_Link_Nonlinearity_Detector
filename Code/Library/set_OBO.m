function [GAIN]=set_OBO(input,OBO_FROM_P1DB,pa_coefficients,GINIT)
GAIN=GINIT; temp_LIN=[]; temp_NLIN=[]; P1DB=[]; PAGLIN=[]; NLINPCOMP=[]; LINPCOMP=[];

lin_input=[]; ssvout=[]; PAOGLIN=[]; PAIGLIN=[];
%FING SS GAIN
lin_input=input*0.001;
ssvout=ooVSSPA(lin_input,pa_coefficients,[]);
PAOGLIN=10*log10((ssvout*ssvout')/(length(ssvout)*50*0.001));
PAIGLIN=10*log10((lin_input*lin_input')/(length(lin_input)*50*0.001));
PAGLIN=abs(abs(PAOGLIN)-abs(PAIGLIN));
%FOUND SS GAIN

temp_LIN=input*GAIN;
temp_NLIN=ooVSSPA(input*GAIN,pa_coefficients,[]);

%FIND P1DB
TX_POWER_OUT_dBm_LIN=10*log10((temp_LIN*temp_LIN')/(length(temp_LIN)*50*0.001));
TX_POWER_OUT_dBm_NLIN=10*log10((temp_NLIN*temp_NLIN')/(length(temp_NLIN)*50*0.001));
while TX_POWER_OUT_dBm_NLIN > (TX_POWER_OUT_dBm_LIN+PAGLIN-1)
GAIN=GAIN+0.01;
temp_LIN=input*GAIN;
temp_NLIN=ooVSSPA(input*GAIN,pa_coefficients,[]);
TX_POWER_OUT_dBm_LIN=10*log10((temp_LIN*temp_LIN')/(length(temp_LIN)*50*0.001));
TX_POWER_OUT_dBm_NLIN=10*log10((temp_NLIN*temp_NLIN')/(length(temp_NLIN)*50*0.001));
end
temp_LIN=input*GAIN;
temp_NLIN=ooVSSPA(input*GAIN,pa_coefficients,[]);
TX_POWER_OUT_dBm_LIN=10*log10((temp_LIN*temp_LIN')/(length(temp_LIN)*50*0.001));
TX_POWER_OUT_dBm_NLIN=10*log10((temp_NLIN*temp_NLIN')/(length(temp_NLIN)*50*0.001));
P1DB=TX_POWER_OUT_dBm_NLIN;
%FOUND P1DB

if OBO_FROM_P1DB
    %SET OBO GAIN
    while TX_POWER_OUT_dBm_NLIN > (P1DB-OBO_FROM_P1DB)
    GAIN=GAIN-0.01;
    temp_NLIN=ooVSSPA(input*GAIN,pa_coefficients,[]);
    TX_POWER_OUT_dBm_NLIN=10*log10((temp_NLIN*temp_NLIN')/(length(temp_NLIN)*50*0.001));
    end
end

end