a = 'Joao'
b = 'Victor'
c = '24'
d = 897389.872323

formato = 'nome={}\nsegundonome={}\nidade={}'.format(a,b,c)
print(formato)

string = 'nome={}\nsegundonome={}\nidade={}\nnumero={:.2f}'
formato_2 = string.format(a,b,c,d)
print(formato_2)
