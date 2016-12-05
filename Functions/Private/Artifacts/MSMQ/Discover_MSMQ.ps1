﻿function Discover_MSMQ {
<#
.SYNOPSIS
Scans for presence of the MSMQ Windows feature 

.PARAMETER MountPath
The path where the Windows image was mounted to.

.PARAMETER OutputPath
The filesystem path where the discovery manifest will be emitted.
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess",'')]
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $MountPath,
    [Parameter(Mandatory = $true)]
    [string] $OutputPath
)

$ArtifactName = Split-Path -Path $PSScriptRoot -Leaf
Write-Verbose -Message ('Started discovering {0} artifact' -f $ArtifactName)

### Path to the manifest
$Manifest = '{0}\{1}.json' -f $OutputPath, $ArtifactName

### Create a HashTable to store the results (this will get persisted to JSON)
$ManifestResult = @{
    Name = 'MSMQ'
    Status = ''
}

$MSMQ = Get-WindowsOptionalFeature -FeatureName MSMQ-Server -Path $MountPath 

if ($MSMQ.State -eq 'Enabled') {
    Write-Verbose -Message 'MSMQ service is present'
    $ManifestResult.Status = 'Present'
}
else {
    Write-Verbose -Message 'MSMQ service was not found'
    $ManifestResult.Status = 'Absent'
}

### Write the result to the manifest file
$ManifestResult | ConvertTo-Json | Set-Content -Path $Manifest

Write-Verbose -Message ('Finished discovering {0} artifact' -f $ArtifactName)
}

