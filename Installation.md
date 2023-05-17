# Création de la carte UtagawaVTT pour montres Garmin

Notre objectif est de proposer ici le code source ayant servi à la production des cartes disponibles au format GARMIN .img que l'on a déjà réalisées et qui seront partagées sur https://www.utagawavtt.com/.

Ces cartes sont transferables sur les appareils compatibles et sont adaptées aux utilisateurs VTTistes.

Le code source ainsi disponible permettra à celui qui le souhaite de produire de nouvelles cartes avec une sémiologie et un contenu différents ou d'en actualiser les données.

# *Installation*

## Téléchargement des scripts

Il suffit pour cela de récupérer sur votre ordinateur le dossier *map_utagawa_garmin*. Il contient notamment les scripts qui vont générer la carte et édités lors de ce projet, les trois logiciels utiles à la création de la carte (*mkgmap*,*splitter*,*hgt2osm*), un dossier zippé *sea.zip* contenant les mers et un répertoire *dem* vide qui servira au téléchargement des données des mnt. Si vous le placez dans C: vous pourrez utiliser le raccourci contenu dans le dossier et le glisser sur votre bureau.

## Créez vous un compte pour télécharger les données MNT

Créez vous un compte sur https://urs.earthdata.nasa.gov/home . Conservez vos identifiants et mots de passe, vous en aurez besoin pour lancer les scripts.

## Mise en place de l'environnement de travail

### Java

Votre ordinateur doit être équipé de java afin de pouvoir lancer mkgmap et le splitter.

### Python

Vous devez télécharger *python* version 3 ou supérieure.Vous devez vous assurer que votre commande windows contient dans son *path* la bonne version de python. Tapez dans l'invite de commande:
python --version
Si vous possédiez déjà une version de python dans le path qui empêche d'accéder à la nouvelle version vous pouvez conserver le dossier contenant la version python du path, vider ce dossier (supprimer python) et y mettre la dernière version python téléchargée sur internet.

#### Librairies

Afin de faire fonctionner le script python *listing_hgt.py* il faut installer les bonnes librairies à l'aide de *pip*. Tapez les lignes suivantes dans une invite de commande.
pip install numpy
pip install shapely
Les librairies doivent être installées pour pouvoir lancer le script !

## curl

La lecture et les téléchargement des données hgt et osm suivant les liens internet contenus et construits dans les scripts nécéssitent l'installation de curl. Rendez-vous sur le site https://curl.se/ téléchargez la version disponible dans un répertoire de votre choix. Pas besoin de dézziper.

## 7z

Les dossiers hgt téléchargés doivent être dézippés à l'aide de 7z. Installer le si vous ne l'avez pas déjà sur votre ordinateur via https://www.7-zip.org/download.html. Ensuite vous devez vous rendre dans vos variables d'environement windows (dans les paramètres - sur internet il y a des exemples illustrés de comment procéder ) et ajouter le chemin vers 7zip.

# *Utilisation*

Et voilà ! Votre environnement de travail est prêt, vous n'avez plus qu'à lire le *Utilisation.md* pour en savoir plus sur les fonctionnalités et comment faire tourner les scripts.


```python

```