$gitApiUrl = "https://api.github.com/repos/Eisbison/TheOtherRoles/releases/latest"
$modNameFolders = "The Other Roles"
$modNameFiles = $modNameFolders
$modNameFiles = $modNameFiles -replace '\s', ''

# Clean up old temp files
if(Test-Path -Path .\$modNameFiles.*) {Remove-Item -Path .\$modNameFiles.*}

New-Item -Path .\"Previous Versions" -ItemType Directory -Force
New-Item -Path .\"Previous Versions\$modNameFolders" -ItemType Directory -Force

$archiveName = ".\Previous Versions\$modNameFolders"
Get-ChildItem -Path .\ -Filter "*$modNameFolders*" | ForEach-Object {
    $num=1
    $nextName = Join-Path -Path $archiveName -ChildPath $PSItem.name
    while(Test-Path -Path $nextName)
    {
       $nextName = Join-Path $archiveName ($PSItem.BaseName + " ($num)")    
       $num+=1   
    }
    $PSItem | Move-Item -Destination $nextName
}

cmd.exe /c curl $gitApiUrl >"$modNameFiles.json"
$jsonData = Get-Content "$modNameFiles.json" | ConvertFrom-Json
#if(!($?)){ echo "Failed getting Mod info"; pause; exit }
if (!$jsonData) { echo "Failed getting Mod info"; pause; exit }

# getting download url and folderName using ConvertFrom-Json
foreach ($content in $jsonData.assets) { 

    $name = $content.name

    if($name -match '[\w.]+zip'){

        if(!$shortestName){ $shortestName = $name }
        if(!$downloadUrl){ $downloadUrl = $content.browser_download_url }

        if($name -lt $shortestName){ 
        $shortestName = $name
        $downloadUrl = $content.browser_download_url
         }
    }
}
if(!($downloadUrl)){ echo "Failed getting download link"; pause; exit }

$folderName = $shortestName
if(!($folderName)){ $folderName = "The Other Roles unknown version" }
New-Item -Path $folderName -ItemType Directory -Force

cmd.exe /c curl -Lo "$modNameFiles.zip" $downloadUrl
#if(!($?)){ echo "Failed Downloading Mod zip file"; pause; exit }
if ((Get-Content "$modNameFiles.zip") -eq $Null) { echo "Failed Downloading Mod zip file"; pause; exit }

Expand-Archive -Path .\"$modNameFiles.zip" -DestinationPath $folderName -Force
# if the unziped folder has 1 folder it will move the contents of that folder into .\
$count = ( Get-ChildItem .\$folderName | Measure-Object ).Count
if ($count -eq 1){
    cd $folderName
    $cdFolder = (Get-childitem -path .\ | select-object -expandProperty Name)
    robocopy .\$cdFolder .\ /e /move
    cd..
}

# Clean up Temp Files
if(Test-Path -Path .\$modNameFiles.*) { Remove-Item -Path .\$modNameFiles.* }

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