if(Test-Path -Path .\TheOtherRoles.*) {Remove-Item -Path .\TheOtherRoles.*}

New-Item -Path .\"Previous Versions" -ItemType Directory -Force
New-Item -Path .\"Previous Versions\The Other Roles" -ItemType Directory -Force

$dest = ".\Previous Versions\The Other Roles"
Get-ChildItem -Path .\ -Filter "*The Other Roles*" | ForEach-Object {
    $num=1
    $nextName = Join-Path -Path $dest -ChildPath $PSItem.name
    while(Test-Path -Path $nextName)
    {
       $nextName = Join-Path $dest ($PSItem.BaseName + " ($num)")    
       $num+=1   
    }
    $PSItem | Move-Item -Destination $nextName
}

cmd.exe /c curl https://api.github.com/repos/Eisbison/TheOtherRoles/releases/latest >TheOtherRoles.json
#if(!($?)){ echo "Failed getting Mod info"; pause; exit }
if ((Get-Content TheOtherRoles.json) -eq $Null) { echo "Failed getting Mod info"; pause; exit }

# $downloadUrl = Get-Content TheOtherRoles.json | ConvertFrom-Json | Select-Object -ExpandProperty assets | Select-Object -ExpandProperty browser_download_url
# unfortunately returns 2 urls and deciding which one is just as complicated as the implementation below. 
$downloadUrl = Select-String -Path TheOtherRoles.json -Pattern 'browser_download_url'
$downloadUrl = [regex]::Matches($downloadUrl, 'https:[\/\w\.\d-]+zip').Value
if(!($downloadUrl)){ echo "Failed getting download link"; pause; exit }

$folderName = Select-String -Path TheOtherRoles.json -Pattern '"name"[ ]?:[ ]?"The Other Roles '
$folderName = [regex]::Matches($folderName, 'The Other Roles [\w\d.]+').Value
if(!($folderName)){ $folderName = "The Other Roles unknown version" }
New-Item -Path $folderName -ItemType Directory -Force

cmd.exe /c curl -Lo TheOtherRoles.zip $downloadUrl
#if(!($?)){ echo "Failed Downloading Mod zip file"; pause; exit }
if ((Get-Content TheOtherRoles.zip) -eq $Null) { echo "Failed Downloading Mod zip file"; pause; exit }

Expand-archive .\TheOtherRoles.zip -destinationpath $folderName -Force
#if(!($?)){ echo "Failed unzipping Mod file"; pause; exit }
#if (!(Test-Path -Path .\TheOtherRoles\*)) { echo "Failed unzipping Mod file"; pause; exit }

if(Test-Path -Path .\TheOtherRoles.*) { Remove-Item -Path .\TheOtherRoles.* }

if(Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 945360'){
    $installPath = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 945360' | select-object -ExpandProperty InstallLocation
    if (Test-Path -Path $installPath) {
        robocopy $installPath $folderName /e 
        start $folderName
    } else {
        echo "Failed copying from Steam Install location. Looking for 'Among Us' in this directory"
        Start-Sleep 10
        }
} elseif (Test-Path -Path .\"Among Us"){
    robocopy .\"Among Us" $folderName /e /move
    start $folderName
} else {
    echo "Copy your Among Us instillation folder into this folder as 'Among Us' and re-run this script"
    pause
}
exit