# Modded Amongus Installer Repo
The purpose of this repository is to automate the process of installing common Among Us mod packs for the Steam Version of Among Us.  
Currently The Epic Games Store version of Among Us is unsupported.

## Instructions
|||
|--|--|
|1. Download the the Zip containing the Install Scripts |[https://api.github.com/repos/Sean-Garnett-II/Amogus-Repo-/zipball/AmongUsModInstallerV1.0](https://api.github.com/repos/Sean-Garnett-II/Amogus-Repo-/zipball/AmongUsModInstallerV1.0)|
|2. Unzip the Files  |![](https://imgur.com/jkKhi23.jpeg)|
|3. Right click on the PowerShell script and click "Run with PowerShell"|![](https://imgur.com/XBchkxS.jpeg)|
|4. A security dialog box may appear simply click "Ok"|![](https://imgur.com/YpXWXed.jpeg)|
|5. Once the PowerShell script runs it will open an Explorer window with the ||
|6. Double click "Among Us.exe" to start your modded version of Among Us|![](https://imgur.com/sfazzbJ.jpeg)|

### Details behind the Scripts
Reason for `cmd.exe /c -Lo "filename" "url"` instead of using powershell's curl

> Apparently curl in powershell uses  [Invoke-WebRequest](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-6)  under the hood. This might cause some confusing as some parameters might not work as expected. 
 
>To use the ‘Real’ curl without Invoke-WebRequest under the hood you can open a cmd prompt. calling curl from there will result in normal behavior
