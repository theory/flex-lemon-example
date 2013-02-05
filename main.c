#include <stdio.h>
#include <stdlib.h>
#include "shellparser.h"
#include "shellscanner.h"

void* ParseAlloc(void* (*allocProc)(size_t));
void* Parse(void*, int, const char*);
void* ParseFree(void*, void(*freeProc)(void*));

int main(int argc, char** argv) {
    // Set up the scanner
    yyscan_t scanner;
    yylex_init(&scanner);
    yyset_in(stdin, scanner);

    // Set up the parser
    void* shellParser = ParseAlloc(malloc);

    // Do it!
    printf("> ");
    int lexCode;
    do {
        lexCode = yylex(scanner);
        Parse(shellParser, lexCode, yyget_text(scanner));
        // XXX This line should not be necessary; EOL should automatically
        // terminate parsing. :-(
        if (lexCode == EOL) Parse(shellParser, 0, NULL);
    } while (lexCode > 0);

    if (-1 == lexCode) {
        fprintf(stderr, "The scanner encountered an error.\n");
    }

    // Cleanup the scanner and parser
    yylex_destroy(scanner);
    ParseFree(shellParser, free);
    return 0;
}
