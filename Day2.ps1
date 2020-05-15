#####################################################################################################################################################################

# Regular Expressions

<# Capture a series

$file = Get-Content C:\temp\numbers.txt
$regex = "1-\d{3}-\d{3}-\d{4}"
$match = @()
foreach ($line in $file)
{
    if($line -match $regex)
    {
      $match +=  $matches[0]
    
    }

    
}  

$match

#>


#####################################################################################################################################################################
# Getting Started

'admin@contoso.com' -match 'admin'

$Matches

'admin@contoso.com' -match 'a...n'
$Matches

'admin@contoso.com' -split '\.'

'Workshop' -match '\w'
'Workshop' -match '\w+'

'asdf123' -match '\d'
'asdf123' -match '\d+'

'Hello World' -match '\s'

'asdf123' -match '\d{3}'
'asdf123' -match '\w{3}'
'asdf123' -match '\w{1,2}'
'asdf123' -match '\w{3,}'

########################################################


$Signature = @"
Janine Mitchell
Property Manager | West Region
Janine.Mitchell@ContosoSuites.com
"@ 


$Signature -match "\w+\.\w+@\w+\.com"

$Signature -match "(\w+)\.(\w+)(@\w+)\.com" # Capture per group

$Signature -match "(?'firstname'\w+)\.(\w+)(@\w+)\.com"

$Signature -match "(?'firstname'\w+)\.(?'lastname'\w+)(@\w+)\.com"

$Signature -match "(?'email'(?'firstname'\w+)\.(?'lastname'\w+)(@\w+)\.com)"

"contoso\administrator" –match "(\w+)\\(\w+)"




#Postcode example

$postcode = "AK12 567"

$postcode -match "^[a-z]{1,2}[0-9]{1,2}\s[0-9]{1,3}" 

# Phone Example

$phone = '+1 543 234 8096'

$phone -match "^\+[0-9]\s[0-9][0-9][0-9]\s[0-9]{1,3}\s[0-9]{1,4}"

#Email

$Email = 'somebody.someone@company.com'
$email -match "\w+\.\w+\@company.com"
$email -match "(\w+)\.\w+\@company.com" # Capture
$email -match "(?'name'\w+)\.\w+\@company.com" #named capture

“Contoso.com" –match "\.(com|net)"
“Consoto.net" –match "\.(com|net)"

$test = '^H\w+'

$endtest = '\wlo$'

'hello' -cmatch $test

## Replace example 

$str = "Henry Hunt"
$str -replace "(\w+)\s(\w+)",'$2,$1’


## Advanced Regex
$Data = "1a2b3cd”
$Pattern = '\d’
[regex]::match($Data,$Pattern).value
[regex]::matches($Data,$Pattern).value

"??ε?α" -match "\p{IsGreek}" 
"φ????ε??α" -match "\p{IsGreek}"
"Привет." -match "\p{IsCyrillic}"  # Russian words
"1sivaji" -match "\p{Ll}+"

#Modifiers


"Hello" -cmatch "(?i)hello"

"Hello There" -cmatch "Hello(?i)there"

# (?m) mulit line example


#1

$string = @"
hello `nthere `nhow `nareyou
"@          

[regex]::matches($string, '^(\w)', 'MultiLine').value
[regex]::matches($string, '^[a-z]{3}', 'MultiLine').value

#2

$test = @"
here is a little text.
i want to attach this text to an e-mail quote.
that's why i would put a ">" before every line.
"@ 

$test -replace "^","> "
$test -replace "(?m)^","> "

"This is one line and + `n + this is the second." -match ".+line.+"

"This is one line and + `n + this is the second." -match "(?s).+line.+"



###############
# Select-String
###############

$Data = "1a2b3c4d5e"
$Pattern = ‘\d’

Get-EventLog -LogName System | Select-String -InputObject {$_.message} -Pattern "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | Select-Object -First 5



(select-string -InputObject $Data -Pattern $Pattern -AllMatches).Matches.Value

Get-ChildItem -Path C:\temp\logs\ | Select-String -Pattern "(\d{1,3})"
Get-ChildItem -Path C:\temp\logs\ | Select-String -Pattern "149.172.138.41"

"Mallik Reddy" -replace "([a-z]+)\s([a-z]+)" , '$2 $1'

"Mallik Reddy" -replace "([a-z]+)\s([a-z]+)" , '$2, $1'



$str = "Mr. Henry Hunt, Mrs. Sara Samuels, Ms. Nicole Norris“
$str -match "(Mr|Mrs|Ms)\. (\w*)\s(\w*)(, )" 
$str -replace "(Mr|Mrs|Ms)\. (\w*)\s(\w*)(, )?","`$3, `$2`n"


Select-String -Pattern "(Mr|Mrs|Ms)\. (\w*)\s(\w*)(, )" -InputObject $str -AllMatches

