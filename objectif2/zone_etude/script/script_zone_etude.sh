#!/bin/bash

# Installation librairie
pip install git+https://github.com/frodrigo/rio-rgbify.git@round_digits

# Téléchargement des MNT de la zone d'étude
wget http://files.opendatarchives.fr/professionnels.ign.fr/rgealti/RGEALTI_2-0_5M_ASC_LAMB93-IGN69_D073_2020-10-15.7z -P ../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073
wget --no-check-certificate https://tinitaly.pi.ingv.it/data_1.1/w50030_s10/w50030_s10.zip -P ../telechargement_mnt/italie

# Extraction des données
mkdir -p ../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073/asc && \
ls ../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073/*.7z | xargs -n 1 7z x -o../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073/asc -aos

mkdir -p ../telechargement_mnt/italie/asc && \
ls ../telechargement_mnt/italie/*.zip | xargs -n 1 7z x -o../telechargement_mnt/italie/asc -aos

# Production MBTILES zoom 0 à 11
rm -fr ../z_0_16 && mkdir -p ../z_0_16

# Reprojection des tuiles ASC en EPSG:3857
find ../telechargement_mnt/RGEALTI_MNT_5M_ASC_LAMB93_IGN69_D073/asc -type f -name "*.asc" | while read -r file; do
    gdalwarp -s_srs EPSG:2154 -t_srs EPSG:3857 "$file" "../z_0_16/$(basename "${file%.*}").tif"
done

find ../telechargement_mnt/italie/asc -type f -name "*.tif" | while read -r file; do
    gdalwarp -t_srs EPSG:3857 "$file" "../z_0_16/$(basename "${file%.*}").tif"
done

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_0_16/MNT_z_0_16.virt ../z_0_16/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_0_16/MNT_z_0_16.virt ../z_0_16/MNT_z_0_16.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_0_16/MNT_z_0_16.tif --outfile=../z_0_16/MNT_z_0_16_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération de la tuile autour de la zone d'étude pour les zooms 0 à 11
rio rgbify -b -10000 -i 0.1 --max-z 11 --min-z 0 ../z_0_16/MNT_z_0_16_mer_0.tif ../z_0_16/MNT_z_0_16.mbtiles
