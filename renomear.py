from pathlib import Path

PASTA = Path(r"C:\Users\João Victor\Desktop\BrasilCapital-9.0\bc-data\resources")

EXTENSOES_PERMITIDAS = {
    ".ymap", ".ymf", ".ytyp"
}

RENOMEADOS = 0

for arquivo in PASTA.rglob("*"):
    if not arquivo.is_file():
        continue

    if arquivo.suffix.lower() not in EXTENSOES_PERMITIDAS:
        continue

    if "rdshop" not in arquivo.name.lower():
        continue

    novo_nome = arquivo.name.replace("rdshop", "rdshop_brasilcapital")
    novo_nome = novo_nome.replace("RDSHOP", "rdshop_brasilcapital")
    novo_nome = novo_nome.replace("Rdshop", "rdshop_brasilcapital")

    novo_caminho = arquivo.with_name(novo_nome)

    if novo_caminho.exists():
        print(f"Já existe, pulado: {novo_caminho}")
        continue

    arquivo.rename(novo_caminho)
    RENOMEADOS += 1
    print(f"Renomeado: {arquivo} -> {novo_caminho}")

print(f"\nTotal renomeado: {RENOMEADOS}")