# Modded Amongus Installer Repo
The purpose of this repo is to automate the process of installing common Among Us mod packs. 
Details to be filled in later.
### Details behind the Scripts. 
Reason for `cmd.exe /c -Lo "filename" "url"` instead of using powershell's curl

> Apparently curl in powershell uses  [Invoke-WebRequest](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-6)  under the hood. This might cause some confusing as some parameters might not work as expected. 
 
>To use the ‘Real’ curl without Invoke-WebRequest under the hood you can open a cmd prompt. calling curl from there will result in normal behavior
