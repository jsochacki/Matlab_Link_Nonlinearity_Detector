function [vec_1_new vec_2_new]=custom_align(vec_1_in,vec_2_in)
[MAG IND]=sort(abs(xcorr(vec_1_in,vec_2_in)),'descend');
shift=length(vec_1_in)-IND(1);
vec_2_temp=[];
if shift > 1
    %vec_2_temp=[vec_2_in((shift+1):1:end) vec_2_in(1:1:(shift))];
    vec_2_temp=[vec_2_in((shift+2):1:end) vec_2_in(1:1:(shift+1))];
    vec_1_new=vec_1_in;
    %vec_2_new=vec_2_temp((1+abs(length(vec_2_temp)-length(vec_1_new))):1:end);
    vec_2_new=vec_2_temp(1:1:(end-abs(length(vec_2_temp)-length(vec_1_new))));
elseif shift == 0
    vec_1_new=vec_1_in;
    %vec_2_new=vec_2_temp((1+abs(length(vec_2_temp)-length(vec_1_new))):1:end);
    vec_2_new=vec_2_in((1+abs(length(vec_2_in)-length(vec_1_new))):1:end);
else
    if abs(shift) > length(vec_2_in)
        temp=length(vec_2_in)+shift;
        vec_2_in=[vec_2_in((temp+1):1:end) vec_2_in(1:1:(temp))];
    else
        vec_2_temp=[vec_2_in((end+shift+1):1:end) vec_2_in(1:1:((end+shift)))];
    end
    vec_1_new=vec_1_in;
    %vec_2_new=vec_2_temp((1+abs(length(vec_2_temp)-length(vec_1_new))):1:end);
    vec_2_new=vec_2_temp(1:1:(end-abs(length(vec_2_temp)-length(vec_1_new))));
end
end