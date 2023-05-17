set cookiejar=%temp%\cookies_%random%.txt
set netrc=%temp%\netrc_%random%.txt




set /p username="Username: "
set /p password="Password: "

echo machine urs.earthdata.nasa.gov login "%username%" password "%password%" >> %netrc%

echo Connect Earthdata ...

set filename=%1
set land=%2

for /f "delims=" %%a in (%filename%) do (
    
    curl --ssl-no-revoke -f -b %cookiejar% -c %cookiejar% -L --netrc-file %netrc% -g -o dem/dem_%land%/%%~nxa -- %%a
    

)


7z x dem/dem_%land%/*.zip 

move *.hgt dem/dem_%land%


echo Removing files...
del %cookiejar% %netrc%
del dem\dem_%land%\*.zip 


