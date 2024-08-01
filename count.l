%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int char_count = 0;
int line_count = 0;
int word_count = 0;
int in_word = 0;

void count_char(char c) {
    if (c != ' ' && c != '\t' && c != '\n' && c != '\r') {
        char_count++;
    }
}

void count_word(char c) {
    if (isspace(c) || c == EOF) {
        if (in_word) {
            word_count++;
            in_word = 0;
        }
    } else {
        if (!in_word) {
            in_word = 1;
        }
    }
}
%}

%x COMMENT

%%

"/*"                { BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT>.|\n       { /* Ignore characters within comments */ }

"//".*              { /* Ignore single line comments */ }

[ \t\r]+            { /* Ignore spaces, tabs, and carriage returns */ }
\n                  { line_count++; }
.                   { count_char(yytext[0]); count_word(yytext[0]); }

%%

int main() {
    char filename[256];
    printf("Enter the input file name: ");
    scanf("%255s", filename);

    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("fopen");
        return 1;
    }

    yyin = file;
    yylex();

    fclose(file);

    printf("Number of characters: %d\n", char_count);
    printf("Number of lines: %d\n", line_count);
    printf("Number of words: %d\n", word_count);

    return 0;
}

int yywrap() {
    return 1;
}
