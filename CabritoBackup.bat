@echo off

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)

For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
for /f "tokens=1-4 delims=/ " %%i in ("%date%") do (
     set day=%%i
     set month=%%j
     set year=%%k
     set dow=%%l
)

set mydate=%month%_%day%_%year%

rem carpeta donde alojar el backup
set localdirectory=

rem carpeta con los logs de la copia
set directorylogs=logs\

rem nombre del backup
set backupname=%mydate%_%mytime%_BIN

rem directorio temporal donde alojar los archivos antes de comprimirlos
set tempdirectory=temp\

rem los backups mas viejos de los dias definidos, los borra
set /A backupdays=5

rem directorio a copiar
set externaldirectory=


@echo. 
@echo. 
call :colorEcho 0c    "##############################################################################"  
@echo. 
@echo. 
call :colorEcho 0F "Iniciando proceso de backup, aguarde a que finalicen los siguientes pasos..."
@echo. 
@echo. 
call :colorEcho 0c    "##############################################################################"  
@echo.
@echo. 
call :colorEcho 0F "Copiando archivos, esta operacion puede tardar unos minutos, por favor espere"
@echo. 
robocopy %externaldirectory% %localdirectory%%tempdirectory%%backupname% /e > %localdirectory%%directorylogs%%backupname%.txt
@echo. 
call :colorEcho 0F "Finalizado"
@echo. 
@echo. 
call :colorEcho 0c    "##############################################################################"  
@echo. 
C:
cd..
cd..
cd Program Files\7-Zip
@echo. 
call :colorEcho 0F "Comprimiendo archivos"
@echo. 
7z a -t7z %localdirectory%%backupname%.7z %localdirectory%%tempdirectory%%backupname%
@echo. 
call :colorEcho 0F "Finalizado"
@echo. 
@echo. 
call :colorEcho 0c    "##############################################################################"  
@echo. 
@echo. 
call :colorEcho 0F "Eliminando temporales"
@echo. 
@echo. 
echo Se mantienen logs y backups de los ultimos %backupdays% dias.
@echo. 
@echo. 
rmdir /s /q  %localdirectory%%tempdirectory%%backupname%
forfiles /p %localdirectory%%directorylogs% /s /m *.txt /d -%backupdays% /c "cmd /c del @PATH" 
forfiles /p %localdirectory% /s /m *.7z /d -%backupdays% /c "cmd /c del @PATH" 
@echo. 
@echo. 
call :colorEcho 0F "Finalizado"
@echo. 
@echo. 
call :colorEcho 0c    "##############################################################################"  
@echo. 
@echo. 
call :colorEcho 0F "Tarea terminada"
@echo. 
@echo. 
pause
exit
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2" findstr /v /a:%1 /R "^$" "%~2" nul del "%~2" > nul 2>&1i
