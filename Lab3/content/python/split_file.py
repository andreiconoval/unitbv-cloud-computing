#!/usr/bin/env python3

import sys

def imparte_in_blocuri(nume_fisier, numar_blocuri):
    # Citește toate liniile din fișier
    with open(nume_fisier, 'r') as f:
        linii = f.readlines()

    # Calculăm dimensiunea fiecărui bloc și restul
    numar_linii = len(linii)
    linii_per_bloc, rest = divmod(numar_linii, numar_blocuri)

    # Împărțim liniile în blocuri cvasi-egale
    blocuri = []
    start = 0
    for i in range(numar_blocuri):
        # Atribuie o linie în plus primelor blocuri dacă restul este nenul
        end = start + linii_per_bloc + (1 if i < rest else 0)
        blocuri.append(linii[start:end])
        start = end

    # Scrie fiecare bloc într-un fișier nou
    for index, bloc in enumerate(blocuri):
        with open(f"bloc_{numar_blocuri}_{index + 1}.txt", 'w') as f:
            f.writelines(bloc)

# Exemplu de utilizare: numele fișierului și numărul de blocuri specificat
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Utilizare: python3 program.py <nume_fisier> <numar_blocuri>")
        sys.exit(1)
    
    nume_fisier = sys.argv[1]
    numar_blocuri = int(sys.argv[2])
    imparte_in_blocuri(nume_fisier, numar_blocuri)
