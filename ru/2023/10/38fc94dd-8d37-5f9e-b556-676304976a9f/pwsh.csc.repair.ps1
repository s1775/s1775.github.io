<#PSScriptInfo
.VERSION      0.1.0
.GUID         52672f5d-e2c0-467a-ae1d-c0fc9009a1eb
.AUTHOR       Kai Kimera
.AUTHOREMAIL  mail@kaikim.ru
.TAGS         windows domain
.LICENSEURI   https://choosealicense.com/licenses/mit/
.PROJECTURI   https://libsys.ru/ru/2023/10/38fc94dd-8d37-5f9e-b556-676304976a9f/
#>

#Requires -Version 7.2
#Requires -RunAsAdministrator

<#
.SYNOPSIS
Testing and repairing the secure channel between the local computer and its domain.

.DESCRIPTION
Verifying that the channel between the local computer and its domain is working correctly by checking the status of its trust relationships. If a connection fails, trying to restore it.

.EXAMPLE
.\pwsh.csc.repair.ps1

.EXAMPLE
.\pwsh.csc.repair.ps1 -DC 'DC-server.domain.com'

.LINK
https://libsys.ru/ru/2023/10/38fc94dd-8d37-5f9e-b556-676304976a9f/
#>

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

param(
  [Alias('DC')][string]$Server,
  [Alias('S')][int]$Sleep = 5
)

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function Start-CSCRepair() {
  $Param = @{
    Server = "${Server}"
    Repair = $true
    Credential = (Get-Credential)
  }

  do {
    if (Test-ComputerSecureChannel) {
      Write-Host 'Connection successful. Everything is fine!'
    } else {
      Write-Host 'Connection failed! The secure channel between the local computer and the domain is broken. Removing and then rebuilds the channel established by the NetLogon service...'
      Test-ComputerSecureChannel @Param
      Start-Sleep -s $Sleep
    }
  } until (Test-ComputerSecureChannel)
}

function Start-Script() {
  Start-CSCRepair
}; Start-Script
