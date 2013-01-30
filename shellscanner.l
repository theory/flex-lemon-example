%{
    #include "shellparser.h"
%}

%option reentrant
%option noyywrap

%x SINGLE_QUOTED
%x DOUBLE_QUOTED

%%

"|"                     { printf("PIPE\n"); return PIPE; }

[ \t\r]                 { }
\n                      { return EOL; }

[a-zA-Z0-9_\.\-]+       { printf("FILENAME: \"%s\"\n", yytext); return FILENAME; }

[']                     { BEGIN(SINGLE_QUOTED); }
<SINGLE_QUOTED>[^']+    { }
<SINGLE_QUOTED>[']      { BEGIN(INITIAL); return ARGUMENT; }
<SINGLE_QUOTED><<EOF>>  { return -1; }

["]                     { BEGIN(DOUBLE_QUOTED); }
<DOUBLE_QUOTED>[^"]+    { }
<DOUBLE_QUOTED>["]      { BEGIN(INITIAL); return ARGUMENT; }
<DOUBLE_QUOTED><<EOF>>  { return -1; }

[^ \t\r\n|'"]+          { return ARGUMENT; }

%%


