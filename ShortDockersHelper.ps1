<#
#BASED IN https://github.com/Microsoft/navcontainerhelper/blob/master/NavContainerHelper.md INFO 
# !!! TAKE CARE OF !!! -> 
        1. RUN DOCKERS AS ASDMINISTRATOR
        2. SWITCH DOCKERS TO WINDOWS CONTAINER 
#>
#1. Install
install-module navcontainerhelper -force

#2. Import module
Import-Module navcontainerhelper 

#3. If some problem appears with permissions - Set Execution Policy
Set-ExecutionPolicy RemoteSigned -Force


#docker login "bcinsider.azurecr.io" -u "carlos.perez@bitec.es" -pass "randomPassword" #Only for subscribers

<#Setup Docker Container.
   Change Values for $imageName, $ContainerName, username, Password, $LicenseFile & Memory Limit as per your requirment.
   For Check versions : https://hub.docker.com/_/microsoft-businesscentral-onprem
   For check versions : https://hub.docker.com/_/microsoft-businesscentral-sandbox 
#>
$imageName = "mcr.microsoft.com/businesscentral/onprem:es"   
$containerName = "BC365162"
$auth = "UserPassword"
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'Bitec.123' -AsPlainText -Force)
$licenseFile = "C:\Bitec\Bitec.flf"

New-BCContainer -accept_eula `
                -imageName $imageName `
                -containerName $containerName `
                -auth $auth `
                -credential $credential `
                -licenseFile $licenseFile `
                -updateHosts `
                -includeAL `
                -memoryLimit 2G


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
#-additionalParameters $additionalParameters
$additionalParameters = @("--publish 8080:8080",
                          "--publish 443:443", 
                          "--publish 7046-7049:7046-7049")

$aditionalParameters = @('--env bakfile="c:\run\my\Demo Database NAV (11-0).bak"')

