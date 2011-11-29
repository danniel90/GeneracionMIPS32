%{

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <fstream>

#include "expr_tree.h"
#include "tokens.h"

using namespace std;

#define YYERROR_VERBOSE 1

void yyerror(const char *message)
{
    cerr << message << "\n";
    exit(1);
}

int yylex();

%}


%union {
    Expr *expr;
    Sentence *sent;
    int number;
    char *lexeme;
}

%token PAR_IZQ PAR_DER SEMI
%token IF THEN ELSE ENDIF PRINT
%token PLUS MINUS TIMES DIVIDE MOD GREATER GREATER_EQUAL LESS LESS_EQUAL EQUAL NOT_EQUAL AND OR NOT ASSIGN

%token<number> NUM
%token<lexeme> ID

%type<sent> sentence_list sentence assign if opt_else print program

%type<expr> expr expr_and expr_rel expr_arith term factor


%%

/*------------------------------------------------------------------------------------------------------------------
						Sentencias
------------------------------------------------------------------------------------------------------------------*/


start:		program						{
								  GenCode prgCode = $1->genprogramcode();
								  cout << "Codigo MIPS32"<< endl << prgCode.code << endl;
//								  cout << "Interpretacion" << endl;
//								  $1->interpret();
								}
;

program:	sentence_list					{ $$ = new Program($1); }
;

sentence_list:	sentence					{ $$ = $1; }
		|sentence sentence_list				{ $$ = new SequenceSent($1, $2); }
;

sentence:	assign						{ $$ = $1; }
		|if						{ $$ = $1; }
		|print						{ $$ = $1; }
;

assign:		ID ASSIGN expr SEMI				{ $$ = new AssignSent(new IdExpr($1), $3); }
;

if:		IF expr THEN sentence_list opt_else ENDIF	{ $$ = new IfSent($2, $4, $5); }
;

opt_else:							{ $$ = NULL; }
		|ELSE sentence_list				{ $$ = $2 }
;

print:		PRINT ID SEMI					{ $$ = new PrintSent(new IdExpr($2)); }
;


/*------------------------------------------------------------------------------------------------------------------
						Expresiones
------------------------------------------------------------------------------------------------------------------*/

expr:		expr OR expr_and			{ $$ = new OrExpr($1, $3); }
		|expr_and				{ $$ = $1; }
;

expr_and:	expr_and AND expr_rel			{ $$ = new AndExpr($1, $3); }
		|expr_rel				{ $$ = $1; }
;

expr_rel:	expr_rel EQUAL expr_arith		{ $$ = new EqualExpr($1, $3); }
		|expr_rel NOT_EQUAL expr_arith		{ $$ = new NotEqualExpr($1, $3); }
		|expr_rel GREATER expr_arith		{ $$ = new GreaterExpr($1, $3); }
		|expr_rel GREATER_EQUAL expr_arith	{ $$ = new GreaterEqualExpr($1, $3); }
		|expr_rel LESS expr_arith		{ $$ = new LessExpr($1, $3); }
		|expr_rel LESS_EQUAL expr_arith		{ $$ = new LessEqualExpr($1, $3); }
		|expr_arith				{ $$ = $1; }
;

expr_arith:	expr_arith PLUS	term			{ $$ = new AddExpr($1, $3); }
		|expr_arith MINUS term			{ $$ = new SubExpr($1, $3); }
		|term					{ $$ = $1; }
;

term:		term TIMES factor			{ $$ = new MultExpr($1, $3); }
		|term DIVIDE factor			{ $$ = new DivExpr($1, $3); }
		|term MOD factor			{ $$ = new ModExpr($1, $3); }
		|factor					{ $$ = $1; }
;

factor: 	PAR_IZQ expr PAR_DER			{ $$ = $2; }
		|NOT expr				{ $$ = new NotExpr($2); }
		|NUM					{ $$ = new NumExpr($1); }
		|ID					{ $$ = new IdExpr($1); }
;

