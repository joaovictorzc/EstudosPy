%{
#include "analex.c"
void verifica_var_declarada(int pos);
void verifica_func_declarada(int pos);
void verifica_tipos_atrib(int tipo_destino, int tipo_origem);
%}

%union{
	struct ids{
		int ids[50];
		int init_tipo[50];
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
ProgL : Prog { printf("Compilação Finalizada"); }
    ;

Prog : Prog Function
	| Function
	;

Function :
	TypeF ID '(' ParamList ')' '{' Decls Statement_Seq '}' {
		set_type($2.posicao, $1);
		set_categoria($2.posicao, CAT_FUNC);
		set_num_param($2.posicao, $4.tam);
	}
	| TypeF ID '(' ')' '{' Decls Statement_Seq '}' {
		set_type($2.posicao, $1);
		set_categoria($2.posicao, CAT_FUNC);
		set_num_param($2.posicao, 0);
	}
	;

FunctionCall :
    ID '(' ArgList ')' {
		verifica_func_declarada($1.posicao);
		if (param_args_diferentes($1.posicao, $3.tam))
			yyerror("Argumentos e parâmetros da função não coincidem.");
		$$ = Tabela[$1.posicao].tipo;
	}
    | ID '('  ')' {
		verifica_func_declarada($1.posicao);
		if (param_args_diferentes($1.posicao, 0))
			yyerror("Argumentos e parâmetros da função não coincidem.");
		$$ = Tabela[$1.posicao].tipo;
	}
    ;

ArgList:
    ArgList ',' Arg {
		$$ = $1;
		$$.tam = $1.tam + 1;
	}
    | Arg {
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
		$$ = $1;
		$$.ids[$1.tam] = $4.posicao;
		$$.init_tipo[$1.tam] = -1;
		$$.tam = $1.tam + 1;
		set_type($4.posicao, $3);
		set_categoria($4.posicao, CAT_VAR);
	}
    | Type ID {
		$$.ids[0] = $2.posicao;
		$$.init_tipo[0] = -1;
		$$.tam = 1;
		set_type($2.posicao, $1);
		set_categoria($2.posicao, CAT_VAR);
	}
	;

Decls:
	  Decl ';' Decls
	|
	;

Decl:
	Type IDs {
		int i;
		for (i = 0; i < $2.tam; i++) {
			if ($2.init_tipo[i] != -1)
				verifica_tipos_atrib($1, $2.init_tipo[i]);
			set_type($2.ids[i], $1);
			set_categoria($2.ids[i], CAT_VAR);
		}
	}
	;

IDs :
	  IDs ',' ID {
		$$ = $1;
		$$.ids[$1.tam] = $3.posicao;
		$$.init_tipo[$1.tam] = -1;
		$$.tam = $1.tam + 1;
	}
	| IDs ',' ID '[' NUM ']' {
		$$ = $1;
		$$.ids[$1.tam] = $3.posicao;
		$$.init_tipo[$1.tam] = -1;
		$$.tam = $1.tam + 1;
	}
	| ID {
		$$.ids[0] = $1.posicao;
		$$.init_tipo[0] = -1;
		$$.tam = 1;
	}
	| ID '[' NUM ']' {
		$$.ids[0] = $1.posicao;
		$$.init_tipo[0] = -1;
		$$.tam = 1;
	}
	| IDs ',' AtribuicaoD {
		$$ = $1;
		$$.ids[$1.tam] = $3.posicao;
		$$.init_tipo[$1.tam] = $3.tipo;
		$$.tam = $1.tam + 1;
	}
	| AtribuicaoD {
		$$.ids[0] = $1.posicao;
		$$.init_tipo[0] = $1.tipo;
		$$.tam = 1;
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
	  Atribuicao ';'
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
		verifica_var_declarada($1.posicao);
		verifica_tipos_atrib(Tabela[$1.posicao].tipo, $6);
		$$ = $1.posicao;
	}
    | ID '=' Exp {
		verifica_var_declarada($1.posicao);
		verifica_tipos_atrib(Tabela[$1.posicao].tipo, $3);
		$$ = $1.posicao;
	}
	;

AtribuicaoD : ID '[' NUM ']' '=' Exp {
		$$.posicao = $1.posicao;
		$$.tipo = $6;
	}
    | ID '=' Exp {
		$$.posicao = $1.posicao;
		$$.tipo = $3;
	}
	;

Exp :
	  Exp '+' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '-' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '*' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '/' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '>' Exp { $$ = INT; }
	| Exp '<' Exp { $$ = INT; }
	| Exp GE Exp { $$ = INT; }
	| Exp LE Exp { $$ = INT; }
	| Exp EQ Exp { $$ = INT; }
	| Exp NEQ Exp { $$ = INT; }
	| Exp OR Exp { $$ = INT; }
	| Exp AND Exp { $$ = INT; }
	| NOT Exp { $$ = INT; }
	| '(' Exp ')' { $$ = $2; }
	| NUM { $$ = INT; }
	| NUM_REAL { $$ = FLOAT; }
	| ID '[' Exp ']' {
		verifica_var_declarada($1.posicao);
		$$ = Tabela[$1.posicao].tipo;
	}
	| ID  {
		verifica_var_declarada($1.posicao);
		$$ = Tabela[$1.posicao].tipo;
	}
	| CHARACTERE { $$ = CHAR; }
	| FunctionCall { $$ = $1; }
	;

%%
int main(int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "Informe o arquivo de entrada.\n");
		return 1;
	}
	yyin = fopen(argv[1],"r");
	if (!yyin) {
		perror(argv[1]);
		return 1;
	}
	yyparse();
	return 0;
}

void verifica_var_declarada(int pos){
	if (pos < 0 || pos >= proximo_elem || Tabela[pos].tipo == -1 || Tabela[pos].categoria != CAT_VAR)
		yyerror("Uso de variável não declarada!");
}

void verifica_func_declarada(int pos){
	if (pos < 0 || pos >= proximo_elem || Tabela[pos].tipo == -1 || Tabela[pos].categoria != CAT_FUNC)
		yyerror("Uso de função não declarada!");
}

void verifica_tipos_atrib(int tipo_destino, int tipo_origem){
	if (tipos_inconsistentes_atrib(tipo_destino, tipo_origem))
		yyerror("Tipos incompatíveis!");
}
