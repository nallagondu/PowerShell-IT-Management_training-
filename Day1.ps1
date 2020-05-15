<##################################################################################################
                                         #Remoting

###################################################################################################> 


Get-Command | Where-Object -FilterScript {$_.Parameters.Keys -contains 'ComputerName' -and $_.Parameters.Keys -notcontains 'Session’} 


Get-WmiObject -ComputerName localhost -Class win32_operatingsystem | fl *

Get-CimClass -ComputerName localhost -ClassName win32_operatingsystem

Invoke-Command -ComputerName localhost -ScriptBlock { Get-process}

###

Enable-PSRemoting -WhatIf

Disable-PSRemoting -WhatIf

Get-Service -Name WinRM | Select-Object -Property Name, DisplayName, Status, StartType                                                      

Get-NetFirewallRule -Name "WINRM-HTTP-In-TCP*" | Select-Object -Property Name, Enabled, Profile, Description

# Interactive Remoting#


Enter-PSSession -ComputerName adfs01

Enter-PSSession -ComputerName adfs01 -Credential ( nutshell\Arjun)


# Using Invoke Command #

Invoke-Command -ComputerName member1.lab.pri,member2.lab.pri -ScriptBlock {Get-service -name bits}

#credential Parameter
Invoke-Command -Credential lab.pri\Administrator -ComputerName member1.lab.pri,member2.lab.pri -ScriptBlock {Get-service -name bits}



######################################################################################################################

            # OBJECT SERIALIZATION #

######################################################################################################################



Invoke-Command -ComputerName localhost -ScriptBlock {get-service -name bits}
(Invoke-Command -ComputerName localhost -ScriptBlock {Get-Service -name bits}).stop()

#withoutInvoke


(Get-service -name bits).stop()


######################################### LAB #######################################################################

#####################################################################################################################

#  Object Models

#####################################################################################################################

Get-Service | Get-Member

Get-ChildItem C: | where {$_.PsIsContainer -eq $False} |Format-List

Get-ChildItem | gm
Get-ChildItem C: | where {$_.PsIsContainer -eq $False}| gm

Get-ChildItem C: | where {$_.PsIsContainer -eq $False} |Format-List| gm


Get-TypeData -TypeName *CIM*
Get-TypeData -TypeName *Win32*


Add-type # to add new types
Get-Help Add-Type -Full


## Custom Objects

$myHashtable = @{
    Name     = $env:USERNAME
    Language = 'Powershell'
    version  = $PSVersionTable.PSVersion.Major
} 

$myObject = New-Object -TypeName PSObject -Property $myHashtable

[pscustomobject]@{name=$env:USERNAME; language='PowerShell'; version=$PSVersionTable.PSVersion.Major} 


# Example 2


$os = Get-WmiObject win32_operatingsystem
$bios = Get-WmiObject win32_bios

$prop = @{

    'Buildnumber' = $os.BuildNumber
    'Version' = $os.Version
    'Organization' = $os.Organization
    'Manufacturer' = $bios.Manufacturer
    'Serialnumber' = $bios.SerialNumber

}

$Obj = New-Object -TypeName psobject -Property $prop



#####################################################################################################

#  COM Objects

# COM is basically a set of rules that enable developers to write software components that can easily interoperate.
#  COM is still in wide use today, although it’s considered an older cousin to the .NET Framework.

#Examples include Active Directory Service Interfaces (ADSI) for working with Active Directory, WMI, 
#and the object models that enable you to script against Internet Explorer or the Office products such as Word and Excel.
# .NET Framework originally shipped with—and still contains—the ability to load and use those pieces of software that comply with the COM specification. 
# 
# PowerShell, through interop, is able to take advantage of many pieces of COM-based software.


# COM software is generally packaged into a dynamic link library (DLL) and is usually written in C++

#####################################################################################################

$Allcom =  Get-ChildItem -path HKLM:\Software\Classes | Where-Object -FilterScript `
{
    $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path –Path `
    "$($_.PSPath)\CLSID")
}

$Allcom.Count

###

