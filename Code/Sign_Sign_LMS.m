function [pdpa_coefficients_out mse]=Sign_Sign_LMS(Mu_Start,pa_coefficients,pdpa_coefficients_in,desired_signal,actual_signal)

Mu=Mu_Start;
error_vector=desired_signal-actual_signal;

[trash1 trash2 desired_signal_basis]...
         =ooVSSPA((actual_signal./max(abs(actual_signal))),pa_coefficients,[]);

for n=1:1:length(error_vector)
    [trash1 trash2 lin_signal_basis]...
         =ooVSSPA(desired_signal(n)./max(abs(desired_signal)),pdpa_coefficients_in,[]);
    [trash1 trash2 pa_signal_basis]...
         =ooVSSPA(trash1,pa_coefficients,[]); 
    if n==1
        %pdpa_coefficients_out=pdpa_coefficients_in-(Mu.*desired_signal_basis(:,n).*error_vector(n)).';
        pdpa_coefficients_out=pdpa_coefficients_in+Mu*...
        (CNAP_Update_Equation(lin_signal_basis,pa_signal_basis,pa_coefficients,error_vector(n),length(pa_coefficients),[])); 
    else
        %pdpa_coefficients_out=pdpa_coefficients_out-(Mu.*desired_signal_basis(:,n).*error_vector(n)).';
        pdpa_coefficients_out=pdpa_coefficients_out+Mu*...
        (CNAP_Update_Equation(lin_signal_basis,pa_signal_basis,pa_coefficients,error_vector(n),length(pa_coefficients),[])); 
    end    
end

% [pd_signal pdpa_coefficients_out]...
%         =ooVSSPA(desired_signal,pdpa_coefficients_out,[]);
% [output_signal pa_coefficients]...
%         =ooVSSPA(pd_signal,pa_coefficients,[]);
% mse=mean(power(abs(desired_signal-output_signal),2));

end