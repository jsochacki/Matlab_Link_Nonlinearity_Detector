function [decimal]=custom_bin_to_dec(binary_stream,BITS_PER_WORD)
    trn=0;
    decimal=[]; binary_table=power(2,(BITS_PER_WORD-1):-1:0);
    if size(binary_stream,1) > 1, trn=1; binary_stream=binary_stream.';, end;
    for nn=1:BITS_PER_WORD:length(binary_stream/BITS_PER_WORD)
        Symbol=sum(binary_stream(nn:(nn+BITS_PER_WORD-1)) .* binary_table);
        decimal=[decimal Symbol];
    end
    if trn, decimal=decimal.';, end;
end