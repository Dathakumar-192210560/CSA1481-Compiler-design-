#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>

const char *input;
char currentToken;

void nextToken() {
    currentToken = *input++;
    while (isspace(currentToken)) {
        currentToken = *input++;
    }
}

bool isDigit(char c) {
    return c >= '0' && c <= '9';
}

bool accept(char expectedToken) {
    if (currentToken == expectedToken) {
        nextToken();
        return true;
    }
    return false;
}

bool expect(char expectedToken) {
    if (accept(expectedToken)) {
        return true;
    }
    printf("Syntax error: expected '%c'\n", expectedToken);
    return false;
}

bool F(); // Forward declaration
bool T();
bool E();
bool E_prime();
bool T_prime();

bool F() {
    if (isDigit(currentToken)) {
        while (isDigit(currentToken)) {
            nextToken();
        }
        return true;
    } else if (accept('(')) {
        if (!E()) return false;
        return expect(')');
    }
    printf("Syntax error: unexpected character '%c'\n", currentToken);
    return false;
}

bool T() {
    if (!F()) return false;
    return T_prime();
}

bool T_prime() {
    if (accept('*')) {
        if (!F()) return false;
        return T_prime();
    } else if (accept('/')) {
        if (!F()) return false;
        return T_prime();
    }
    return true;
}

bool E() {
    if (!T()) return false;
    return E_prime();
}

bool E_prime() {
    if (accept('+')) {
        if (!T()) return false;
        return E_prime();
    } else if (accept('-')) {
        if (!T()) return false;
        return E_prime();
    }
    return true;
}

bool parse(const char *str) {
    input = str;
    nextToken();
    if (!E()) return false;
    if (currentToken != '\0') {
        printf("Syntax error: unexpected character '%c' at end of input\n", currentToken);
        return false;
    }
    return true;
}

int main() {
    const char *testStrings[] = {
        "3 + 5 * (10 - 4)",
        "10 / 2 - 3",
        "3 + 5 *",
        "(3 + 5",
        "3 + 5 * 10 - 4)",
        NULL
    };

    for (const char **str = testStrings; *str != NULL; str++) {
        printf("Testing \"%s\":\n", *str);
        if (parse(*str)) {
            printf("Valid\n");
        } else {
            printf("Invalid\n");
        }
    }

    return 0;
}
