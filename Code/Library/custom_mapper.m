function [mapped_stream]=custom_mapper(unmapped_stream,mapping_from,mapping_to)

trn_UMS=0;
if size(unmapped_stream,1) < size(unmapped_stream,2), trn_UMS=1; unmapped_stream=unmapped_stream.';, end;
if size(mapping_from,1) < size(mapping_from,2), trn_MF=1; mapping_from=mapping_from.';, end;
if size(mapping_to,1) < size(mapping_to,2), trn_MT=1; mapping_to=mapping_to.';, end;

mapped_stream=[];
for nn=1:1:size(unmapped_stream,1)
    mapped_stream=[mapped_stream ;sum((sum((ones(size(mapping_from,1),1)*unmapped_stream(nn,:))==mapping_from,2) == size(unmapped_stream,2)).' * mapping_to,1)];
end

if trn_UMS, mapped_stream=mapped_stream.';, end;

end