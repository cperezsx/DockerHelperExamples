#BASED IN https://github.com/Microsoft/navcontainerhelper/blob/master/NavContainerHelper.md INFO 

install-module navcontainerhelper -force

#Set Execution Policy
Set-ExecutionPolicy RemoteSigned -Force

# Install Nav Container Helper Module
Install-Module -Name navcontainerhelper

docker login "bcinsider.azurecr.io" -u "carlos.perez@bitec.es" -pass "randomPassword"

#Setup Docker Container.
#Change Values for $imageName, $ContainerName, username, Password, $LicenseFile & Memory Limit as per your requirment.
#For Check versions : https://hub.docker.com/_/microsoft-businesscentral-onprem
#For check versions : 
$imageName = "mcr.microsoft.com/businesscentral/onprem:es"   #
$containerName = "BC3652020Wave1"
$auth = "UserPassword"
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'R@nd0m.Pw.33!' -AsPlainText -Force)
$licenseFile = "C:\Temp\licenseExample.flf"

New-BCContainer -accept_eula `
                -imageName $imageName `
                -containerName $containerName `
                -auth $auth `
                -credential $credential `
                -licenseFile $licenseFile `
                -updateHosts `
                -includeAL `
                -memoryLimit 3G
                #-additionalParameters @('--env bakfile="c:\run\my\Demo Database NAV (11-0).bak"')

#Remove containers
$containers = docker ps -a --filter "name=c*" --format "table {{.Names}}"

foreach ($container in $containers) {
    Write-Host 'Removing ' $container
    try {
      Remove-NavContainer -containerName $container
    }
    catch {
      Write-Host 'Could not remove ' $container -f Red
    }
}
                
#Publish Ports

$additionalParameters = @("--publish 8080:8080",
                          "--publish 443:443", 
                          "--publish 7046-7049:7046-7049")