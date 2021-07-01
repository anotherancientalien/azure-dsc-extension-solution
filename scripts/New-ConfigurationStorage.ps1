<#
    .SYNOPSIS
    Script to create storage account, container and required roles

    .DESCRIPTION
    This script will create a storage account assign storage contributor permissions to blob container and create a blob container.

    .PARAMETER ContainerName
    Name of the container where artifact is published

    .PARAMETER ResourceGroupName
    ResourceGroupName name of the resourcegroup where the storage account is located.

    .EXAMPLE
    $newConfigurationStorageArgs = @{
        ContainerName     = 'dscextension'
        ResourceGroupName = 'storage-rg'
    }
    . .\New-ConfigurationStorage @newConfigurationStorageArgs
#>
[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ContainerName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ResourceGroupName
)

$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

#region pre static variables
$guid = [guid]::NewGuid().ToString("N").Substring(15)
$storageAccountName = $guid + "stg"
$azContext = Get-AzContext

Write-Information -MessageData "Verify if storage account [$storageAccountName] exists"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -ErrorAction SilentlyContinue
if (-not $storageAccount) {
    Write-Information -MessageData "Create new storage account [$storageAccountName]"
    $saArgs = @{
        Location          = "West Europe"
        Name              = $storageAccountName
        ResourceGroupName = $ResourceGroupName
        SkuName           = "Standard_LRS"
    }
    $storageAccount = New-AzStorageAccount @saArgs
}

#endregion blob data access permissions
$permissionArray = @(
    "Storage Account Contributor",
    "Storage Blob Data Contributor",
    "Storage Blob Data Owner"
)
Write-Information -MessageData "Set permissions for SPN ID"
foreach ($permission in $permissionArray) {
    $azRoleAssignmentArgs = @{
        ApplicationId      = $azContext.Account.Id
        ResourceGroupName  = $ResourceGroupName
        ResourceName       = $storageAccountName
        ResourceType       = "Microsoft.Storage/storageAccounts"
        RoleDefinitionName = $permission
    }
    New-AzRoleAssignment @azRoleAssignmentArgs > $null
}

Write-Host "##vso[task.setVariable variable=storageaccountname;]$storageAccountName"
