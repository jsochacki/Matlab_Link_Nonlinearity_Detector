function [vec_2_new]=circ_shift_2_to_1(vec_1_in,vec_2_in)
%This function aligns vec_2_in with vec_1_in by circularly shifting
%vec_2_in and then makeing it vec_2_new

[MAG IND]=sort(abs(xcorr(vec_1_in,vec_2_in)),'descend');
shift=((length(MAG)+1)/2)-IND(1);
    
if shift > 1
    vec_2_new=[vec_2_in((1+shift):1:end) vec_2_in(1:1:(shift))];
elseif shift < 1
    vec_2_new=[vec_2_in((end+shift+1):1:end) vec_2_in(1:1:(end+shift))];
else
    vec_2_new=vec_2_in;
end

end