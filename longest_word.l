%{
#include <stdio.h>
#include <string.h>

int max_length = 0;
int current_length = 0;

%}

%%
[A-Za-z]+ {
    current_length = strlen(yytext);
    if (current_length > max_length) {
        max_length = current_length;
    }
}

[^A-Za-z]+ { /* Ignore non-alphabetic characters */ }

%%

int main() {
    printf("Enter text: ");
    yylex();
    printf("Length of the longest word: %d\n", max_length);
    return 0;
}

int yywrap() {
    return 1;
}
