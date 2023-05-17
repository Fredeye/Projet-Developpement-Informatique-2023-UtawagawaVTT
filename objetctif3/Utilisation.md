# Création de la carte UtagawaVTT pour montres Garmin

Notre objectif est de proposer ici une brève *description de l'utilisation du code* source ayant servi à la production des cartes disponibles au format GARMIN .img que l'on a déjà réalisées et qui seront partagées sur https://www.utagawavtt.com/.

Ces cartes sont transferables sur les appareils compatibles et sont adaptées aux utilisateurs VTTistes.

Le code source ainsi disponible permettra à celui qui le souhaite de produire de nouvelles cartes avec une sémiologie et un contenu différents ou d'en actualiser les données. On présente ici les *deux fonctionalités*. 


## Obtenir une carte GARMIN pour le VTT

*Une carte d'exemple est fournie dans le dossier PDI1.0 générée à partir de toute la france, une carte de monaco est fournie dans PDI2.0 elle a été construite à partir du fichier texte europe.txt contenu dans le dossier geofabrik et qui est personnalisable.

## Générer une carte

**Vérifiez que vous avez convenablement établi l'environnement de travail détaillé dans *Installation.md*.**

**Lancez *main.bat* en double-cliquant dessus.**

**Choisissez une méthode de travail (create/update)**

La méthode create génère une carte si vous n'en avez pas encore, la méthode update permet de générer une nouvelle carte actualisant les données OSM sans recalculer toute les courbes de niveau et ainsi avec un gros gain de temps.

**Choisissez la zone que couvrira (continent/pays/région)**

Vous devez le faire suivant la manière de https://download.geofabrik.de/ tel que écrit dans l'url, par exemple:

continent:europe
pays:france
region:corse
*Vous pouvez générer une carte d'un pays entier en utilisant la valeur region:all* de plus la version 2.0 permet de générer les pays de l'ensemble d'un continent. Pour cela il faut d'entrer country=all à condition que un fichier texte porte le nom du continent existe dans le dossier geofabrik et qu'il contienne la liste des pays souhaités.
continent:europe
pays:france
region:all
**Laissez tourner !**

Vous aurez besoin à ce moment de rentrer votre identifiant et mot de passe pour le site https://urs.earthdata.nasa.gov/home

**Retrouvez votre carte dans le repertoire *carte_pays_region/carte_***

Le second sous repertoire est un fichier contenant des courbes de niveaux utilisées pour créer votre carte. Elle ne sont pas supprimées car elles peuvent être réutilisées avec la méthode **update** ce qui améliore considérablement le temps de calcul.

! Pour utiliser la méthode update le repertoire de fin de calcul doit être replacé à la racine comme lorsqu'il est produit.


```python

```
