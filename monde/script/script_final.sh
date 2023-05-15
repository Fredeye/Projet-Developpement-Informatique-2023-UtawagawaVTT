#!/bin/bash

# Installation librairie
pip install git+https://github.com/frodrigo/rio-rgbify.git@round_digits
choco install wget

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Téléchargement des données MNT monde

# Téléchargement des données RGE ALTI 1m et 5m (fichiers .7z)
# RGE ALTI 1m
RGE ALTI 1m
curl http://files.opendatarchives.fr/professionnels.ign.fr/rgealti/ | \
    grep _1M_ASC_ | cut -d '"' -f 2 | sed -e "s_^_http://files.opendatarchives.fr/professionnels.ign.fr/rgealti/_" \
    > url_1m

# RGE ALTI 5m
curl http://files.opendatarchives.fr/professionnels.ign.fr/rgealti/ | \
    grep _5M_ASC_ | cut -d '"' -f 2 | sed -e "s_^_http://files.opendatarchives.fr/professionnels.ign.fr/rgealti/_" \
    > url_5m

# wget -i url_1m -P ../telechargement_mnt/telechargement_1m
wget -i url_5m -P ../telechargement_mnt/telechargement_5m 

# Téléchargement des MNT italiens (fichiers .zip)
wget -r -np -nH --cut-dirs=3 -R "index.html*" -A "*s10.zip" -P ../telechargement_mnt/telechargement_italie --no-check-certificate https://tinitaly.pi.ingv.it/Download_Area1_1.html

# Téléchargement des MNT suisses 50cm et 2m (fichiers .tif)
wget -i url_suisse_50cm.csv ../telechargement_mnt/telechargement_suisse_50cm/asc
wget -i url_suisse_2m.csv ../telechargement_mnt/telechargement_suisse_2m/asc

# Téléchargement des MNT europe à 30m NASADEM
# https://opentopography.s3.sdsc.edu/minio/raster/NASADEM/NASADEM_be/ # Lien (wget n'a pas l'autorisation pour automatiser le téléchargement)

# Téléchargement MNT monde 2000m et 250m(fichier .tif)
wget -P ../telechargement_mnt/telechargement_monde_2000m/asc https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO2022/data/60s/60s_bed_elev_gtif/ETOPO_2022_v1_60s_N90W180_bed.tif
# https://www.bodc.ac.uk/data/open_download/gebco/gebco_2023/geotiff/ # Lien pour le 250m (wget ne télécharge pas le bon fichier)

