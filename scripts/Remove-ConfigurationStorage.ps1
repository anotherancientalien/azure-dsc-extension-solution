<#
    .SYNOPSIS
    This script will remove a storage account

    .DESCRIPTION
    This script will remove a storage account

    .PARAMETER ResourceGroupName
    ResourceGroupName name of the resourcegroup where the storage account is located.

    .PARAMETER StorageAccountName
    Name of the storage account

    .EXAMPLE
    $removeStorageArgs = @{
        ResourceGroupName   = 'storage-rg'
        StorageAccountName  = 'examplestorage01'
    }
    . .\Remove-ConfigurationStorage @removeStorageArgs
#>
[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $StorageAccountName
)

$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Write-Information -MessageData "Removing storage account: [$StorageAccountName]"
try {
    Remove-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Force
} catch {
    Write-Error -Message "Failed to remove storage account: $($_.Exception.Message)" -ErrorAction Stop
}
