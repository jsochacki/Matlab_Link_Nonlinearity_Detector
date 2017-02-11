function [vector_out]=round_decimals(vector_in,NUMBER_OF_DECIMAL_PLACES)
vector_out=[];
Rounding_digits=mod(vector_in,1*power(10,-NUMBER_OF_DECIMAL_PLACES));
Rounding_Value=5*power(10,-(NUMBER_OF_DECIMAL_PLACES+1));
Round_Down=Rounding_Value >= Rounding_digits;
vector_out=(vector_in-Rounding_digits).*Round_Down;
vector_out=vector_out+(vector_in-Rounding_digits+1*power(10,-NUMBER_OF_DECIMAL_PLACES)).*~Round_Down;
end