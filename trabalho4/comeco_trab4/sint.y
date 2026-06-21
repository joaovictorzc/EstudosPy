%{ 
#include "analex.c" 
void verifica_var_declarada(int pos);
void verifica_func_declarada(int pos);
void verifica_tipos_atrib(int tipo1, int tipo2);
%}

%union{
	struct ids{
		int ids[50];
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
%token NUM_REAL
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
%token CHARACTERE

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
ProgL : Prog { printf("Compilação finalizada com sucesso."); }
    ;
    
Prog : Prog Function
	| Function
	;	

Function :
	TypeF ID '(' ParamList ')' '{' Decls Statement_Seq '}'   { /* TODO: registrar o tipo de retorno da função e a quantidade de parâmetros declarados */ }
	| TypeF ID '(' ')' '{' Decls Statement_Seq '}'   { /* TODO: registrar função sem parâmetros e associar seu tipo de retorno */ }
	;
	
FunctionCall :
    ID '(' ArgList ')' { /* TODO: validar a existência da função, checar número de argumentos e definir o tipo produzido pela chamada */ }
    | ID '('  ')' { /* TODO: validar chamada de função sem argumentos e definir o tipo de retorno correspondente */ }
    ;
    
ArgList:
    ArgList ',' Arg { /* TODO: acumular quantidade de argumentos já reconhecidos */ }
    | Arg { /* TODO: iniciar contagem de argumentos */ }
    ;

Arg :
    ID
    | ID '[' Exp ']'
    | FunctionCall
    | NUM
    | STRING
	;
	
ParamList: 
    ParamList ',' Type ID { /* TODO: propagar símbolos já coletados, adicionar novo parâmetro e registrar seu tipo */ }
    | Type ID { /* TODO: inicializar lista de parâmetros com o identificador atual e configurar seu tipo */ }
	; 
		
Decls:
	  Decl ';' Decls  
	| 
	;

Decl:
	Type IDs { Tabela[$2.ids[0]].tipo = $1;/* TODO: atribuir o tipo declarado a cada identificador e marcar que não se trata de função */ }
	; 
	
IDs :
	  IDs ',' ID { /* TODO: combinar identificadores já armazenados com o novo símbolo simples */ }
	| IDs ',' ID '[' NUM ']' { /* TODO: registrar identificador vetorial adicional */ }
	| ID { $$.ids[0] = $1.posicao; /* TODO: iniciar lista com identificador simples */ }
	| ID '[' NUM ']' { /* TODO: iniciar lista com identificador vetorial */ }
	| IDs ',' AtribuicaoD { /* TODO: incluir identificador proveniente de declaração com atribuição */ }
	| AtribuicaoD { $$.ids[0] = $1.posicao; /* TODO: iniciar lista com identificador declarado via atribuição */ }
	;
	
TypeF :
	  VOID { /* TODO: definir o tipo de retorno como void */ }
	| Type { /* TODO: propagar tipo retornado pela produção Type */ }
	;

Type :
	  INT { /* TODO: associar tipo inteiro ao token INT */ }
	| CHAR { /* TODO: associar tipo char ao token CHAR */ }
	| FLOAT { /* TODO: associar tipo float ao token FLOAT */ }
	;
			
Statement_Seq :
	Statement Statement_Seq
	|
	;
		
Statement: 
	  Atribuicao ';' { /* TODO: verificar uso de variável declarada antes da atribuição */ }
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
			
Atribuicao : ID '[' NUM ']' '=' Exp { /* TODO: garantir que o identificador vetorial foi declarado, checar compatibilidade de tipos e devolver posição na tabela */ }
    | ID '=' Exp { verifica_tipos_atrib(Tabela[$1.posicao].tipo, $3);/* TODO: garantir que o identificador foi declarado, validar tipos e devolver posição na tabela */ }
	;
	
AtribuicaoD : ID '[' NUM ']' '=' Exp { /* TODO: registrar posição do identificador e o tipo resultante da expressão */ }
    | ID '=' Exp { $$.posicao = $1.posicao;if($3 == FLOAT) printf("Expressao e float\n"); if($3 == INT) printf("Expressao e int\n"); if($3 == CHAR) printf("Expressao e char\n");/* TODO: registrar posição do identificador e o tipo da expressão atribuída */ }
	;
				
Exp :
	  Exp '+' Exp { $$ = retorna_maior_tipo($1, $3); }
	| Exp '-' Exp { /* TODO: definir tipo resultante da subtração considerando promoção de tipos */ }
	| Exp '*' Exp { $$ = retorna_maior_tipo($1,$3);  }
	| Exp '/' Exp { /* TODO: definir tipo resultante da divisão considerando promoção de tipos */ }
	| Exp '>' Exp { /* TODO: garantir resultado inteiro para comparação maior que */ }
	| Exp '<' Exp { /* TODO: garantir resultado inteiro para comparação menor que */ }
	| Exp GE Exp { /* TODO: garantir resultado inteiro para comparação maior ou igual */ }
	| Exp LE Exp { /* TODO: garantir resultado inteiro para comparação menor ou igual */ }
	| Exp EQ Exp { /* TODO: garantir resultado inteiro para comparação de igualdade */ }
	| Exp NEQ Exp { /* TODO: garantir resultado inteiro para comparação de diferença */ }
	| Exp OR Exp { /* TODO: garantir resultado inteiro para operação lógica OU */ }
	| Exp AND Exp { /* TODO: garantir resultado inteiro para operação lógica E */ }
	| NOT Exp { /* TODO: garantir resultado inteiro para negação lógica */ }
	| '(' Exp ')' { /* TODO: propagar tipo da expressão entre parênteses */ }
	| NUM { $$ = INT; }
	| NUM_REAL { $$ = FLOAT;}
	| ID '[' Exp ']' { /* TODO: verificar declaração do vetor e retornar seu tipo base */ } 
	| ID  { /* TODO: verificar declaração do identificador e retornar seu tipo */ } 	   
	| CHARACTERE { $$ = CHAR;/* TODO: definir tipo char para literal de caractere */ }
	| FunctionCall { /* TODO: usar tipo de retorno registrado para a função chamada */ }
	;   
	
	
%%  
int main(int argc, char **argv) {     
  yyin = fopen(argv[1],"r");
  yyparse();      
} 


void verifica_var_declarada(int pos){
	/* TODO: implementar verificação de declaração prévia do identificador na tabela de símbolos */
}

void verifica_func_declarada(int pos){
	/* TODO: implementar verificação que garanta existência da função na tabela de símbolos */
}
void verifica_tipos_atrib(int tipo1, int tipo2){
}