
#####################################################################################################################################################

                                        # JEA  #

#####################################################################################################################################################
New-Item -Path c:\test -ItemType Directory
New-PSRoleCapabilityFile -Path C:\test\capability.psrc
New-PSSessionConfigurationFile -Path C:\test\session.pssc

ise C:\test\capability.psrc
ise C:\test\session.pssc

Remove-Item C:\test\*


New-PSRoleCapabilityFile -Path C:\test\capability.psrc -Author 'Contoso Admin' -CompanyName 'Contoso' -VisibleCmdlets Restart-Service

ise C:\test\capability.psrc



## Splatting ##

Get-Service -Name bits -ComputerName localhost

$service = @{

            Computername = 'localhost'
            Name= 'Bits'
}

Get-Service @service


# Jea Helper tool

https://gallery.technet.microsoft.com/JEA-Helper-Tool-20-6f9c49dd


## Demo

New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\JEAprintoperators' -ItemType directory

New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\JEAprintoperators\Rolecapabilities' -ItemType directory

New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\JEAprintoperators\printoperators.psd1'


$roleparams = @{

path = 'C:\Program Files\WindowsPowerShell\Modules\JEAprintoperators\Rolecapabilities\Printoperator.psrc'
Author = 'Nutshell Admin'
CompanyName = 'Nutshell'
Visiblecmdlets = 'Restart-service'
FunctionDefinitions = @{Name = 'Get-userinfo' ; scriptblock ={whoami.exe}}

}

New-PSRoleCapabilityFile @roleparams


#Session configuration file

Test-Path -Path C:\ProgramData\JEAConfiguration

<#optional

If ((Test-Path -Path 'C:\ProgramData\JEAConfiguration') -eq $false){


Write-Output "Creating Directory"

New-Item -Path C:\ProgramData\JEAConfiguration -ItemType directory 

}
#>

New-Item -Path C:\ProgramData\JEAConfiguration -ItemType Directory

Get-PSSessionConfiguration -name Printoperator

#EndPoint

$jeaconfig = @{

sessiontype = 'Restrictedremoteserver'
Runasvirtualaccount = $true
Roledefinitions = @{'nutshell\Jea_printoperator' =@{Rolecapabilities = 'Printoperator'}}

}

New-PSSessionConfigurationFile -Path C:\ProgramData\JEAConfiguration\JEaprintoperators.pssc @jeaconfig

Register-PSSessionConfiguration -Name printoperators -Path C:\ProgramData\JEAConfiguration\JEaprintoperators.pssc

Restart-Service spooler
Restart-Service Bits
restart-computer dns


# VisibleCmdlets = @{'Name' = 'Restart-Service';'Parameters' = @{ 'Name' = 'Name' ; 'ValidateSet' = 'Spooler', 'AppIdSvc' },@{ 'Name' = 'Force' }}

Function get-log {Get-eventlog -logname security}


https://github.com/PSSecTools/JEAnalyzer

Install-Module JEAnalyzer



##########################################################################################################################

                                                #Scope


###########################################################################################################################


# Open console and Ise side by side to compare

$x = 100 # Global scope


#in ISE -> save to .ps1

Write-Host "X is $X"

$x = 200

Write-Host " In the script, X is $x"

Function scope{

Write-Host " In the Function the value of X is $x"

$x = 300

Write-Host "now x is $x in the function"

}

Scope

Write-Host " At this point in the script x is $x"




#look at $x in global scope, that did not changed.


#Change the x to z

# variable are the most common type of scoped elements and functions as well


#in ISE -> save to .ps1

Write-Host "X is $X"

Set-Variable -name X -Scope global -value 500

$global:x = 500 ( same as previous)  # Try after the first one

$x = 200

#$x = 200

Write-Host " In the script, X is $x"

Function scope{

Write-Host " In the Function the value of X is $x"

$x = 300

Write-Host "now x is $x in the function"

}

Scope

Write-Host " At this point in the script x is $x"


#scoped elements

#Variables
#functions
#aliases
#ps drives

#Exmaple 2

New-Alias -name d -value Get-ChildItem

New-Alias -name d -value Get-ChildItem -scope global

