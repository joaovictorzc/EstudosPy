# Guia passo a passo do Trabalho 4

## 1. O que o trabalho faz

Este trabalho implementa a etapa semântica de um compilador simples. Ele não executa o programa de entrada. Ele lê o código, reconhece a estrutura pela gramática e faz verificações como:

- variável usada sem ter sido declarada;
- função chamada sem ter sido declarada;
- quantidade de argumentos diferente da quantidade de parâmetros;
- atribuição com tipos incompatíveis;
- cálculo do tipo resultante de expressões.

Quando não encontra erro, imprime:

```text
Compilação Finalizada
```

Quando encontra erro, chama `yyerror`, que imprime a mensagem e a linha.

## 2. Ordem correta para entender o projeto

### Passo 1 — Entender o léxico em `analex.l`

O Flex lê o texto do programa e transforma em tokens.

Exemplo:

```c
int a;
a = 10;
```

Vira algo como:

```text
INT ID ; ID = NUM ;
```

Quando encontra um identificador, o léxico faz:

```c
yylval.simbolo.posicao = insere(yytext);
yylval.simbolo.lexema = yytext;
return ID;
```

Ou seja, todo `ID` já entra na tabela de símbolos e o parser recebe a posição dele.

### Passo 2 — Entender `yylval`, `$1`, `$2` e `$$`

`yylval` é o valor que o léxico entrega ao sintático.

No Yacc/Bison:

- `$1` é o valor do primeiro símbolo da regra;
- `$2` é o valor do segundo;
- `$3` é o valor do terceiro;
- `$$` é o valor produzido pela regra inteira.

Exemplo:

```yacc
Exp : Exp '+' Exp { $$ = retorna_maior_tipo($1, $3); }
```

Aqui o tipo da expressão final é o maior tipo entre os dois lados.

### Passo 3 — Entender os tipos

Os tipos usados são:

- `CHAR`
- `INT`
- `FLOAT`
- `VOID`

A promoção de tipos segue esta ideia:

```text
CHAR -> INT -> FLOAT
```

Então:

```c
10 + 2.3
```

vira:

```text
INT + FLOAT = FLOAT
```

### Passo 4 — Entender a tabela de símbolos

A tabela fica em `tabsimb.h`.

Cada símbolo guarda:

```c
nome
tipo
tamanho
número de parâmetros
categoria
```

A categoria separa variável de função:

```c
CAT_VAR
CAT_FUNC
```

Isso é importante porque uma variável declarada não deve ser aceita como função.

### Passo 5 — Entender declaração de variáveis

Regra principal:

```yacc
Decl : Type IDs
```

O `Type` retorna `INT`, `CHAR` ou `FLOAT`.

O `IDs` retorna uma lista de identificadores.

Depois o parser percorre a lista e aplica o tipo em cada variável:

```c
for (i = 0; i < $2.tam; i++) {
    set_type($2.ids[i], $1);
    set_categoria($2.ids[i], CAT_VAR);
}
```

### Passo 6 — Entender expressão

As regras de expressão calculam o tipo final.

Operação matemática:

```yacc
Exp '+' Exp { $$ = retorna_maior_tipo($1, $3); }
```

Comparação:

```yacc
Exp '>' Exp { $$ = INT; }
```

Variável:

```yacc
ID {
    verifica_var_declarada($1.posicao);
    $$ = Tabela[$1.posicao].tipo;
}
```

### Passo 7 — Entender atribuição

Regra principal:

```yacc
Atribuicao : ID '=' Exp
```

Ela faz três coisas:

```c
verifica_var_declarada($1.posicao);
verifica_tipos_atrib(Tabela[$1.posicao].tipo, $3);
$$ = $1.posicao;
```

Ou seja:

1. verifica se a variável existe;
2. compara o tipo da variável com o tipo da expressão;
3. devolve a posição da variável.

### Passo 8 — Entender funções

Quando uma função é declarada, o parser registra:

```c
set_type(posicao, tipo_retorno);
set_categoria(posicao, CAT_FUNC);
set_num_param(posicao, quantidade_parametros);
```

Quando uma função é chamada, o parser verifica:

```c
verifica_func_declarada(posicao);
param_args_diferentes(posicao, quantidade_argumentos);
```

Se a quantidade de argumentos for diferente, gera erro.

## 3. Trechos que mais têm chance de cair

### Type

```yacc
Type :
      INT { $$ = INT; }
    | CHAR { $$ = CHAR; }
    | FLOAT { $$ = FLOAT; }
;
```

### Expressão matemática

```yacc
Exp '+' Exp { $$ = retorna_maior_tipo($1, $3); }
```

### Comparação

```yacc
Exp '>' Exp { $$ = INT; }
```

### ID em expressão

```yacc
ID {
    verifica_var_declarada($1.posicao);
    $$ = Tabela[$1.posicao].tipo;
}
```

### Atribuição

```yacc
ID '=' Exp {
    verifica_var_declarada($1.posicao);
    verifica_tipos_atrib(Tabela[$1.posicao].tipo, $3);
    $$ = $1.posicao;
}
```

### Chamada de função

```yacc
ID '(' ArgList ')' {
    verifica_func_declarada($1.posicao);
    if (param_args_diferentes($1.posicao, $3.tam))
        yyerror("Argumentos e parâmetros da função não coincidem.");
    $$ = Tabela[$1.posicao].tipo;
}
```

## 4. Como executar

Dentro da pasta do projeto:

```bash
./verifica_inconsistencias.sh entradas_saidas/
```

Ou manualmente:

```bash
flex -o analex.c analex.l
bison -d -o sint.c sint.y
gcc -o sint sint.c -lfl
./sint entradas_saidas/entrada1.c
```

Se o `-lfl` der erro, tente:

```bash
gcc -o sint sint.c
```

## 5. Resumo para explicar ao professor

O trabalho usa o Flex para reconhecer tokens e o Yacc/Bison para reconhecer a gramática. O léxico insere identificadores na tabela de símbolos e passa a posição pelo `yylval`. No parser, as ações semânticas usam `$1`, `$2`, `$3` e `$$` para propagar tipos, registrar variáveis e funções, conferir se identificadores foram declarados, calcular tipos de expressões e validar atribuições e chamadas de função.
