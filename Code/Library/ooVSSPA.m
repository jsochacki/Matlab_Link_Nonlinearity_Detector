function [voltage_out coefficient_set_1 VP_1 coefficient_set_2 VP_2]=ooVSSPA(voltage_in,coefficient_set_1,coefficient_set_2)

%the ss means single sample only i.e. DO NOT MAKE VOLTAGE_IN A VECTOR
%IT IS ONLY MEANT TO BE A SINGLE TIME SAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%[t tt ttt tttt]=ooPA(time,v,[2 -0.2],[])
%% even if you have no secondary coefficients
%%you must feed an empty vector to the second arguement
%%like in the example above as []

n_coefficient_set_1=size(coefficient_set_1,2);
voltage_temp_1=[]; voltage_temp_2=[];
%voltage_temp_1=0; voltage_temp_2=0;
error=[0 0]; emptyc2=isempty(coefficient_set_2);

switch emptyc2
    case 1
        n_coefficient_set_2=10;
    otherwise
        n_coefficient_set_2=size(coefficient_set_2,2);
end

switch n_coefficient_set_1
    case 0
        error(1)=1;
    case 1
        VP_1=[voltage_in];
    case 2
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2)];
    case 3
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4)];
    case 4
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6)];
    case 5
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8)];
    case 6
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10)]; 
    case 7
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12)];
    case 8
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12);voltage_in.*(abs(voltage_in).^14)];
    case 9
        VP_1=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12);voltage_in.*(abs(voltage_in).^14);...
			voltage_in.*(abs(voltage_in).^16)];     		
    otherwise
        error(1)=1;
end

switch n_coefficient_set_2
    case 0
        error(1)=1;
    case 1
        VP_2=[voltage_in];
    case 2
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2)];
    case 3
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4)];
    case 4
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6)];
    case 5
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8)];
    case 6
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10)]; 
    case 7
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12)];
    case 8
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12);voltage_in.*(abs(voltage_in).^14)];
    case 9
        VP_2=[voltage_in;voltage_in.*(abs(voltage_in).^2);...
            voltage_in.*(abs(voltage_in).^4);voltage_in.*(abs(voltage_in).^6);...
            voltage_in.*(abs(voltage_in).^8);voltage_in.*(abs(voltage_in).^10);...
			voltage_in.*(abs(voltage_in).^12);voltage_in.*(abs(voltage_in).^14);...
			voltage_in.*(abs(voltage_in).^16)]; 			
    case 10
        voltage_temp_2=0;
        coefficient_set_2=0;
        VP_2=0;
    otherwise
        error(2)=1;
end

voltage_temp_1=coefficient_set_1*VP_1;
%voltage_temp_2=coefficient_set_1*VP_2;
voltage_out=voltage_temp_1;%+voltage_temp_2;