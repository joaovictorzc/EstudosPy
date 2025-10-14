"""
Introdução ao try/except
try -> tentar executar o código
except -> ocorreu algum erro ao tentar executar
isdigit -> se o usuário digitou apenas números
"""
numero_string = input('Vou dobrar o número que vc digitar: ')

try:
    print('STR:', numero_string)
    numero_float = float(numero_string) # quando ocorre um erro tipo aqui se digitar a, ele pula pro except, não quebra o programa
    print('FLOAT:', numero_float)
    print(f'O dobro de {numero_string} é {numero_float * 2:.2f}')
except:
    print('Isso não é um número')

# if numero_str.isdigit():
#     numero_float = float(numero_str)
#     print(f'O dobro de {numero_str} é {numero_float * 2:.2f}')
# else:
#     print('Isso não é um número')