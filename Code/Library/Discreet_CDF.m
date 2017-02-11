function [CDF X_Values]=Discreet_CDF(Statistical_Data_in,BITS_PER_WORD)
%%%SET BITS PER WORD TO 1 FOR NON BINARY DATA
Statistical_Data=sort(Statistical_Data_in,'ascend');
CDF=[]; X_Values=unique_values(Statistical_Data);
[pdf]=custom_bino_prob(Statistical_Data,X_Values,BITS_PER_WORD);
N=sum(pdf); Probability_distribution=pdf./N;
for n=1:1:length(Probability_distribution)
    if n==1
        CDF=[1-Probability_distribution(n)];
    else
        CDF=[CDF CDF(n-1)-Probability_distribution(n)];
    end
end
X_Values=[0 X_Values(1)-0.1 X_Values X_Values(end)+0.1 50];
CDF=[1 1 CDF 0 0];
end