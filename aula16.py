# if / elif      / else
# se / se não se / senão

entrada = input('Digite se você quer "entrar" ou "sair":')

if entrada == 'entrar':
    print('você entrou')
elif entrada == 'Entrar':
    print('você entrou')
elif entrada == 'sair':
    print('você saiu')
elif entrada == 'Sair':
    print('você saiu')
else:
    print('digite alguma das opções de "entrar" ou "sair".')