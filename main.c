#include <stdio.h>
#include <stdlib.h>
#include "shellparser.h"
#include "shellscanner.h"

void* ParseAlloc(void* (*allocProc)(size_t));
void* Parse(void*, int, const char*);
void* ParseFree(void*, void(*freeProc)(void*));

void parse(const char *commandLine) {
    // Set up the scanner
    yyscan_t scanner;
    yylex_init(&scanner);
    YY_BUFFER_STATE bufferState = yy_scan_string(commandLine, scanner);

    // Set up the parser
    void* shellParser = ParseAlloc(malloc);

    int lexCode;
    do {
        lexCode = yylex(scanner);
        Parse(shellParser, lexCode, NULL);
    } while (lexCode > 0);

    if (-1 == lexCode) {
        fprintf(stderr, "The scanner encountered an error.\n");
    }

    // Cleanup the scanner and parser
    yy_delete_buffer(bufferState, scanner);
    yylex_destroy(scanner);
    ParseFree(shellParser, free);
}

// Borrowed from http://stackoverflow.com/a/314422/79202.
char * getline(void) {
    char * line = malloc(100), * linep = line;
    size_t lenmax = 100, len = lenmax;
    int c;

    if(line == NULL)
        return NULL;

    for(;;) {
        c = fgetc(stdin);
        if(c == EOF)
            break;

        if(--len == 0) {
            len = lenmax;
            char * linen = realloc(linep, lenmax *= 2);

            if(linen == NULL) {
                free(linep);
                return NULL;
            }
            line = linen + (line - linep);
            linep = linen;
        }

        if((*line++ = c) == '\n')
            break;
    }
    *line = '\0';
    return linep;
}

int main(int argc, char** argv) {
    void* shellParser = ParseAlloc(malloc);
    char *line;
    printf("> ");
    while ( line = getline() ) {
        parse(line);
        printf("> ");
    }
    return 0;

    // Simulate a command line such as "cat main.cpp | wc"
    /* Parse(sheallParser, FILENAME, "cat"); */
    /* Parse(shellParser, FILENAME, "main.c"); */
    /* Parse(shellParser, PIPE, 0); */
    /* Parse(shellParser, FILENAME, "wc"); */
    /* Parse(shellParser, 0, 0); // Signal end of tokens */
    /* ParseFree(shellParser, free); */
    /* return 0; */
}
