<#
    .SYNOPSIS
    Function to invoke DSC installer by resource type

    .DESCRIPTION
    Installer script that will be invoked by the pipeline and regulates the installation per resource in resource group

    .PARAMETER ArtifactLocation
    Public artifact location uri of where the artifact is stored

    .PARAMETER ConfigurationArguments
    Arguments that are required by the DSC configuration script

    .PARAMETER ConfigurationFileName
    File name of the DSC configuration

    .PARAMETER ConfigurationName
    Name of the DSC configuration

    .PARAMETER ContainerName
    Name of the storage container where artifact is located

    .PARAMETER ExcludeResourceNames
    Name of the resources to exclude

    .PARAMETER ResourceGroupName
    Resource group name where resource is located

    .PARAMETER ResourceTypes
    Types of Azure Resources 'virtualMachines', 'virtualMachineScaleSets'

    .PARAMETER StorageAccountName
    Name of the storage account

    .PARAMETER StorageAccountResourceGroupName
    Resource group name of the storage account

    .EXAMPLE
    $installDscArgs = @{
        ArtifactLocation                = 'https://examplestorage01abc.blob.core.windows.net/dscextension/vmBaseline.ps1.zip'
        ConfigurationArguments         = '{"UserName":"manage","FileText":"Example text for user manage"}'
        ConfigurationFileName           = 'vmBaseline.ps1'
        ConfigurationName               = 'VMBaseline'
        ContainerName                   = 'dscextension'
        ExcludeResourceNames            = 'example-vm-01'
        ResourceGroupName               = 'vm-rg'
        ResourceTypes                   = 'virtualMachines'
        StorageAccountName              = 'examplestorage01abc'
        StorageAccountResourceGroupName = 'storage-rg'
    }
    . .\Install-DscPolicies @installDscArgs
#>
[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [System.String] $ArtifactLocation,

    [Parameter()]
    [System.String] $ConfigurationArguments,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ConfigurationFileName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ConfigurationName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $ContainerName,

    [Parameter()]
    [System.String] $ExcludeResourceNames,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $ResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateSet("virtualMachines", "virtualMachineScaleSets")]
    [System.String[]] $ResourceTypes,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $StorageAccountName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [System.String] $StorageAccountResourceGroupName
)

if ($env:SYSTEM_DEBUG -eq $true) {
    $DebugPreference = 'Continue'
    $VerbosePreference = 'Continue'
    Write-Debug -Message 'Set debug preferences to continue'
}

$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

#region Loading dependencies
Write-Information -MessageData 'Loading helper functions'
$solutionRootPath = Split-Path -Path $PSScriptRoot -Parent
$helperScriptPath = Join-Path -Path $solutionRootPath -ChildPath '.helpers' -AdditionalChildPath 'DscPoliciesHelpers.ps1' -Resolve
. $helperScriptPath
$configArgs = $ConfigurationArguments | ConvertFrom-Json -Depth 100 -AsHashtable

Write-Information -MessageData 'Retrieving storage account'
$storageAccount = Get-AzStorageAccount -ResourceGroupName $StorageAccountResourceGroupName -Name $StorageAccountName -ErrorAction Stop
#endregion

#region Install by resource type
Write-Information -MessageData 'Executing installation for DSC Policies'
Write-Verbose -Message "Provided resource types: [$($ResourceTypes | ConvertTo-Json)]"
$ResourceTypes.ForEach{
    $resourceType = $_

    Write-Information -MessageData "Retrieving resources for resource type: [$resourceType]"
    $resources = Get-AzResource -ResourceGroupName $ResourceGroupName -ResourceType "Microsoft.Compute/$resourceType"
    if (-not [string]::IsNullOrEmpty($ExcludeResourceNames)) {
        Write-Information -MessageData 'Excluding resources'
        Write-Debug -Message ($ExcludeResourceNames)
        $resourcesToExclude = $ExcludeResourceNames.Split(',').Trim()
        $resources = $resources | Where-Object -FilterScript { $_.Name -notin $resourcesToExclude }
    }

    if (($null -ne $resources) -and ($resources.Count -gt 0)) {
        Write-Information -MessageData "Found [$($resources.Count) resources]"
        Write-Debug -Message ($resources | ConvertTo-Json -Depth 10)

        if ($resourceType -eq 'virtualMachineScaleSets') {
            Write-Information -MessageData 'Generating new SAS token for VM Scale Set DSC installation'
            $container = $storageAccount | Get-AzStorageContainer -Name $ContainerName
            if ($null -eq $container) {
                $container = $storageAccount | New-AzStorageContainer -Permission Off -Name $ContainerName
            }
            $sasToken = $container | New-AzStorageContainerSASToken -Permission 'rwdl'
        }

        $installerArgs = @{
            ArtifactLocation                = $ArtifactLocation
            ArtifactSasToken                = $sasToken
            ConfigurationArguments          = $configArgs
            ConfigurationFileName           = $ConfigurationFileName
            ConfigurationName               = $ConfigurationName
            ContainerName                   = $ContainerName
            ResourceGroupName               = $ResourceGroupName
            ResourceName                    = ($Resources.Name | Select-Object -First 1)
            ResourceType                    = $resourceType
            StorageAccountName              = $StorageAccountName
            StorageAccountResourceGroupName = $StorageAccountResourceGroupName
        }
        if ($resources.Count -eq 1) {
            Invoke-DscInstallerByResourceType @installerArgs
        } else {
            Write-Verbose -Message 'Executing installer in parallel'
            $resources | ForEach-Object {
                $resourceInstallerArgs = $installerArgs
                $resourceInstallerArgs.ResourceName = $_.Name

                Invoke-DscInstallerByResourceType @resourceInstallerArgs
            }
        }
    } else {
        Write-Information -MessageData "No resources were found for resource type: [$resourceType], skipping installation..."
    }
}
#endregion