$wscript = new-object -ComObject wscript.shell
$wscript | get-member
$wscript.run("Excel")

$wscript.popup("Hello From Windows PowerShell and COM") 


$ie = New-Object -com internetexplorer.application 
$ie.visible = $true
$ie.navigate('www.bing.com')
####


$winshell = new-object -ComObject Shell.Application

$winshell | get-member


$winshell.minimizeAll()


##


get-process winword
$Word = New-Object -ComObject Word.Application

get-process winword	

$Word.Visible = $True

$Document = $Word.Documents.Add()


$Selection = $Word.Selection
$Selection.TypeText("My username is $($Env:USERNAME) and the date is $(Get-Date)")
$Selection.TypeParagraph()
$Selection.Font.Bold = 1
$Selection.TypeText("This is on a new line and bold!")


$Report = "C:\temp\MyFirstDocument.docx" 
$Document.SaveAs([ref]$Report,[ref]$SaveFormat::wdFormatDocument)
$word.Quit() 

$word

$Word2 = New-Object -ComObject Word.Application -strict


#######################################################################################################################################################

# CIM Introduction.

#######################################################################################################################################################

Get-Command -Noun *wmi*

Get-Command -Noun *cim*

# To get cim classses

Get-WmiObject -List 

Get-CimClass

Get-WmiObject –Class Win32_Process

Get-CimInstance –Class Win32_Process 

Get-WmiObject –Class Win32_Logicaldisk –Filter "drivetype=3" –Property name,freespace,size 

Get-CimInstance –Class Win32_Logicaldisk –Filter 'drivetype=3' –Property name,freespace,size

[wmi]”root\cimv2:Win32_Service.Name='spooler'” 

([wmiclass]”Win32_Process”).Create(“Notepad.exe”) 


Get-WmiObject -Class Win32_OperatingSystem | Select LastBootupTime

Get-CimInstance -Class Win32_OperatingSystem | Select LastBootupTime


###########################################################################################################################################################


# Advanced Remoting

###########################################################################################################################################################
Invoke-Command -ComputerName member1.lab.pri -ScriptBlock {Get-service -name B*}
Invoke-Command -ComputerName member1.lab.pri -ScriptBlock {$var = 123}
Invoke-Command -ComputerName member1.lab.pri -ScriptBlock {$var}


# Persistent

$session = New-PSSession -ComputerName Member1.lab.pri
Invoke-Command -Session $session -ScriptBlock {$var = 123}
Invoke-Command -Session $session -ScriptBlock {$var}


## Disconnected Sessions

Get-PSSession

$ses = New-PSSession -ComputerName Member2.lab.pri

Get-PSSession

Enter-PSSession -Session $ses

$var = " Hello There"

Exit

Disconnect-PSSession -Session $ses

Get-PSSession

Connect-PSSession -Session $ses

Enter-PSSession -Session $ses

$var

Invoke-Command -ScriptBlock{$var = " Hello there, this is  in disconnected command" } -ComputerName member2.lab.pri -InDisconnectedSession

Enter-PSSession -ID ""

$var 


## Implicit Remoting 

$session = New-PSSession -ComputerName Dc.lab.pri

Import-PSSession -Session $session -Module Activedirectory -Prefix DC

Get-DCaduser

Import-Module -PSSession $session Netadapter -Prefix DC #new from V3

Get-NetAdapter

Get-DCNetadapter 


Get-NetAdapter | GM

Get-DCNetadapter | GM

########
#Security
########
CD Wsman:
cd localhost\Client\Auth\
CD localhost\Client\Defaultports

# Trusted host
CD localhost\Client\
Set-item .\TrustedHosts -Value 'Hello'

###
#SSL Endpoints
###

Get-PSSessionConfiguration


##
#Working with credentials

$Cred = Read-Host  " Enter the username"

$username = 'Hello'
$password = "Mypasskey"

$cred = New-Object -TypeName pscredential -ArgumentList $username, $password


$cred = Get-Credential

$cred = Read-host -Prompt Password -AsSecureString 



































