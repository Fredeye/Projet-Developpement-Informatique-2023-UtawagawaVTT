Script final permettant la génération de 4 fichiers MBtiles pour les zoom 0 à 16

Le script final ne fonctionnerait que si les fichiers sont correctements téléchargés
Cependant, il pourrait être repris afin de finir le projet

Pour tester le script test_monde_250m: télécharger https://www.bodc.ac.uk/data/open_download/gebco/gebco_2023/geotiff/
et extraire les fichiers dans le dossier ../telechargement_mnt/telechargement_monde_250m/asc

Environnement : Terminal Anaconda Prompt sous Windows

Prérequis : Anaconda3 

Dans le terminal: 
conda create --name mon_env python=3.9 gdal

Cela permet d'avoir la bonne version de python compatible avec les librairies gdal/rasterio plus tard.

Se placer dans le dossier ../monde/script et exécuter:
script_final.sh


