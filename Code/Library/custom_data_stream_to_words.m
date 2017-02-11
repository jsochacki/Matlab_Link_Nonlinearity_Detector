function [word_stream]=custom_data_stream_to_words(data_stream,BITS_PER_WORD)
%%%%TAKES A SINGLE ROW OF ANY TYPE OF DATA STREAM AND MAKES IT A COLUMN VECTOR
%%%%WHERE EACH ROW IS A WORD MADE OF 'BITS_PER_WORD' BITS SUCH THAT
%%%%IF 'BITS_PER_WORD'=LENGTH(data_stream) THEN WORD_STREAM IS EQUAL
%%%%TO DATA_STREAM.  IF DATA_STREAM IS BINARY DATA THEN THIS WILL
%%%%PROCESS BINARY DATA BUT IF DATA_STREAM IS DECIMAL SIMPLY MAKE
%%%%BITS_PER_WORD=1 AND THIS WILL COLLUMIZE THE DECIMAL DATA FOR
%%%%PROPER PROCESSING IN OTHER FUNCTION
trn=0;
word_stream=[];
if size(data_stream,1) > 1, trn=1; data_stream=data_stream.';, end;
for nn=1:BITS_PER_WORD:length(data_stream)
    word_stream=[word_stream;data_stream(nn:(nn+BITS_PER_WORD-1))];
end
if trn, word_stream=word_stream.';, end;
end