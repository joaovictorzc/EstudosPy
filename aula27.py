"""
Fatiamento de strings

    012345678
    Olá mundo
    -987654321

Fatiamento [i:f:p] [::]
    
    i = inicio
    f = fim
    p = passo de quantos em quantos vai pular

Obs.: a função len retorna a qtd de caracteres da str
"""

variavel = 'Olá mundo'

print(variavel[5])
print(variavel[-4])
print(variavel[4:])
print(variavel[4:8])
print(variavel[0:4])
print(variavel[:5])
print(variavel[0:9:2]) #pulando de dois em dois
print(variavel[::-1]) # contrario

print(len(variavel))
print(len(variavel[3]))