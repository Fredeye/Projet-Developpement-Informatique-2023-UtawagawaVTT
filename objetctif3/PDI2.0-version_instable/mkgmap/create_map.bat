
echo "Creation of the map  ...."

set land=FRANCE-LATEST
set id=77
set type=utagawa

set land_lower=corse-latest

set file=..\%land_lower%.osm.pbf
set poly=%land_lower%.poly
set type_upper=UTAGAWA

cd carte_%land_lower%

set name= Map%type_upper%%land%
set mapname=77%id%
set mapname_courbes=88%id%
set name_file=Map%type_upper%_%%land_without_space%_



set count=0
for /f %%i in ('dir /b *.osm.gz 2^>nul ^| find /c /v ""') do set count=%%i
if %count% neq 0 (
  del *.img
  echo Split contour ....
  
  java -Xmx32768m -jar ..\splitter\splitter.jar --mapid=%mapname_courbes%0000 --max-nodes=1600000 --polygon-file=%poly% --keep-complete=false *.osm.gz
  

  del areas.list
  del areas.poly
  del courbes.args
  del none-areas.poly
  del none-template.args
  del densities-out.txt
  del osmmap.img
  del osmmap.tdb
  del *.osm.gz
)

if not exist "%mapname%.osm.pbf" (
  echo Split ....
  
  java -Xmx32768m -jar ..\splitter\splitter.jar --mapid=%mapname%0000 --max-nodes=1600000 --keep-complete=true --route-rel-values=foot,hiking --overlap=0 %file%
  
  move template.args map.args
)

java -Xmx32768m -jar mkgmap.jar -c ..\options_%type%.args -c map.args

if exist "%mapname_courbes%0000.img" (
  java -Xmx32768m -jar mkgmap.jar --mapname=%mapname%0000 --family-id=%mapname% --description="%name%" -c ..\options_%type%.args --gmapsupp ..\style\%type%.typ %mapname%*.img %mapname_courbes%*.img
) else (
  java -Xmx32768m -jar mkgmap.jar --mapname=%mapname%0000 --family-id=%mapname% --description="%name%" -c ..\options_%type%.args --gmapsupp ..\style\%type%.typ %mapname%*.img
)

del %mapname%*.img
del %mapname%*.osm.pbf
del areas.list
del areas.poly
del map.args
del densities-out.txt
del osmmap.img
del osmmap.tdb
