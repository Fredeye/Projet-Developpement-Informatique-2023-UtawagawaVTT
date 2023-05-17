set /p method="method: "
set /p continent="continent: "
set /p country="country: "
set /p region="region: "
set /p type="type: "

if %country%==all (
  
  for /f "delims=" %%a in (geofabrik\%continent%.txt) do (
      
      python scripts/listing_hgt.py %continent%_%%a http://download.geofabrik.de/%continent%/%%a.poly
      
      call scripts/download_hgt.bat dem\dem_%continent%_%%a\hgt_urls.txt %continent%_%%a
      
      if %method%==create (
        call scripts/create_map2.bat http://download.geofabrik.de/%continent%/%%a %type% %continent%_%%a
      )
      
      if %method%==update (
        call scripts/update.bat http://download.geofabrik.de/%continent%/%%a %type% %continent%_%%a
      )
  )
) else (
  if %region%==all (
    set url=http://download.geofabrik.de/%continent%/%country%
  ) else (
    set url=http://download.geofabrik.de/%continent%/%country%/%region%
  )

  set land=%country%_%region%

  python scripts/listing_hgt.py %land% %url%.poly

  call scripts/download_hgt.bat dem\dem_%land%\hgt_urls.txt %land%

  if %method%==create (
    call scripts/create_map2.bat %url% %type% %land%
  )

  if %method%==update (
    call scripts/update.bat %url% %type% %land%
  )
)