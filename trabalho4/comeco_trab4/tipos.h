#include "sint.h"
#include "stdio.h"

int retorna_maior_tipo(int tipo1, int tipo2){
	if(tipo1 == FLOAT || tipo2 == FLOAT)
        return FLOAT;
    if(tipo1 == INT || tipo2 == INT)
        return INT;
    if(tipo1 == CHAR || tipo2 == CHAR)
        return CHAR;
    return 0;
}

int get_tam_tipo(int tipo){
    switch(tipo){
        case CHAR:
            return 1;
        case INT:
            return 4;
        case FLOAT:
            return 8;
        case VOID:
            return 0;
        default:
            return 0;
    }
}

int tipos_inconsistentes_atrib(int tipo1, int tipo2){
    if(tipo1 == tipo2)
        return 0;
    if(tipo1 == FLOAT && (tipo2 == INT || tipo2 == CHAR))
        return 0;
    if(tipo1 == INT && tipo2 == CHAR)
        return 0;
    return 1;
}
