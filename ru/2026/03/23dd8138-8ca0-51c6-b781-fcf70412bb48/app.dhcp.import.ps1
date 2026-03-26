<#PSScriptInfo
.VERSION      0.1.0
.GUID         ff98447a-f7d7-43a7-80d8-6585ee2eebd9
.AUTHOR       Kai Kimera
.AUTHOREMAIL  mail@kaikim.ru
.TAGS         windows server dhcp
.LICENSEURI   https://choosealicense.com/licenses/mit/
.PROJECTURI   https://libsys.ru/ru/2026/03/23dd8138-8ca0-51c6-b781-fcf70412bb48/
#>

#Requires -Version 7.4

<#
.SYNOPSIS
Importing clients to the DHCP server.

.DESCRIPTION
Bulk import of clients to DHCP server from XML file.

.EXAMPLE
.\app.dhcp.import.ps1 -Scope '192.168.2.0' -Path 'C:\DHCPServer.xml'

.EXAMPLE
.\app.dhcp.import.ps1 -Scope '192.168.2.0' -Path 'C:\DHCPServer.xml' -Lease

.LINK
https://libsys.ru/ru/2026/03/23dd8138-8ca0-51c6-b781-fcf70412bb48/
#>

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

param(
  [Parameter(Mandatory)][System.Net.IPAddress]$Scope,
  [string]$Path = "${PSScriptRoot}\DHCPServer.xml",
  [switch]$Lease
)

$XML = [xml](Get-Content -LiteralPath "${Path}")
$Data = $XML.DHCPServer.IPv4.Scopes.Scope.Reservations.Reservation

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function Import-DHCP {
  try {
    $Data.ForEach({
      $Common = @{
        ScopeId = "${Scope}"
        IPAddress = "$($_.IPAddress)"
        ClientId = "$($_.ClientId)"
        Description = "$($_.Description)"
      }

      if ($Lease) {
        $Client = @{
          HostName = "$($_.Name)"
          ClientType = "$($_.Type)"
        }; Add-DhcpServerv4Lease @Common @Client
      } else {
        $Client = @{
          Name = "$($_.Name)"
          Type = "$($_.Type)"
        }; Add-DhcpServerv4Reservation @Common @Client
      }
    })
  } catch {
    Write-Error "ERROR: $($_.Exception.Message)"
  }
}

function Start-Script() {
  Import-DHCP
}; Start-Script
