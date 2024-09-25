import numpy as np
import matplotlib.pyplot as plt
import heapq
import math
# Paramètres de discrétisation
h = 1  # pas de discrétisation
n, m = 100, 100  # taille de la grille
T = np.full((n, m), np.inf)  # fonction temps de passage (initialisée à l''infini)
F = 5  # vitesse constante (peut être ajustée selon l''image)

# Point de départ du front (milieu de la grille)
start_x, start_y = 40,30
T[40,30],T[41,30],T[39,30],T[30,29],T[40,31]= 0,0,0,0,0  # temps de passage initial

# File de priorité (tas) pour la méthode Fast Marching
heap = [(0, start_x, start_y)]

# Algorithme Fast Marching
while heap:
    t, x, y = heapq.heappop(heap)
    
    # Mise à jour des voisins de (x, y)
    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nx, ny = x + dx, y + dy
        if 0 <= nx < n and 0 <= ny < m:
            # Calcul de la nouvelle valeur de T pour (nx, ny)
            new_T = sqrt(h/F)
            if new_T < T[nx, ny]:
                T[nx, ny] = new_T
                heapq.heappush(heap, (new_T, nx, ny))

# Visualisation des courbes de niveau du front
plt.figure(figsize=(6, 6))
plt.contour(T, levels=20)
plt.title('Propagation du front - Méthode Fast Marching')
plt.show()
