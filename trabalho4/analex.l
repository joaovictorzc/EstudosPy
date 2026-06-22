%{
#include <stdio.h>
#include "sint.h"
#include "tabsimb.h"
int linha = 1;

/*
Essa funcao centraliza a exibicao de erros do analisador.

Parametro:
- s: mensagem de erro recebida do parser ou do proprio lexer

Efeito:
- imprime a mensagem junto com a linha atual
- encerra a execucao com erro
*/
int yyerror(char *s) { 
  fprintf(stderr, "%s na linha %d\n",s,linha);
  exit(1); 
}
%}

DIGITO [0-9]
LETRA [a-zA-Z_]
CHARACTERE \'[a-zA-Z0-9]\'

%%


"for" {return FOR;}
"while" {return WHILE;}
"if"	{return IF;}
"else"	{return ELSE;}
"int"  {return INT;}
"float" {return FLOAT;}
"char"  {return CHAR;} 
"return" {return RETURN;}
"void" {return VOID;}
"endif" {return ENDIF;}


"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"%" {return '%';}


">="  {return GE;}
"<=" {return LE;}
">" {return '>';}
"<" {return '<';}
"==" {return EQ;} 	


"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}


"=" {return '=';}


"["	  {return '[';}
"]"	  {return ']';}
"("	  {return '(';}
")"   {return ')';}
"{"	  {return '{';}
"}"   {return '}';}
";"   {return ';';}
","   {return ',';}

{CHARACTERE} {
	/* Guarda o caractere lido em yylval para o parser poder usar depois. */
	yylval.cval = yytext[1];
	return CHARACTERE;
}


{DIGITO}+("."{DIGITO}+) {
	/* Converte o texto lido, como 2.3, para float e guarda em yylval. */
	yylval.fval = atof(yytext);
	return NUM_REAL;
}

{DIGITO}+	{
	/* Converte o texto lido, como 10, para inteiro e guarda em yylval. */
	yylval.val = atoi(yytext);
	return NUM;
}


{LETRA}({LETRA}|{DIGITO})*  {
							/*
							Quando lemos um identificador:
							1. inserimos ou procuramos o nome na tabela de simbolos
							2. guardamos a posicao encontrada
							3. guardamos tambem o proprio texto lido
							*/
							yylval.simbolo.posicao = insere(yytext);
                            yylval.simbolo.lexema = yytext;
                            return ID;
                           }  
                           
\"[^\"]*\"   { return STRING; }

[ \t\r] {}
\n	{ linha++; }
.	{printf("erro lexico na linha %d - %s\n",
             linha, yytext); }
%%

#ifndef yywrap
/*
O Flex chama yywrap quando chega ao fim da entrada.

Retorno:
- 1: diz ao lexer que nao ha outro arquivo para continuar lendo
*/
int yywrap() { return 1; }
#endif
