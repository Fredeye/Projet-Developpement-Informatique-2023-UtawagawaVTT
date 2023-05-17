# Objectif 2: Construire une couche de tuiles HD terrain-rgb mondiale
## Téléchargement préliminaire
* [Chocolatey](https://chocolatey.org/install#individual)
* [Anaconda3](https://www.anaconda.com/download)
* [Git bash](https://gitforwindows.org/)
* Les outils présents dans le dossier "telechargement_preliminaire"
* Sur un terminal, exécuter en tant qu'administrateur:

```
choco install wget
```
Cela permettra d'avoir l'outil wget permettant de télécharger les fichiers nécessaires à partir d'URL.

## Ordre chronologique
L'objectif a été divisé en 2 temps: 
* Développer un algorithme fonctionnel sur une zone d'étude
* L'appliquer sur le monde entier

### Zone d'étude
Le script est fonctionnel et donne: 
[!Niveau mer 0](./img/MNT_zone_etude_niveau_mer_0.PNG)
[!Mbtiles](./img/mbtiles.PNG)

## Comment lancer le script pour la zone d'étude?

### Environnement 
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

### Fichiers en sortie
Dans le dossier ../z_0_16 devrait se trouver:
* Tous les MNT reprojetés (fichiers .tif), soit 305 MNT français et 1 MNT italien
* Une image virtuelle vide (fichier .vrt)
* Deux fichiers geotiff (.tif) représentant l'assemblage des MNT reprojetés dans l'image virtuelle ainsi et le fichier avec les données en mer remises à 0
* Un fichier .mbtiles qui est la tuile en terrain-RGB pour les zoom 0 à 16

### Erreurs possibles
La plus grande source d'erreur est l'installation de l'environnement: au cours du projet, nous nous sommes confrontés à beaucoup d'erreurs d'incompatibilités des librairies utilisées notamment Rasterio avec Proj et Gdal ou python avec Gdal.

Si le fichier .mbtiles est corrompu ou inexistant, vérifier la compabilité de Rasterio avec Proj. Il faut une version antérieur à 1.1.2 de Rasterio pour une version 6.X de proj. (https://github.com/rasterio/rasterio/issues/2103)
