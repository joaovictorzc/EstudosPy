#include "sint.h"
#include "stdio.h"

static int hierarquia_tipo(int tipo){
	switch(tipo){
		case CHAR:
			return 0;
		case INT:
			return 1;
		case FLOAT:
			return 2;
		default:
			return -1;
	}
}

int retorna_maior_tipo(int tipo1, int tipo2){
	int hierarquia1 = hierarquia_tipo(tipo1);
	int hierarquia2 = hierarquia_tipo(tipo2);

	if(hierarquia1 == -1 || hierarquia2 == -1)
		return -1;

	if(hierarquia1 >= hierarquia2)
		return tipo1;

	return tipo2;
}

int get_tam_tipo(int tipo){
	switch(tipo){
		case CHAR:
			return 1;
		case INT:
			return 4;
		case FLOAT:
			return 4;
		case VOID:
			return 0;
		default:
			return 0;
	}
}

int tipos_inconsistentes_atrib(int tipo1, int tipo2){
	int hierarquia_destino = hierarquia_tipo(tipo1);
	int hierarquia_origem = hierarquia_tipo(tipo2);

	if(tipo1 == tipo2)
		return 0;

	if(hierarquia_destino == -1 || hierarquia_origem == -1)
		return 1;

	if(hierarquia_origem <= hierarquia_destino)
		return 0;

	return 1;
}
