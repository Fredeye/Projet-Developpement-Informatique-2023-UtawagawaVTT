REM *** This file create Garmin maps at .img format using mkgmap and splitter. TYP files and style files are also provided. ***
REM *** Edited by Marius Dahuron and Simon De Jaeghere for UTAGAWAVTT, adapted from Alexis Lecanu scripts. ***

echo "Creation of the map ..."

REM *READING PARAMETERS*

set url=%1
set type=%2
set land=%3

set id=77
set file=%land%-latest.osm.pbf
set poly=%land%.poly

set mapname=00%id%
set mapname_courbes=99%id%
set name=Map_%type%_%land%
set name_file=Map_%type%_%land%

move dem\dem_%land% carte_%land%

ren carte_%land%\dem_%land%  dem

cd carte_%land%

curl -L -o  %file% %url%-latest.osm.pbf
curl -L -o  %poly% %url%.poly

REM *Divide OSM data into smaller .pbf files containing at maximum 1600000 nodes*

if not exist "%mapname%.osm.pbf" (
  echo "Split OSM data ..."
  
  java -Xmx32768m -jar ..\splitter\splitter.jar --mapid=%mapname%0000 --max-nodes=1600000 --keep-complete=true --route-rel-values=foot,hiking,bicycle --overlap=0 %file%
  
  move template.args %mapname%.args
)


REM *Create Garmin .img file for each OSM file previously divided*

echo "Creating IMGs maps ..."

java -Xmx32768m -jar ..\mkgmap\mkgmap.jar -c ..\options_%type%.args -c %mapname%.args


REM *Creating the final map using .typ files and contour lines*

echo "Creating GMAPSUPP ..."

if exist "osm_courbes/%mapname_courbes%0000.img" (
  echo "Contour lines finded"
  java -Xmx32768m -jar ..\mkgmap\mkgmap.jar --mapname=%mapname%0000 --family-id=%mapname% --description="%name%" -c ..\options_%type%.args --gmapsupp ..\style\%type%.typ %mapname%*.img osm_courbes/%mapname_courbes%*.img
) else (
  echo "No contour lines finded"
  java -Xmx32768m -jar ..\mkgmap\mkgmap.jar --mapname=%mapname%0000 --family-id=%mapname% --description="%name%" -c ..\options_%type%.args --gmapsupp ..\style\%type%.typ %mapname%*.img
)

mkdir %name%
move gmapsupp.img %name%

rd /s /q dem
del *.img
del *.osm.pbf
del *.list
del *.poly
del *.args
del densities-out.txt
del osmmap.tdb
