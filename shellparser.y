%include {
#include <stdio.h>
#include <assert.h>
}

%token_type {const char*}

%syntax_error
{
    fprintf(stderr, "Error parsing command\n");
}

start ::= in .
in ::= .
in ::= in commandList EOL .
{
    printf("in ::= in commandList EOL .\n");
    printf("> ");
}

commandList ::= command PIPE commandList .
{
    printf("commandList ::= command PIPE commandList .\n");
}
commandList ::= command .
{
    printf("commandList ::= command .\n");
}

command ::= FILENAME argumentList .
{
    printf("command ::= FILENAME argumentList .\n");
}
command ::= FILENAME .
{
    printf("command ::= FILENAME .\n");
}

argumentList ::= argument argumentList .
{
    printf("argumentList ::= argument argumentList .\n");
}
argumentList ::= argument .
{
    printf("argumentList ::= argument .\n");
}
argument ::= ARGUMENT .
{
    printf("argument ::= ARGUMENT .\n");
}
argument ::= FILENAME .
{
    printf("argument ::= FILENAME .\n");
}


