%{
#include <stdlib.h>
#include "analex.c"
void verifica_var_declarada(int pos);
void verifica_func_declarada(int pos);
void verifica_tipos_atrib(int tipo1, int tipo2);
%}

%union{
	struct ids{
		int ids[50];
		int tipos[50];
		int tam;
	} id_list;
	struct simb{
		int posicao;
		char *lexema;
		int tipo;
	} simbolo;
	int val;
	float fval;
	char cval;
}

%token <val> NUM
%token <fval> NUM_REAL
%token <simbolo> ID
%token FOR
%token WHILE
%token IF
%token ELSE
%token ENDIF
%token CHAR
%token INT
%token FLOAT
%token VOID
%token RETURN
%token OR
%token AND
%token NOT
%token GE
%token LE
%token EQ
%token NEQ
%token DO
%token STRING
%token <cval> CHARACTERE

%type <id_list> IDs ParamList ArgList
%type <simbolo> AtribuicaoD
%type <val> Atribuicao Type FunctionCall TypeF
%type <val> Exp

%right '='

%left OR
%left AND

%nonassoc EQ NEQ

%left '>' '<' GE LE

%left '+' '-'
%left '*' '/' '%'

%right NOT

%right '(' '['

%start ProgL
%%
ProgL : Prog { printf("Compilação Finalizada\n"); }
    ;

Prog : Prog Function
	| Function
	;

Function :
	TypeF ID '(' ParamList ')' '{' Decls Statement_Seq '}' {
		/* $1 = tipo de retorno da funcao, $2 = identificador da funcao, $4 = lista de parametros. */
		/* Aqui registramos na tabela o tipo da funcao e quantos parametros ela possui. */
		set_type($2.posicao, $1);
		set_num_param($2.posicao, $4.tam);
	}
	| TypeF ID '(' ')' '{' Decls Statement_Seq '}' {
		/* Funcao sem parametros: registramos o tipo e gravamos quantidade 0. */
		set_type($2.posicao, $1);
		set_num_param($2.posicao, 0);
	}
	;

FunctionCall :
	ID '(' ArgList ')' {
		/* Primeiro conferimos se o nome usado realmente foi declarado como funcao. */
		verifica_func_declarada($1.posicao);
		/* Depois comparamos quantos argumentos foram passados com quantos eram esperados. */
		if(param_args_diferentes($1.posicao, $3.tam))
			yyerror("Argumentos e parâmetros da função não coincidem.");
		/* O tipo da chamada de funcao passa a ser o tipo de retorno da funcao chamada. */
		$$ = Tabela[$1.posicao].tipo;
	}
	| ID '(' ')' {
		/* Mesmo raciocinio da regra acima, mas para chamadas sem argumentos. */
		verifica_func_declarada($1.posicao);
		if(param_args_diferentes($1.posicao, 0))
			yyerror("Argumentos e parâmetros da função não coincidem.");
		$$ = Tabela[$1.posicao].tipo;
	}
	;

ArgList:
	ArgList ',' Arg {
		/* Copiamos a lista que ja existia e so aumentamos a contagem total. */
		$$ = $1;
		$$.tam++;
	}
	| Arg {
		/* A lista comeca com exatamente um argumento. */
		$$.tam = 1;
	}
	;

Arg :
	ID
	| ID '[' Exp ']'
	| FunctionCall
	| NUM
	| STRING
	;

ParamList:
	ParamList ',' Type ID {
		/* Copiamos os parametros anteriores para acrescentar o novo no final. */
		$$ = $1;
		$$.ids[$$.tam] = $4.posicao;
		$$.tipos[$$.tam] = -1;
		$$.tam++;
		/* O parametro da funcao entra na tabela como variavel comum daquele escopo. */
		set_type($4.posicao, $3);
		set_num_param($4.posicao, -1);
	}
	| Type ID {
		/* Primeiro parametro da lista: inicializamos o vetor e registramos seu tipo. */
		$$.tam = 1;
		$$.ids[0] = $2.posicao;
		$$.tipos[0] = -1;
		set_type($2.posicao, $1);
		set_num_param($2.posicao, -1);
	}
	;

