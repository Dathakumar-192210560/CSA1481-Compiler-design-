%{
#include <stdio.h>
%}

%%
"<"[a-zA-Z][^>]*">" { printf("%s\n", yytext); }
[^<]+              { /* Ignore non-tag text */ }
%%

int main() {
    printf("Enter the HTML file name: ");
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
