function [unique_values_vec]=unique_values(value_set)
unique_values_vec=[value_set(1)];
N=length(value_set);
for n=1:1:N
    if ~sum(unique_values_vec == value_set(n))
        unique_values_vec=[unique_values_vec value_set(n)];
    end
end
end