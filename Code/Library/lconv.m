function [result error]=lconv(x,y,OPTION)

%%NEEDS THIS TO DO THE no ring OPTION PORPERLY
if length(x) < length(y)
    z=y; y=x; x=z; clear z;
end

N=length(x); M=length(y);
x=[zeros(1,M-1) x zeros(1,M-1)];

if strcmp(OPTION,'no ring')
    CHOP_FRONT=M; CHOP_END=M-1;
    result=zeros(1,((2*M)-1)-(N+M-1)+1);
elseif strcmp(OPTION,'full')
    CHOP_FRONT=1; CHOP_END=0;
	result=zeros(1,N+M-1);
end

%%NON VECTORIZED FORM
for n=CHOP_FRONT:1:M+N-1-CHOP_END
    result(n-CHOP_FRONT+1)=sum(y.*x(n+(M-1):-1:n));
end
%%NON VECTORIZED FORM

%%VECTORIZED FORM
% A=[];
% for n=CHOP_FRONT:1:M+N-1-CHOP_END
% A(n-CHOP_FRONT+1,:)=x(n+(M-1):-1:n);
% end
% result=(A*y.').';
%%VECTORIZED FORM

end
