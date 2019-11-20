#Requires -RunAsAdministrator

# Resources:
# https://github.com/StevenBlack/hosts
# https://stackoverflow.com/questions/16906170/create-directory-if-it-does-not-exist
# https://superuser.com/questions/749243/detect-if-powershell-is-running-as-administrator
# https://stackoverflow.com/questions/51225598/downloading-a-file-with-powershell


clear
Write-Host  $PsVersionTable.PSVersion 
[Environment]::NewLine
Write-Host "Welcome to Powershell HostBlocker Script. You need to run this script as administrator."
[Environment]::NewLine
Write-Host "This Powershell script is going to download host file from  https://github.com/StevenBlack/hosts ((adware + malware) category and change your current hosts file."
[Environment]::NewLine
Write-Host "You can find your hosts file's backup as hosts.backup name in WINDIR\system32\Drivers\etc\hosts "
[Environment]::NewLine
Write-Host 'If you want to agree with changing your hosts file, please press "Enter" button to start'
[Environment]::NewLine

read-host Press ENTER to continue...

Write-Host "Creating a new folder if it is necessary..." -ForegroundColor red -BackgroundColor white

$path = "C:\hostBlockerTxtDir"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}


Write-Host "Clearing the folder if it is not empty..." -ForegroundColor red -BackgroundColor white
Remove-Item –path C:\hostBlockerTxtDir* -Filter *test* -whatif


$HTTP_Request = [System.Net.WebRequest]::Create('https://github.com/StevenBlack/hosts')
$HTTP_Response = $HTTP_Request.GetResponse()
$HTTP_Status = [int]$HTTP_Response.StatusCode

If ($HTTP_Status -eq 200) {
   Write-Host "Downloading txt files for host blocking (adware + malware) categories... (https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts)" -ForegroundColor red -BackgroundColor white
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile("https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts","C:\hostBlockerTxtDir\hosts.txt")
}
Else {
    Write-Host "The Site may be down, please check!"  -ErrorAction Stop  -ForegroundColor red -BackgroundColor white
   
}
$HTTP_Response.Close()

Get-FileHash C:\hostBlockerTxtDir\hosts.txt -Algorithm SHA1 | Format-List

Write-Host "Download has finished. Hosts file is changing..." -ForegroundColor red -BackgroundColor white

 
Copy-Item -Path $env:windir\system32\Drivers\etc\hosts -Destination $env:windir\system32\Drivers\etc\hosts.backup
Write-Host "Hosts file's backup is completed."   -ForegroundColor red -BackgroundColor white
Copy-Item -Path C:\hostBlockerTxtDir\hosts.txt -Destination $env:windir\system32\Drivers\etc\hosts
Write-Host "Hosts file is changed." -ForegroundColor red -BackgroundColor white
sleep 2


Write-Host "Running ipconfig /flushdns and nbtstat -R commands."   -ForegroundColor red -BackgroundColor white
ipconfig /flushdns
sleep 1
nbtstat -R
sleep 1
Write-Host "Configuration is done."   -ForegroundColor red -BackgroundColor white
sleep 1






 




