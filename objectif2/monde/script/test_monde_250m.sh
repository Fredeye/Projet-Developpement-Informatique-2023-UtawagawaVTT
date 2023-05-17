#!/bin/bash

# Installation librairie
pip install git+https://github.com/frodrigo/rio-rgbify.git@round_digits

#Télchargement des MNT à 250m
wget --content-disposition https://www.bodc.ac.uk/data/open_download/gebco/gebco_2023/geotiff/

# Extraction des données 7z
mkdir -p ../telechargement_mnt/telechargement_monde_250m/asc && 7z x ../telechargement_mnt/telechargement_monde_250m/*.zip -o../telechargement_mnt/telechargement_monde_250m/asc -aos

# Production MBTILES zoom 0 à 16
rm -fr ../z_0_16 && mkdir -p ../z_0_16

# Reprojection des tuiles ASC en EPSG:3857 pour zoom 0 à 16
find ../telechargement_mnt/telechargement_monde_250m/asc -type f -name "*.tif" | while read -r file; do
    gdalwarp -t_srs EPSG:3857 "$file" "../z_0_16/$(basename "${file%.*}").tif"
done

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_0_16/MNT_z_0_16.virt ../z_0_16/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_0_16/MNT_z_0_16.virt ../z_0_16/MNT_z_0_16.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_0_16/MNT_z_0_16.tif --outfile=../z_0_16/MNT_z_0_16_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération des tuiles MBtiles
rio rgbify -b -10000 -i 0.1 --max-z 16 --min-z 0 ../z_0_16/MNT_z_0_16_mer_0.tif ../z_0_16/MNT_z_0_16.mbtiles
