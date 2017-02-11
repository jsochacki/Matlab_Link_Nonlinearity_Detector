function [Magnitude_Distortion Phase_Distortion Complex_Distortion Point_Averaged_Frame_Constellation]=Constellation_Distortion_Detector(MODCOD,Downsampled_Receive_Complex_Data_Frame,Corrected_Corresponding_Receive_Complex_Data_Location)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       USEAGE                               %
% MODCOD - This is the MODCOD of the current Receive_Data.   %
%                                                            %
% Downsampled_Receive_Complex_Data_Frame - This is one full  %
%             frame of the received compled data after it    %
%             has gone through the polyphase filter and is   %
%             at the data rate.                              %
%                                                            %
% Corrected_Corresponding_Receive_Complex_Data_Location -    %
%             This is the corrected corresponding location   %
%             of the very noisy data in                      %
%             Downsampled_Receive_Complex_Data_Frame vector  %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if MODCOD > 2

%FIRST I COME UP WITH THE DISTORTED, NOISE SUPRESSED CONSTELLATION

complex_ideal_constellation=[]; Point_Averaged_Frame_Constellation=[];
[complex_ideal_constellation Binary_Alphabet Decimal_Alphabet BITS_PER_WORD PARR_Remapping_Vector]=dvbs2_CBAM(MODCOD);

Ideal_Points_Complex_Basis=[];
Ideal_Points_Complex_Basis=(min(complex_ideal_constellation.*complex_ideal_constellation'.')...
    ==complex_ideal_constellation.*complex_ideal_constellation'.')...
    .*complex_ideal_constellation;

temp=[];
i=0; ii=1; temp=Ideal_Points_Complex_Basis; Ideal_Points_Complex_Basis=[];
for i=1:1:length(temp)
    if temp(i) ~= 0
        Ideal_Points_Complex_Basis(ii)=temp(i);
        ii=ii+1;
    end
end

i=0;
for i=1:1:length(complex_ideal_constellation)
    temp=[];
    temp=(complex_ideal_constellation(i)==Corrected_Corresponding_Receive_Complex_Data_Location);
    Point_Averaged_Frame_Constellation(i)=sum(Downsampled_Receive_Complex_Data_Frame.*temp)/sum(temp);
end

Point_Averaged_Frame_Constellation=max(sqrt(complex_ideal_constellation.*complex_ideal_constellation'.')).*Point_Averaged_Frame_Constellation./max(sqrt(Point_Averaged_Frame_Constellation.*Point_Averaged_Frame_Constellation'.'));

Receive_Points_Complex_Basis=[];
Receive_Points_Complex_Basis=(min(Point_Averaged_Frame_Constellation.*Point_Averaged_Frame_Constellation'.')...
    ==Point_Averaged_Frame_Constellation.*Point_Averaged_Frame_Constellation'.')...
    .*Point_Averaged_Frame_Constellation;

temp=[];
i=0; ii=1; temp=Receive_Points_Complex_Basis; Receive_Points_Complex_Basis=[];
for i=1:1:length(temp)
    if temp(i) ~= 0
        Receive_Points_Complex_Basis(ii)=temp(i);
        ii=ii+1;
    end
end

%Can replace below section with single tap LMS filter and adapt that way
%DO phase alignment on inner symbols
temp=[]; rotation=1:1:length(complex_ideal_constellation);
temp=(Receive_Points_Complex_Basis-complex_ideal_constellation);
Receive_Points_Complex_Basis_Angle_Point=sum(rotation.*(min(sqrt(temp.*temp'.'))==sqrt(temp.*temp'.')));
Linear_Derotation_Angle=atan2(imag(Point_Averaged_Frame_Constellation(Receive_Points_Complex_Basis_Angle_Point)),...
    real(Point_Averaged_Frame_Constellation(Receive_Points_Complex_Basis_Angle_Point)))...
    -atan2(imag(complex_ideal_constellation(Receive_Points_Complex_Basis_Angle_Point)),...
    real(complex_ideal_constellation(Receive_Points_Complex_Basis_Angle_Point)));
Point_Averaged_Frame_Constellation=Point_Averaged_Frame_Constellation.*exp(-j*Linear_Derotation_Angle);

%Find 90 degree alignment
i=0; error=[]; rotation=[0];
error=[sum(sqrt((Point_Averaged_Frame_Constellation-complex_ideal_constellation).*(Point_Averaged_Frame_Constellation-complex_ideal_constellation)'.'))./length(complex_ideal_constellation)];
for i=1:1:3
    error=[error sum(sqrt((exp(-j*(pi/2)*i).*Point_Averaged_Frame_Constellation...
        -complex_ideal_constellation).*(exp(-j*(pi/2)*i).*Point_Averaged_Frame_Constellation...
        -complex_ideal_constellation)'.'))./length(complex_ideal_constellation)];
    rotation=[rotation i];
end
    
Point_Averaged_Frame_Constellation=Point_Averaged_Frame_Constellation.*exp(-j*(pi/2)*sum(rotation.*(error==min(error))));

%THEN I CALCULATE THE DISTORTION

Complex_Distortion=complex_ideal_constellation-Point_Averaged_Frame_Constellation;
Magnitude_Distortion=sqrt(Complex_Distortion.*Complex_Distortion'.');
Phase_Distortion=atan2(imag(complex_ideal_constellation),real(complex_ideal_constellation))-...
    atan2(imag(Point_Averaged_Frame_Constellation),real(Point_Averaged_Frame_Constellation));

else
    Magnitude_Distortion=10000;
    Phase_Distortion=Magnitude_Distortion;
end

end