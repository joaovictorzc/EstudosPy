#include "sint.h"
#include "stdio.h"

int retorna_maior_tipo(int tipo1, int tipo2){
	/*
	Esta funcao recebe dois tipos e devolve qual deles deve "prevalecer"
	quando os dois participam da mesma expressao.

	Exemplo de uso:
	- int + float  -> resultado float
	- char + char  -> resultado char

	Retornos esperados:
	- FLOAT: quando pelo menos um dos lados eh float
	- INT: quando a combinacao tratada pela funcao deve resultar em int
	- CHAR: quando os dois lados sao char
	- -1: quando a funcao nao encontrou uma regra para essa combinacao
	*/

	/* Se algum dos dois lados for FLOAT, o resultado da expressao sobe para FLOAT. */
	if(tipo1 == FLOAT || tipo2 == FLOAT)
		return FLOAT;

	/* Nesta versao da funcao, so retorna INT quando os dois lados sao INT. */
	if(tipo1 == INT && tipo2 == INT)
		return INT;

	/* Se os dois lados forem CHAR, o resultado continua sendo CHAR. */
	if(tipo1 == CHAR && tipo2 == CHAR)
		return CHAR;

	/* Se nenhuma regra acima servir, devolvemos -1 para indicar "tipo nao resolvido". */
	return -1;
}

int get_tam_tipo(int tipo){
    /*
    Esta funcao recebe um tipo e devolve quantos bytes esse tipo ocupa.

    Retornos esperados:
    - 1: para CHAR
    - 4: para INT
    - 4: para FLOAT
    - 0: para VOID ou para algum tipo nao reconhecido
    */

    /* CHAR costuma ocupar 1 byte. */
    if(tipo == CHAR)
        return 1;

    /* INT, neste trabalho, foi tratado como 4 bytes. */
    if(tipo == INT)
        return 4;

    /* FLOAT, neste trabalho, tambem foi tratado como 4 bytes. */
    if(tipo == FLOAT)
        return 4;

    /* VOID nao representa um valor armazenavel, entao devolvemos 0. */
    if(tipo == VOID)
        return 0;

    /* Se o tipo vier diferente dos casos conhecidos, devolvemos 0 por seguranca. */
    return 0;
}

int tipos_inconsistentes_atrib(int tipo1, int tipo2){
    /*
    Esta funcao responde se uma atribuicao eh invalida.

    Leitura dos parametros:
    - tipo1 = tipo da variavel que vai receber o valor  -> destino
    - tipo2 = tipo da expressao que esta sendo atribuida -> origem

    Exemplo:
    int a;
    a = 'c';
    Aqui:
    - tipo1 seria INT
    - tipo2 seria CHAR

    Retornos esperados:
    - 0: atribuicao permitida
    - 1: atribuicao incompativel
    */

    /* Se os dois tipos forem iguais, a atribuicao eh automaticamente valida. */
    if(tipo1 == tipo2)
        return 0;

    /* Um FLOAT pode receber CHAR, INT ou FLOAT sem erro. */
    if(tipo1 == FLOAT && (tipo2 == CHAR || tipo2 == INT || tipo2 == FLOAT))
        return 0;

    /* Um INT pode receber CHAR ou INT, mas nao pode receber FLOAT. */
    if(tipo1 == INT && (tipo2 == CHAR || tipo2 == INT))
        return 0;

    /* Um CHAR, nesta regra, so pode receber outro CHAR. */
    if(tipo1 == CHAR && tipo2 == CHAR)
        return 0;

    /* Se nao caiu em nenhum caso permitido, a atribuicao eh inconsistente. */
    return 1;
}
