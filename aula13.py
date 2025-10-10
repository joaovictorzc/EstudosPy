nome = 'Joao Victor Zanolli'
altura = 1.83
peso = 92.5
imc = peso / altura ** 2
reais = 1098230

linha_1 = f'{nome} tem {altura} cm de altura'
print(linha_1)

linha_2 = f'pesa {peso} quilos e seu IMC é'
print(linha_2)

# .2f é formatando quantas casas decimais eu quero
linha_3 = f'IMC: {imc:.2f}'
print(linha_3)

linha_4 = f'Tem na conta {reais:,.2f} reais'
print(linha_4)