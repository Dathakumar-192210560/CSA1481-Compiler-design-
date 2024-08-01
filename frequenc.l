%{
#include <stdio.h>
#include <string.h>

int count = 0;
char word[100];
%}

%%
[a-zA-Z0-9]+ {
    if (strcmp(yytext, word) == 0) {
        count++;
    }
}
.|\n;
%%

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <word> <sentence>\n", argv[0]);
        return 1;
    }

    strcpy(word, argv[1]);
    yy_scan_string(argv[2]);
    yylex();
    
    printf("The word '%s' appears %d times in the sentence.\n", word, count);
    return 0;
}

int yywrap() {
    return 1;
}
