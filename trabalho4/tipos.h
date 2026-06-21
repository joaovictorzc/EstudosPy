#ifndef TIPOS_H
#define TIPOS_H

#include "sint.h"
#include <stdio.h>

static int rank_tipo(int tipo){
    if(tipo == CHAR) return 1;
    if(tipo == INT) return 2;
    if(tipo == FLOAT) return 3;
    return 0;
}

int retorna_maior_tipo(int tipo1, int tipo2){
    if(rank_tipo(tipo1) >= rank_tipo(tipo2))
        return tipo1;
    return tipo2;
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

int tipos_inconsistentes_atrib(int tipo_destino, int tipo_origem){
    if(tipo_destino == -1 || tipo_origem == -1)
        return 1;
    if(tipo_destino == VOID || tipo_origem == VOID)
        return 1;
    return rank_tipo(tipo_origem) > rank_tipo(tipo_destino);
}

#endif
