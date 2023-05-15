#!/bin/bash

# Installation librairie
pip install git+https://github.com/frodrigo/rio-rgbify.git@round_digits

# Production MBTILES zoom 0 à 16
rm -fr ../z_0_16 && mkdir -p ../z_0_16

# Reprojection des tuiles ASC en EPSG:3857
for file in ../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073/*.asc; do
    gdalwarp -s_srs EPSG:2154 -t_srs EPSG:3857 $file ../z_0_16/$(basename ${file%.*}).tif
done

for file in ../telechargement_mnt/italie/*.tif; do
    gdalwarp -t_srs EPSG:3857 $file ../z_0_16/$(basename ${file%.*}).tif
done

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_0_16/MNT_z_0_16.virt ../z_0_16/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_0_16/MNT_z_0_16.virt ../z_0_16/MNT_z_0_16.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_0_16/MNT_z_0_16.tif --outfile=../z_0_16/MNT_z_0_16_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération de la tuile autour de la zone d'étude pour les zooms 0 à 16
rio rgbify -b -10000 -i 0.1 --max-z 16 --min-z 0 ../z_0_16/MNT_z_0_16_mer_0.tif ../z_0_16/MNT_z_0_16.mbtiles
