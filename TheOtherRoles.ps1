cmd.exe /c curl https://api.github.com/repos/Eisbison/TheOtherRoles/releases/latest | findstr "browser_download_url" >tmp
$targetFolder = ".\The Other Roles"
mkdir $targetFolder
$url = get-content tmp
$url = [regex]::Matches($url, 'https:[\/\w\.\d-]+zip').Value
cmd.exe /c curl -Lo temp.zip $url
Expand-archive .\temp.zip -destinationpath $targetFolder
$installPath = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 945360' | select-object -ExpandProperty InstallLocation
if (Test-Path -Path .\"Among Us"){
    xcopy /i /s /c .\"Among Us" $targetFolder
    start $targetFolder
} elseif (Test-Path -Path $installPath) {
    xcopy /i /s /c $installPath $targetFolder
    start $targetFolder
} else {
    echo "Copy your Among Us instillation folder into this folder as 'Among Us'"
    pause
}
del temp.zip
del tmp