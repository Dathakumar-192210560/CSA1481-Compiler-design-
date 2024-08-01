%{
#include <stdio.h>
%}

%%
"//".*                 { /* Ignore single line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore multi-line comments */ }

"\""[^\"]*"\""         { /* Ignore string literals */ }

"\'"[^']"\'"           { /* Ignore character constants */ }

[0-9]+"."[0-9]+        { printf("Float constant: %s\n", yytext); }
[0-9]+                 { printf("Integer constant: %s\n", yytext); }
0[xX][0-9a-fA-F]+      { printf("Hex constant: %s\n", yytext); }
0[0-7]+                { printf("Octal constant: %s\n", yytext); }

.                      { /* Ignore all other characters */ }

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
