#include "sint.h"
#include "stdio.h"

int retorna_maior_tipo(int tipo1, int tipo2){
	/* CHAR -> INT -> FLOAT */
	if(tipo1 == FLOAT || tipo2 == FLOAT)
		return FLOAT;

	if(tipo1 == INT || tipo2 == INT)
		return INT;

	if(tipo1 == CHAR && tipo2 == CHAR)
		return CHAR;

	return -1;
}

int get_tam_tipo(int tipo){
    if(tipo == CHAR)
        return 1;

    if(tipo == INT)
        return 4;

    if(tipo == FLOAT)
        return 4;

    if(tipo == VOID)
        return 0;

    return 0;
}

int tipos_inconsistentes_atrib(int tipo1, int tipo2){
    /* tipo1 = destino, tipo2 = origem */

    if(tipo1 == tipo2)
        return 0;

    /* float recebe char, int e float */
    if(tipo1 == FLOAT && (tipo2 == CHAR || tipo2 == INT || tipo2 == FLOAT))
        return 0;

    /* int recebe char e int, mas nao float */
    if(tipo1 == INT && (tipo2 == CHAR || tipo2 == INT))
        return 0;

    /* char so recebe char */
    if(tipo1 == CHAR && tipo2 == CHAR)
        return 0;

    return 1;
}