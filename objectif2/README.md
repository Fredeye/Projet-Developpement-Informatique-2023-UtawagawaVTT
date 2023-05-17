### Objectif 2: Construire une couche de tuiles HD terrain-rgb mondiale
## Téléchargement préliminaire
* [Chocolatey](https://chocolatey.org/install#individual)
* [Anaconda3](https://www.anaconda.com/download)
* Les outils présents dans le dossier "telechargement_preliminaire"
* Sur un terminal, exécuter en tant qu'administrateur:

```
choco install wget
```
Cela permettra d'avoir l'outil wget permettant de télécharger les fichiers nécessaires à partir d'URL.

## Comment lancer le script ?

# Environnement 
Lancer le terminal Anaconda Prompt précédement télécharger.

Dans le terminal: 
```
conda create --name mon_env python=3.9 gdal
```
Cela permet d'avoir la bonne version de python compatible avec les librairies gdal/rasterio.

Excécuter:
```
conda activate mon_env 
```
Se placer dans le répertoire où se trouve le script:
```
cd chemin/objectif2/zone_etude/script
```
Excécuter le script:
```
script_zone_etude.sh
```
