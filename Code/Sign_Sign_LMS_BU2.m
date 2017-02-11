function [pdpa_coefficients_out]=Sign_Sign_LMS(Mu_Start,pa_coefficients,pdpa_coefficients_in,desired_signal,actual_signal)

Mu=Mu_Start;
error_vector=desired_signal-actual_signal;

%[actual_signal pa_coefficients desired_signal_basis]...
%         =ooVSSPA(desired_signal,pa_coefficients,[]);

for n=1:1:length(error_vector)
    if n==1
        cur_basis=[]; sign_update_real=[];
        cur_error=[]; sign_update_imag=[];
        cur_basis=((real(error_vector(n)))+j*(imag(error_vector(n))));
        cur_error=(sign(real(error_vector(n)))+j*sign(imag(error_vector(n))));
        sign_update_real=(real(cur_basis)*real(cur_error));
        sign_update_imag=(imag(cur_basis)*imag(cur_error));
        pdpa_coefficients_out=pdpa_coefficients_in-(Mu.*(sign_update_real+j*sign_update_imag)).';
    else
        cur_basis=[]; sign_update_real=[];
        cur_error=[]; sign_update_imag=[];
        cur_basis=((real(error_vector(n)))+j*(imag(error_vector(n))));
        cur_error=(sign(real(error_vector(n)))+j*sign(imag(error_vector(n))));
        sign_update_real=(real(cur_basis)*real(cur_error));
        sign_update_imag=(imag(cur_basis)*imag(cur_error));
        pdpa_coefficients_out=pdpa_coefficients_out-(Mu.*(sign_update_real+j*sign_update_imag)).';
    end    
end

% [pd_signal pdpa_coefficients_out]...
%         =ooVSSPA(desired_signal,pdpa_coefficients_out,[]);
% [output_signal pa_coefficients]...
%         =ooVSSPA(pd_signal,pa_coefficients,[]);
% mse=mean(power(abs(desired_signal-output_signal),2));

end