#######################################################################################################################################

# JOBS

#######################################################################################################################################

Get-Command -Noun job

Start-Job -ScriptBlock {Get-process}

Get-Job

Start-Job -ScriptBlock {Get-service ; Get-EventLog -LogName security -Newest 10 } # don't run as administrator for testing

Get-Job

Start-Job -FilePath 'C:\temp\Services.ps1' -Name scriptjob

Get-Job -id # -IncludeChildJob (PowerShell V3 & Above)

Get-Job -Id # | Select-object -expandproperty childjobs


Get-Job -id #number  | format-list *

$job = Get-Job 
$job[0]
$job[1].Output

Start-Job -ScriptBlock{get-service ; get-process} | Wait-Job 

Suspend-Job -id # Suspend job only works for workflow jobs.

Receive-Job -id # | Get-Member



# Workflow 


Workflow WFProcess {Get-Process}

WFProcess -AsJob -JobName WFProcessJob -PSPrivateMetadata @{MyCustomId = 92107}
Get-Job -Filter @{MyCustomId = 92107}

###

Invoke-Command -ScriptBlock{Get-Process} -ComputerName DC -AsJob

$ses = New-PSSession -ComputerName dc

Invoke-Command -Session $ses -ScriptBlock{Get-Process} -AsJob




####
# Scheduled Jobs #
####

# C:\Users\emreg\AppData\Local\Microsoft\Windows\PowerShell\ScheduledJobs\myTestJob5\Output



$trigger = New-JobTrigger -AtLogOn
$option = New-ScheduledJobOption 

Register-ScheduledJob -ScriptBlock {Get-service} -Name MyJob -Trigger $trigger -ScheduledJobOption $option 




#########################################################################################################################################################
# Package Management

# A Bootstrap provider (the provider that knows where to get more providers from)
# MSI provider for handling MSI files
# MSU provider for handling Microsoft update files
# Programs provider (Add/Remove programs) for providing inventory data of anything that registered itself with Add/Remove programs
# PowerShellGet -- for accessing PowerShell modules.



#########################################################################################################################################################

#PackageManagement functionality was introduced in Windows PowerShell 5.0.
#In other words, now you can install programs from the command prompt in Windows 10/ Windows Server 2016 like 
#they do it in Linux using the well-known command apt-get install.
# The installation comes down to running a single PowerShell command, and a user doesn’t have to search and download software distributions in the Web, 
#thus reducing the risk of downloading an outdated or infected programs.

###Set-PackageSource -Name chocolatey -Trusted ( Making a repo Trusted )

 [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

http://chocolatey.org/api/v2/

########################################################################################################################################################
 Find-PackageProvider * 
 Get-PackageProvider

 Get-Command  -Module packagemanagement

 # Demo

#  Find-Package -Name Sysinternals | Install-Package

 # Find-Package -Name firefox, winrar, notepadplusplus, putty, dropbox | Install-Package ( mulitple applications)

 
 Get-Command -Noun Package
 Get-Command -Module PackageManagement | sort noun, verb # Three levels of management, i.e. provider, package source, and package
 Find-Package psreadline  -allversions
 Find-Package chrome  -allversions
 Get-Package -ProviderName programs -IncludeWindowsInstaller # to check all installed programs on local computer managed by MSI
 Get-PackageProvider
 get-command -Module PowerShellGet
 Get-PackageProvider chocolatey
 Find-Package| Out-GridView
 Install-Package -Name vlc
 =====
 #Powersell Get

 Get-module powershellget -ListAvailable
 Get-module powershellget -ListAvailable | select -ExpandProperty exportedcommands

 Find-Package -ProviderName chocolatey | Out-GridView -PassThru | Install-Package 


 #The New-ModuleManifest cmdlet creates a new module manifest (.psd1) file,populates its values, and saves the manifest file in the specified path.
 # A module manifest is a .psd1 file that contains a hashtable. The keys and values in the hash table describe the contents and attributes of the module

 New-Item –Type directory –Path C:\MyRepo
New-SmbShare -Path C:\MyRepo -FullAccess Everyone -Name MyRepo
Register-PSRepository `
-Name MyRepo `
-PackageManagementProvider NuGet `
-SourceLocation \\localhost\MyRepo `
-PublishLocation \\localhost\MyRepo `
-InstallationPolicy Trusted 

Get-PSRepository


New-ScriptFileInfo `
-Path C:\Temp\MyScript.ps1 `
-Version 1.0 `
-Author "Joe Scripter" `
-Description "My Script" `
-ReleaseNotes @'
Version history 1.0 - Initial release
'@

Test-ScriptFileInfo -Path C:\Temp\MyScript.ps1

Publish-Script `
-Path C:\Temp\MyScript.ps1 `
-Repository MyRepo 

Find-Package -ProviderName Powershellget -Type script -Source myrepo



