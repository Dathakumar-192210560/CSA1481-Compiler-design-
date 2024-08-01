lex word_count.l
gcc lex.yy.c -o word_count -ll
./word_count <word> <sentence>

