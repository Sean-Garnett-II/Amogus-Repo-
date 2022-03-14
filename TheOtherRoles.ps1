New-Item -Path .\"Previous Versions" -ItemType Directory -Force
New-Item -Path .\"Previous Versions\The Other Roles" -ItemType Directory -Force
Get-ChildItem -Path .\ -Filter "*The Other Roles*" | Select-Object -ExpandProperty Name | Move-Item -Destination .\"Previous Versions\The Other Roles"
cmd.exe /c curl https://api.github.com/repos/Eisbison/TheOtherRoles/releases/latest >TheOtherRoles.txt
$downloadUrl = Select-String -Path TheOtherRoles.txt -Pattern 'browser_download_url'
$downloadUrl = [regex]::Matches($downloadUrl, 'https:[\/\w\.\d-]+zip').Value
$folderName = Select-String -Path TheOtherRoles.txt -Pattern '"name"[ ]?:[ ]?"The Other Roles '
$folderName = [regex]::Matches($folderName, 'The Other Roles [\w\d.]+').Value
if(Test-Path -Path $folderName){
    Remove-Item $folderName -Recurse
}
New-Item -Path $folderName -ItemType Directory -Force
cmd.exe /c curl -Lo TheOtherRoles.zip $downloadUrl
Expand-archive .\TheOtherRoles.zip -destinationpath $folderName
del TheOtherRoles.txt
del TheOtherRoles.zip
if(Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 945360'){
    $installPath = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 945360' | select-object -ExpandProperty InstallLocation
    if (Test-Path -Path $installPath) {
        robocopy $installPath $folderName /e 
        start $folderName
    }
} elseif (Test-Path -Path .\"Among Us"){
    robocopy .\"Among Us" $folderName /e /move
    start $folderName
} else {
    echo "Copy your Among Us instillation folder into this folder as 'Among Us' and re-run this script"
    pause
}