Decls:
	  Decl ';' Decls
	|
	;

Decl:
	Type IDs {
		int i;
		/* Uma declaracao como "int a, b, c;" aplica o mesmo tipo a todos os IDs da lista. */
		for(i = 0; i < $2.tam; i++){
			set_type($2.ids[i], $1);
			set_num_param($2.ids[i], -1);
			/* Se algum item veio com atribuicao, validamos se a expressao combina com o tipo declarado. */
			if($2.tipos[i] != -1)
				verifica_tipos_atrib($1, $2.tipos[i]);
		}
	}
	;

IDs :
	  IDs ',' ID {
		/* Reaproveitamos a lista existente e adicionamos mais um identificador simples. */
		$$ = $1;
		$$.ids[$$.tam] = $3.posicao;
		$$.tipos[$$.tam] = -1;
		$$.tam++;
	  }
	| IDs ',' ID '[' NUM ']' {
		/* Aqui fazemos a mesma ideia, mas para um identificador escrito como vetor. */
		$$ = $1;
		$$.ids[$$.tam] = $3.posicao;
		$$.tipos[$$.tam] = -1;
		$$.tam++;
	  }
	| ID {
		/* Inicio de lista com um identificador simples. */
		$$.tam = 1;
		$$.ids[0] = $1.posicao;
		$$.tipos[0] = -1;
	  }
	| ID '[' NUM ']' {
		/* Inicio de lista com um identificador vetorial. */
		$$.tam = 1;
		$$.ids[0] = $1.posicao;
		$$.tipos[0] = -1;
	  }
	| IDs ',' AtribuicaoD {
		/* Alem da posicao do ID, guardamos tambem o tipo da expressao atribuida. */
		$$ = $1;
		$$.ids[$$.tam] = $3.posicao;
		$$.tipos[$$.tam] = $3.tipo;
		$$.tam++;
	  }
	| AtribuicaoD {
		/* Lista iniciada por algo como "a = 10" dentro de uma declaracao. */
		$$.tam = 1;
		$$.ids[0] = $1.posicao;
		$$.tipos[0] = $1.tipo;
	  }
	;

TypeF :
	  VOID { $$ = VOID; }
	| Type { $$ = $1; }
	;

Type :
	  INT { $$ = INT; }
	| CHAR { $$ = CHAR; }
	| FLOAT { $$ = FLOAT; }
	;

Statement_Seq :
	Statement Statement_Seq
	|
	;

Statement:
	  Atribuicao ';' {
		/* A regra de atribuicao ja faz as validacoes principais; aqui reforcamos a existencia do ID. */
		verifica_var_declarada($1);
	  }
	| If
	| While
	| DoWhile
	| FunctionCall ';'
	| RETURN ID ';'
	| RETURN NUM ';'
	| RETURN ';'
	;

Compound_Stt :
	  Statement
	| '{' Statement_Seq '}'
	;

If :
	  IF '(' Exp ')' Compound_Stt ENDIF
	| IF '(' Exp ')' Compound_Stt ELSE Compound_Stt ENDIF
	;

While:
	WHILE '(' Exp ')' Compound_Stt
	;

DoWhile:
	DO Compound_Stt WHILE '(' Exp ')' ';'
	;

Atribuicao : ID '[' NUM ']' '=' Exp {
		/* Confere se o vetor existe e se o tipo da expressao pode ser atribuido a ele. */
		verifica_var_declarada($1.posicao);
		verifica_tipos_atrib(Tabela[$1.posicao].tipo, $6);
		/* A producao devolve a posicao do identificador na tabela. */
		$$ = $1.posicao;
	}
    | ID '=' Exp {
		/* Mesmo raciocinio para atribuicao simples. */
		verifica_var_declarada($1.posicao);
		verifica_tipos_atrib(Tabela[$1.posicao].tipo, $3);
		$$ = $1.posicao;
	}
	;

