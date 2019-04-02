FOR /f "delims=" %%i IN ('DIR *.xml /b') DO xml2xlsx.vbs "%%i" "%%~ni.xlsx"
