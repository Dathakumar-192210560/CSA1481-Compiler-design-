%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

// Function to determine if a string is a floating-point constant
int is_float(const char *str) {
    int dot_count = 0;
    while (*str) {
        if (*str == '.') {
            if (++dot_count > 1) return 0;
        } else if (!isdigit(*str)) {
            return 0;
        }
        str++;
    }
    return dot_count == 1;
}
%}

%%
"//".*                   { /* Ignore single line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore multi-line comments */ }

[0-9]+"."[0-9]+          { printf("Float constant: %s\n", yytext); }
[0-9]+                   { printf("Integer constant: %s\n", yytext); }
0[xX][0-9a-fA-F]+        { printf("Hexadecimal constant: %s\n", yytext); }
0[0-7]+                  { printf("Octal constant: %s\n", yytext); }

\"[^\"]*\"               { /* Ignore string literals */ }
\'[^\']\'                { /* Ignore character constants */ }

[ \t\r\n]+               { /* Ignore whitespace */ }
.                        { /* Ignore all other characters */ }

%%

int main() {
    printf("Enter the input file name: ");
    char filename[256];
    scanf("%255s", filename);

    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("fopen");
        return 1;
    }

    yyin = file;
    yylex();

    fclose(file);

    return 0;
}

int yywrap() {
    return 1;
}
