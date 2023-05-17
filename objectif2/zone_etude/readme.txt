Script pour la zone d'étude avec les MNT région Savoie et une zone d'Italie.
Génère une tuile MBtiles pour la zone d'étude

Environnement : Terminal Anaconda Prompt sous Windows

Prérequis : Anaconda3 

Dans le terminal: 
conda create --name mon_env python=3.9 gdal

Cela permet d'avoir la bonne version de python compatible avec les librairies gdal/rasterio plus tard.

Se placer dans le dossier ../zone_etude/script et exécuter:
script_zone_etude.sh

