%option noyywrap

%{ 
#include "expr_tree.h"
#include "tokens.h" 
%}

NUMBER		[0-9][0-9]*
IDENTIFIER	[a-zA-Z_][a-zA-Z_0-9]*

%%

";"		{ return SEMI; }

"("		{ return PAR_IZQ; }
")"		{ return PAR_DER; }
"+"		{ return PLUS; }
"-"		{ return MINUS; }
"*"		{ return TIMES; }
"/"		{ return DIVIDE; }
"%"		{ return MOD; }

">"		{ return GREATER; }
">="		{ return GREATER_EQUAL; }
"<"		{ return LESS; }
"<="		{ return LESS_EQUAL; }
"=="		{ return EQUAL; }
"!="		{ return NOT_EQUAL; }

"&&"		{ return AND; }
"||"		{ return OR; }
"!"		{ return NOT; }

"="		{ return ASSIGN; }

"IF"		{ return IF; }
"THEN"		{ return THEN; }
"ELSE"		{ return ELSE; }
"ENDIF"		{ return ENDIF; }
"PRINT"		{ return PRINT; }

{NUMBER} 	{ yylval.number = atoi(yytext); return NUM; }
{IDENTIFIER}	{ yylval.lexeme = strdup(yytext); return ID; }

[ \t\n]+	/* nada */