# Extraction des données 7z
mkdir -p ../telechargement_mnt/telechargement_1m/asc && 7z x ../telechargement_mnt/telechargement_1m/*.7z -o../telechargement_mnt/telechargement_1m/asc -aos
mkdir -p ../telechargement_mnt/telechargement_5m/asc && 7z x ../telechargement_mnt/telechargement_5m/*.7z -o../telechargement_mnt/telechargement_5m/asc -aos
mkdir -p ../telechargement_mnt/telechargement_italie/asc && 7z x ../telechargement_mnt/telechargement_italie/*.zip -o../telechargement_mnt/telechargement_italie/asc -aos
mkdir -p ../telechargement_mnt/telechargement_monde_250m/asc && 7z x ../telechargement_mnt/telechargement_monde_250m/*.zip -o../telechargement_mnt/telechargement_monde_250m/asc -aos

# Suppression des zip
rm ../telechargement_mnt/telechargement_1m/*.7z
rm ../telechargement_mnt/telechargement_5m/*.7z
rm ../telechargement_mnt/telechargement_italie/*.zip
rm ../telechargement_mnt/telechargement_monde_250m/*.zip

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Création des dossiers où l'on va mettre tous les geoTiff reprojetés selon leur niveau de zoom correspondant
rm -fr ../z_11_16 && mkdir -p ../z_11_16
rm -fr ../z_8_10 && mkdir -p ../z_8_10
rm -fr ../z_5_7 && mkdir -p ../z_5_7
rm -fr ../z_0_4 && mkdir -p ../z_0_4

# Reprojection des tuiles ASC en EPSG:3857 pour zoom 11 à 16
for file in ../telechargement_mnt/telechargement_5m/asc/*.asc; do
    gdalwarp -s_srs EPSG:2154 -t_srs EPSG:3857 $file ../z_11_16/$(basename ${file%.*}).tif
done

for file in ../telechargement_mnt/telechargement_italie/asc/*.tif; do
    gdalwarp -t_srs EPSG:3857 $file ../z_11_16/$(basename ${file%.*}).tif
done

for file in ../telechargement_mnt/telechargement_suisse_2m/asc/*.tif; do
    gdalwarp -t_srs EPSG:3857 $file ../z_11_16/$(basename ${file%.*}).tif
done


# Reprojection des tuiles ASC en EPSG:3857 pour zoom 5 à 7
for file in ../telechargement_mnt/telechargement_monde_250m/asc/*.tif; do
    gdalwarp -t_srs EPSG:3857 $file ../z_5_7/$(basename ${file%.*}).tif
done

# Reprojection des tuiles ASC en EPSG:3857 pour zoom 0 à 4
for file in ../telechargement_mnt/telechargement_monde_2000m/asc/*.tif; do
    gdalwarp -t_srs EPSG:3857 $file ../z_0_4/$(basename ${file%.*}).tif
done

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Production MBTILES zoom 11 à 16

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_11_16/MNT_z_11_16.virt ../z_11_16/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_11_16/MNT_z_11_16.virt ../z_11_16/MNT_z_11_16.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_11_16/MNT_z_11_16.tif --outfile=../z_11_16/MNT_z_11_16_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération des tuiles MBtiles
rio rgbify -b -10000 -i 0.1 --max-z 16 --min-z 11 ../z_11_16/MNT_z_11_16_mer_0.tif ../z_11_16/MNT_z_11_16.mbtiles

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Production MBTILES zoom 8 à 10

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_8_10/MNT_z_8_10.virt ../z_8_10/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_8_10/MNT_z_8_10.virt ../z_8_10/MNT_z_8_10.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_8_10/MNT_z_8_10.tif --outfile=../z_8_10/MNT_z_8_10_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération des tuiles MBtiles
rio rgbify -b -10000 -i 0.1 --max-z 10 --min-z 8 ../z_8_10/MNT_z_8_10_mer_0.tif ../z_8_10/MNT_z_8_10.mbtiles

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Production MBTILES zoom 5 à 7

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_5_7/MNT_z_5_7.virt ../z_5_7/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_5_7/MNT_z_5_7.virt ../z_5_7/MNT_z_5_7.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_5_7/MNT_z_5_7.tif --outfile=../z_5_7/MNT_z_5_7_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération des tuiles MBtiles
rio rgbify -b -10000 -i 0.1 --max-z 7 --min-z 5 ../z_5_7/MNT_z_5_7_mer_0.tif ../z_5_7/MNT_z_5_7.mbtiles

# ____________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Production MBTILES zoom 0 à 4

# Assemblage des tuiles ASC en une image virtuelle
gdalbuildvrt -a_srs EPSG:3857 -hidenodata ../z_0_4/MNT_z_0_4.virt ../z_0_4/*.tif

# Conversion de l’image virtuelle en GeoTiff
gdal_translate -co compress=lzw -of GTiff ../z_0_4/MNT_z_0_4.virt ../z_0_4/MNT_z_0_4.tif

# Passage des données en mer à l'altitude 0
gdal_calc.py --co="COMPRESS=LZW" --type=Float32 -A ../z_0_4/MNT_z_0_4.tif --outfile=../z_0_4/MNT_z_0_4_mer_0.tif --calc="A*(A>0)" --NoDataValue=0

# Génération des tuiles MBtiles
rio rgbify -b -10000 -i 0.1 --max-z 4 --min-z 0 ../z_0_4/MNT_z_0_4_mer_0.tif ../z_0_4/MNT_z_0_4.mbtiles


