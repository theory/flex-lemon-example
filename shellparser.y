%include {
#include <stdio.h>
#include <assert.h>
}

%token_type {const char*}

%syntax_error
{
    fprintf(stderr, "Error parsing command\n");
}

start ::= commandList .
{
}
commandList ::= command PIPE commandList EOL .
{
}
commandList ::= command EOL .
{
}

command ::= FILENAME argumentList .
{
}
command ::= FILENAME .
{
}

argumentList ::= argument argumentList .
{
}
argumentList ::= argument .
{
}
argument ::= ARGUMENT .
{
}
argument ::= FILENAME .
{
}


