"""
Formatação básica de strings
s - string
d - int
f - float
.<número de dígitos>f
x ou X - Hexadecimal
(Caractere)(><^)(quantidade)
> - Esquerda
< - Direita
^ - Centro
= - Força o número a aparecer antes dos zeros
Sinal - + ou -
Ex.: 0>-100,.1f
Conversion flags - !r !s !a 
"""

variavel = 'ABC'
print(f'{variavel}')
print(f'{variavel: >10}') # Largura fixa á esquerda
print(f'{variavel: <10} .') # Largura fixa á direita
print(f'{variavel: ^10} .') # Centralizar com 5 de cada lado

print(f'{1000.4873648123746:,.1f}') # Uma casa decimal com virgula
print(f'{1000.4873648123746:0=+10,.1f}') # Nem vai usar

print(f'O hexadecimal de 1500 é {1500:08X}')
print(f'O hexadecimal de 1500 é {1500:08x}')

print(f'{variavel!r}')