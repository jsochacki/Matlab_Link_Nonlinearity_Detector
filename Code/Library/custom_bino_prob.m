function [pdf]=custom_bino_prob(data_block,alphabet,BITS_PER_WORD)
%alphabet is straigth from dvbs2_CBAM
%I reformat alphabet into a
%column vector with rows where a row is one symbol
%and each symbol is an a separate row
%this way symbols can be called with alphabet(symbol #,:)
%each row in the pdf corresponds to the symbol in same row in the apphabet
%can use with any alphabet, if non binary just set bits per word to 1 so
%long as each entry in alphabet only requires one entry
temp=[]; c=1;
for n=1:BITS_PER_WORD:length(alphabet/BITS_PER_WORD)
    temp(c,:)=alphabet(1,n:(n+BITS_PER_WORD-1)); c=c+1;
end
alphabet=[]; alphabet=temp;
pdf=zeros(length(alphabet),1); BITS_PER_WORD=size(alphabet,2);
for nn=1:BITS_PER_WORD:length(data_block/BITS_PER_WORD)
    for n=1:1:size(alphabet,1)
%        pdf(n)=pdf(n)+prod(data_block(nn:(nn+BITS_PER_WORD-1))==alphabet(n,:));
        pdf(n)=pdf(n)+prod(custom_bin_to_dec(data_block(nn:(nn+BITS_PER_WORD-1))==alphabet(n,:),1));
    end
end
end