%{
#include <stdio.h>
#include <stdlib.h>

int char_count = 0;
int line_count = 0;
int word_count = 0;

void count_chars(char *text) {
    for (int i = 0; text[i] != '\0'; ++i) {
        char_count++;
    }
}

void count_words(char *text) {
    int in_word = 0;
    for (int i = 0; text[i] != '\0'; ++i) {
        if (text[i] == ' ' || text[i] == '\t' || text[i] == '\n' || text[i] == '\r') {
            if (in_word) {
                word_count++;
                in_word = 0;
            }
        } else {
            in_word = 1;
        }
    }
    if (in_word) word_count++;
}
%}

%x COMMENT

%%

"/*"                { BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT>.|\n       { /* Ignore characters within comments */ }

"//".*              { /* Ignore single line comments */ }

[ \t]+              { /* Ignore spaces and tabs */ }
\n                  { line_count++; }
.                   { count_chars(yytext); count_words(yytext); }

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