AtribuicaoD : ID '[' NUM ']' '=' Exp {
		/* Guardamos os dados necessarios para que a declaracao valide tudo mais tarde. */
		$$.posicao = $1.posicao;
		$$.lexema = $1.lexema;
		$$.tipo = $6;
	}
    | ID '=' Exp {
		/* Aqui o identificador ainda esta em declaracao, entao so empacotamos os dados. */
		$$.posicao = $1.posicao;
		$$.lexema = $1.lexema;
		$$.tipo = $3;
	}
	;

Exp :
	  Exp '+' Exp { /* Operacoes aritmeticas devolvem o maior tipo entre os operandos. */ $$ = retorna_maior_tipo($1, $3); }
	| Exp '-' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '*' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '/' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '%' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '>' Exp { /* Comparacoes e operacoes logicas devolvem INT, usado como booleano. */ $$ = INT; }
	| Exp '<' Exp { $$ = INT; }
	| Exp GE Exp { $$ = INT; }
	| Exp LE Exp { $$ = INT; }
	| Exp EQ Exp { $$ = INT; }
	| Exp NEQ Exp { $$ = INT; }
	| Exp OR Exp { $$ = INT; }
	| Exp AND Exp { $$ = INT; }
	| NOT Exp { $$ = INT; }
	| '(' Exp ')' { /* Parenteses nao alteram o tipo da expressao interna. */ $$ = $2; }
	| NUM { /* Literal inteiro. */ $$ = INT; }
	| NUM_REAL { /* Literal real. */ $$ = FLOAT; }
	| ID '[' Exp ']' {
		/* O vetor precisa existir; o resultado da leitura dele tem o tipo do proprio simbolo. */
		verifica_var_declarada($1.posicao);
		$$ = Tabela[$1.posicao].tipo;
	}
	| ID  {
		/* Usar um identificador numa expressao exige que ele tenha sido declarado. */
		verifica_var_declarada($1.posicao);
		$$ = Tabela[$1.posicao].tipo;
	}
	| CHARACTERE { /* Literal de caractere. */ $$ = CHAR; }
	| FunctionCall { /* O tipo da chamada ja foi calculado na regra de FunctionCall. */ $$ = $1; }
	;

%%

int main(int argc, char **argv) {
  /* argv[1] deve ser o caminho do arquivo de entrada que sera analisado. */
  yyin = fopen(argv[1],"r");
  /* Inicia toda a analise sintatica e, junto com ela, as acoes semanticas. */
  yyparse();
  return 0;
}

/*
Recebe a posicao de um simbolo e verifica se ele pode ser usado como variavel.

Dispara erro quando:
- a posicao eh invalida
- o tipo ainda nao foi definido
- o simbolo foi registrado como funcao, e nao como variavel
*/
void verifica_var_declarada(int pos){
	if(pos < 0 || pos >= proximo_elem || Tabela[pos].tipo == -1 || Tabela[pos].num_param != -1)
		yyerror("Uso de variável não declarada!");
}

/*
Recebe a posicao de um simbolo e verifica se ele pode ser usado como funcao.

Dispara erro quando:
- a posicao eh invalida
- o tipo ainda nao foi definido
- o simbolo nao foi registrado como funcao
*/
void verifica_func_declarada(int pos){
	if(pos < 0 || pos >= proximo_elem || Tabela[pos].tipo == -1 || Tabela[pos].num_param < 0)
		yyerror("Uso de função não declarada!");
}

/*
Compara o tipo do destino com o tipo da expressao atribuida.

Parametros:
- tipo1: tipo da variavel que vai receber o valor
- tipo2: tipo da expressao do lado direito

Se a combinacao for proibida pelas regras do trabalho, a funcao encerra a compilacao com erro.
*/
void verifica_tipos_atrib(int tipo1, int tipo2){
	if(tipos_inconsistentes_atrib(tipo1, tipo2))
		yyerror("Tipos incompatíveis!");
}
