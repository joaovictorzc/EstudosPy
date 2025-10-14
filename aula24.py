# Operadores in e not in
# Strings são iteraveis
#  0 1 2 3 4 5
#  O t a v i o
# -6-5-4-3-2-1

# nome = 'Otavio'

# print(nome[2])
# print(nome[-4])
# print(10*'-')

# print('a' in nome)
# print('z' in nome)
# print(10*'-')

# print('vio' not in nome)
# print('zero' not in nome)

nome = input('Digite seu nome: ')
encontrar = input('Digite o que deseja encontrar: ')

if encontrar in nome:
    print(f'{encontrar} está em {nome}')
else:
    print(f'{encontrar} não está em {nome}')