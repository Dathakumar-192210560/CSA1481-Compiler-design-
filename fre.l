%{
#include <stdio.h>
#include <string.h>

char word[100];
int count = 0;
%}
%%

\n      { /* Do nothing, skip newline */ }

.|\t    { /* Do nothing, skip other characters and tabs */ }

{word}  { count++; }

%%
int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <word> <sentence>\n", argv[0]);
        return 1;
    }

    strcpy(word, argv[1]);
    count = 0;

    yy_scan_string(argv[2]);
    yylex();
    
    printf("The word '%s' appears %d times in the given sentence.\n", word, count);

    return 0;
}
