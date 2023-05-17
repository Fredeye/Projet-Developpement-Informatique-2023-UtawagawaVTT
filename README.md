# Géodév 2023 Projet UtagawaVTT : Cartographie GPS pour le VTT

## Contexte général du projet à réaliser:

UtagawaVTT est un site communautaire de partage de randonnées pour le VTT.

Avec plus de 18000 traces GPS de circuits, le site rassemble plus de 250 000 membres et reçoit 10 000 visiteurs par jour. Animé par une équipe de bénévoles, il continue d’apporter à la communauté des pratiquants des services à valeur ajoutée.

En 2022, la création d’une cartographie spécialisée pour le VTT a débuté.

Basée sur la version actuelle, une nouvelle version est attendue pour y intégrer des bonnes pratiques cartographiques et y ajouter des informations plus précises.

La cartographie est basée sur les données OpenStreetMap via le standard Openmapstyle et propulsée par un server Tilserver-GL.

Les styles sont compatibles avec le format Mapbox et éditables en WYSIWYG avec l’outil Maputnik.

La carte est disponible sur htpps://maps.utagawavtt.com

## Objectifs fixés

1/ Valider et améliorer le style de carte dans une version 2 en utilisant les bonnes pratiques de représentation cartographique vis-à-vis de l’usage souhaité : mise en valeur des éléments utiles à la pratique du VTT. 

2/ Construire une couche de tuiles terrain-rgb mondiale intégrable en mode raster-dem dans le style mapbox de la carte.
Cette couche doit se baser sur les données MNT 1M des pays lorsque c’est disponible (comme la France) et le reste avec les données du MNT NASADEM. 30m.

Cette couche sera utilisée pour générer les ombrages détaillés de la carte UtagawaVTT et générer une version 3D.

Les zoom 1 à 15 sont attendus.

3/ Traduire le style de la carte en une version adaptée aux GPS Garmin.

## Documentation

Pour l'objectif 2/, les scripts de makina corpus ont été adaptés afin de générer les tuiles terrain-RGB.
* [les scripts de Makina Corpus](https://makina-corpus.com/sig-webmapping/representation-des-modeles-numeriques-de-terrain-sur-le-web-ombrage-et-3d)
* [Tutoriel pour gdal_hillshade](https://github.com/clhenrick/gdal_hillshade_tutorial)

* [Ravenfeld: Garmin custom map](https://gitlab.com/ravenfeld/garmincustommap)
* [Ravenfeld: Open garmin map](https://ravenfeld.gitlab.io/open-garmin-map/)





