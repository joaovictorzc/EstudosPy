#include <string.h>
#include "tipos.h"

#define MAX 1000
struct symbol {
	char nome[50];
	int tam;
	int tipo;
	float valor;
	int num_param;
};
int offset=0;
int proximo_elem=0;
struct symbol Tabela[MAX];

/*
Procura um nome ja cadastrado na tabela de simbolos.

Parametro:
- nome: texto do identificador procurado

Retorno:
- posicao >= 0: simbolo encontrado
- -1: simbolo ainda nao esta na tabela
*/
int procura(char *nome) {
int i;	
	for(i=0; i<proximo_elem; i++) 
	  if(strcmp(Tabela[i].nome,nome)==0)
	     return i; 
	return -1;     
}

/*
Insere um simbolo novo na tabela, caso ele ainda nao exista.

Parametro:
- nome: texto do identificador

Retorno:
- posicao existente: se o nome ja estava cadastrado
- nova posicao: se o nome acabou de ser inserido

Observacao:
- novos simbolos entram com tipo = -1, porque ainda nao sabemos
  se sao variaveis ou funcoes nem qual tipo possuem
*/
int insere(char *nome) {
int i,pos;
struct symbol aux;	
	pos = procura(nome);
	if (pos != -1)
		return pos;
	strcpy(aux.nome,nome);
	Tabela[proximo_elem]=aux;
	Tabela[proximo_elem].tipo = -1;
	Tabela[proximo_elem].tam = 0;
	Tabela[proximo_elem].valor = 0;
	Tabela[proximo_elem].num_param = -1;
	return proximo_elem++;	     
}

/*
Grava o tipo de um simbolo e atualiza seu tamanho em bytes.

Parametros:
- pos: posicao do simbolo na tabela
- tipo: codigo interno do tipo, como INT, CHAR ou FLOAT

Retorno:
- 1: sucesso
- -1: posicao invalida
*/
int set_type(int pos, int tipo){
	if(pos >= proximo_elem)
		return -1;
	Tabela[pos].tipo = tipo;
	Tabela[pos].tam = get_tam_tipo(tipo);
	offset+=Tabela[pos].tam;
	return 1;
}

/*
Grava quantos parametros uma funcao possui.

Parametros:
- pos: posicao do simbolo na tabela
- num_param: quantidade de parametros

Retorno:
- 1: sucesso
- -1: posicao invalida

Observacao:
- neste trabalho, num_param = -1 esta sendo usado para marcar
  simbolos que sao variaveis, e nao funcoes
*/
int set_num_param(int pos, int num_param){
	if(pos >= proximo_elem)
		return -1;
	Tabela[pos].num_param = num_param;
	return 1;
}

/*
Compara a quantidade de argumentos passados numa chamada com
a quantidade de parametros esperados pela funcao.

Parametros:
- pos_func: posicao da funcao na tabela
- num_args: quantidade de argumentos recebidos na chamada

Retorno:
- 1: ha diferenca entre argumentos e parametros
- 0: a quantidade bate
*/
int param_args_diferentes(int pos_func, int num_args){
	if(pos_func >= proximo_elem)
		return 1;
	if(Tabela[pos_func].num_param != num_args)
		return 1;
	return 0;
}

char nome[50];

/*
Recebe a posicao de um simbolo e devolve o nome dele.

Parametro:
- pos: posicao do simbolo na tabela

Retorno:
- ponteiro para um buffer com o nome copiado
*/
char *obtemNome(int pos) {
	strcpy(nome,Tabela[pos].nome);
	return nome;
}

/*
Imprime a tabela de simbolos atual na tela.

Uso:
- serve para depuracao e para visualizar quais identificadores
  foram reconhecidos e em que ordem foram inseridos
*/
void imprime() {
int i;
	printf("\nTABELA DE SIMBOLOS\n");	
	for(i=0; i<proximo_elem; i++) 	
	   printf("%d - %s\n",i,Tabela[i].nome);
}
