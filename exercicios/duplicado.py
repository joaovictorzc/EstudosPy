import os
from collections import defaultdict

def encontrar_arquivos_duplicados(diretorio_base):
    arquivos_por_nome = defaultdict(list)

    for raiz, _, arquivos in os.walk(diretorio_base):
        for arquivo in arquivos:
            caminho_completo = os.path.join(raiz, arquivo)
            arquivos_por_nome[arquivo].append(caminho_completo)

    # Retorna apenas os arquivos com nomes repetidos (mesmo nome + extensão)
    duplicados = {nome: caminhos for nome, caminhos in arquivos_por_nome.items() if len(caminhos) > 1}
    return duplicados

def listar_duplicados(duplicados):
    print("\n=== 🔍 LISTA DE ARQUIVOS DUPLICADOS ===\n")
    for nome, caminhos in duplicados.items():
        print(f"📄 Arquivo: {nome}")
        for caminho in caminhos:
            print(f"   ↳ {caminho}")
        print("-" * 60)

def apagar_duplicados(duplicados):
    total_excluidos = 0
    print("\n=== 🧹 APAGANDO DUPLICADOS ===\n")

    for nome, caminhos in duplicados.items():
        print(f"📄 {nome}")
        print(f"   Mantendo: {caminhos[0]}")

        for caminho in caminhos[1:]:
            try:
                os.remove(caminho)
                print(f"   ❌ Removido: {caminho}")
                total_excluidos += 1
            except Exception as e:
                print(f"   ⚠️ Erro ao remover {caminho}: {e}")

        print("-" * 60)

    print(f"\n✅ Concluído! {total_excluidos} arquivos duplicados foram apagados.")

def main():
    print("=== 🧩 Verificador de Arquivos Duplicados ===")
    diretorio = input("Informe o caminho da pasta que deseja verificar: ").strip()

    if not os.path.exists(diretorio):
        print("❌ Caminho inválido.")
        return

    duplicados = encontrar_arquivos_duplicados(diretorio)

    if not duplicados:
        print("\n✅ Nenhum arquivo duplicado encontrado.")
        return

    listar_duplicados(duplicados)

    confirmar = input("\nDeseja apagar os arquivos duplicados listados? (s/n): ").strip().lower()
    if confirmar == 's':
        apagar_duplicados(duplicados)
    else:
        print("\n🚫 Nenhum arquivo foi apagado.")

if __name__ == "__main__":
    main()
