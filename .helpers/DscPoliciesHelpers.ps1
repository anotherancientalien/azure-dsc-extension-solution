<#
    .SYNOPSIS
    Function to retrieve virtual machine power state

    .DESCRIPTION
    This function is to retrieve the virtual machine power state and it uses the virtual machine instance object

    .PARAMETER VirtualMachine
    Virtual machine instance view object that includes statuses

    .EXAMPLE
    $vm = Get-AzVm -ResourceGroupName 'exampleRg' -Name 'ccc-example-vmname' -Status
    Get-VMPowerState -VirtualMachine $vm
#>
function Get-VMPowerState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject] $VirtualMachine
    )

    begin {
        $statusObj = $VirtualMachine.psobject.Properties | Where-Object { $_.Name -eq 'Statuses' } | Select-Object -ExpandProperty Value
    }

    process {
        $powerState = $statusObj.Where{ $_.Code -match 'PowerState' }
        if ($null -ne ($powerState)) {
            $currentStatus = ($powerState.Code -split "/")[1]
            Write-Output -InputObject $currentStatus
        }
    }
}

<#
    .SYNOPSIS
    Installer script to handle extensions and update process of VMSS

    .DESCRIPTION
    Installer script that handles extensions and updates process of VMSS by using SAS token of storage account

    .PARAMETER ArtifactLocation
    Uri of the storage account where the artifact is published

    .PARAMETER ArtifactSasToken
    Sas token of the container where the artifact is published

    .PARAMETER ConfigurationArguments
    Arguments that are required by the DSC configuration script

    .PARAMETER ConfigurationFileName
    File name of the DSC script

    .PARAMETER ConfigurationName
    Name of the DSC configuration

    .PARAMETER ResourceGroupName
    Resource group name of the concerning VMSS

    .PARAMETER VmssName
    Name of virtual machine scale set

    .EXAMPLE
    $installVmssDscExtensionArgs = @{
        ArtifactLocation       = 'https://mystorageaccount.blob.core.windows.net/dscextension/vmBaseline.ps1.zip'
        ArtifactSasToken       = '?sv=2000-01-01&sr=c&sig=z9iMYEUvXehJsUwYPxgVgD8JJ0HaETUPBHeF8z%2B%2Fj5U%3D&se=2000-01-02T12%3A02%3A48Z&sp=rwdl'
        ConfigurationArguments = @{
            UserName = 'manage'
            FileText = 'Some text for user manage'
        }
        ConfigurationFileName  = 'vmBaseline.ps1'
        ConfigurationName      = 'VMBaseline'
        ResourceGroupName      = 'vmss-rg'
        VmssName               = 'vmss-example-name'
    }
    .\Install-VmssDscExtension @installVmssDscExtensionArgs
#>
function Install-VmssDscExtension {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ArtifactLocation,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ArtifactSasToken,

        [Parameter()]
        [System.Collections.Hashtable] $ConfigurationArguments,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationFileName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $VmssName
    )

    Write-Information -MessageData 'Start installer script for VM Scale Set DSC Extension'

    #region Remove extension
    Write-Information -MessageData "Retrieving virtual machine scale set"

    $vmss = Get-AzVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $VmssName

    Write-Information -MessageData "Install DSC solution for vm scale set: [$($VmssName)] in resource group: [$ResourceGroupName]"

    $extensionName = 'Microsoft.Powershell.DSC'
    $extensionExists = $vmss.VirtualMachineProfile.ExtensionProfile.Extensions.Name -contains $extensionName
    $vmssInstances = Get-AzVmssVm -ResourceGroupName $vmss.ResourceGroupName -VMScaleSetName $vmss.Name -InstanceView

    try {
        if ($extensionExists) {
            Write-Information -MessageData "Removing extension [$extensionName] from VM scale set: [$($vmss.Name)]"
            Remove-AzVmssExtension -VirtualMachineScaleSet $vmss -Name $extensionName > $null

            Write-Information -MessageData "Updating VM scale set name: [$($vmss.Name)]"
            Update-AzVmss -ResourceGroupName $vmss.ResourceGroupName -Name $vmss.Name -VirtualMachineScaleSet $vmss -EnableAutomaticUpdate $true -ErrorAction SilentlyContinue > $null
        }
    } catch {
        Write-Information -MessageData "Error occurred while removing and updating extension: $($_.Exception.Message)"
    } finally {
        $vmssInstances.ForEach{
            Write-Information -MessageData "Updating VM scale set [$($vmss.Name)] instance id: [$($_.InstanceId)] - [$($_.Name)]"
            Update-AzVmssInstance -ResourceGroupName $vmss.ResourceGroupName -VMScaleSetName $vmss.Name -InstanceId $_.InstanceId > $null
        }

        $updatedVmss = Get-AzVmss -ResourceGroupName $vmss.ResourceGroupName -VMScaleSetName $vmss.Name
    }
    #endregion

    #region Add DSC extension
    try {
        Write-Information -MessageData "Adding extension to VM scale set from VM scale set: [$($updatedVmss.Name)]"
        $extensionArgs = @{
            AutoUpgradeMinorVersion = $true
            Name                    = $extensionName
            Publisher               = 'Microsoft.PowerShell'
            Setting                 = @{
                ModulesUrl            = ($ArtifactLocation + $ArtifactSasToken)
                ConfigurationFunction = "$ConfigurationFileName\$ConfigurationName"
                WmfVersion            = 'latest'
                Privacy               = @{
                    DataCollection = "enable"
                }
            }
            Type                    = 'DSC'
            TypeHandlerVersion      = '2.83'
            VirtualMachineScaleSet  = $updatedVmss
        }

        if ($null -ne $ConfigurationArguments) {
            $extensionArgs.Setting.Add('ConfigurationArguments', $ConfigurationArguments)
        }

        Add-AzVmssExtension @extensionArgs > $null
        Update-AzVmss -ResourceGroupName $updatedVmss.ResourceGroupName -VMScaleSetName $updatedVmss.Name -VirtualMachineScaleSet $updatedVmss -EnableAutomaticUpdate $true > $null

        Write-Information -MessageData "Updating [$($vmssInstances.Count)] scale set instances"
        $vmssInstances.ForEach{
            Write-Information -MessageData "Updating VM scale set  [$($updatedVmss.Name)] instance id: [$($_.InstanceId)]  - [$($_.Name)]"
            Update-AzVmssInstance -ResourceGroupName $updatedVmss.ResourceGroupName -VMScaleSetName $updatedVmss.Name -InstanceId $_.InstanceId > $null
        }
    } catch {
        Write-Information -MessageData "Error occurred  while adding extension: [$($_.Exception.Message)]"
    }
    #endregion
}

<#
    .SYNOPSIS
    Installer script to handle extensions and update process of VM

    .DESCRIPTION
    Script that will be invoked by invocation script 'Invoke-DscInstallerByResourceType'

    .PARAMETER ConfigurationArguments
    Arguments that are required by the DSC configuration script

    .PARAMETER ConfigurationFileName
    File name of the DSC configuration script

    .PARAMETER ConfigurationName
    Configuration name of the DSC script

    .PARAMETER ContainerName
    Name of the container where artifact is published

    .PARAMETER StorageAccountName
    Name of the storage account where artifact container is published

    .PARAMETER StorageAccountResourceGroupName
    Resource group name of the storage account

    .PARAMETER VirtualMachine
    Virtual Machine object

    .EXAMPLE
    $vm = Get-AzVM -ResourceGroupName 'ExampleRG' -VirtualMachineName 'EXAMPLE-VM-NAME'
    $installArgs = @{
        ConfigurationArguments          = @{
            UserName = 'manage'
            FileText = 'Some text for user manage'
        }
        ConfigurationFileName           = 'vmBaseline.ps1'
        ConfigurationName               = 'VMBaseline'
        ContainerName                   = 'dscextension'
        StorageAccountName              = 'somestorageaccount'
        StorageAccountResourceGroupName = 'OtherRG'
    }
    $vm | Install-VmDscExtension @installArgs
#>

function Install-VmDscExtension {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.Hashtable] $ConfigurationArguments,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationFileName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ContainerName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $StorageAccountName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $StorageAccountResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $VirtualMachineName
    )

    begin {
        Write-Information -MessageData "Executing installation for VM: [$VirtualMachineName]"

        $vmInstanceView = Get-AzVm -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName -Status

        $initialPowerState = Get-VMPowerState -VirtualMachine $vmInstanceView
        $isRunning = [bool]($initialPowerState -eq 'running')
        Write-Verbose -Message "Current power state is: [$initialPowerState]"

        if (-not $isRunning) {
            Write-Information -MessageData "VM [$($VirtualMachineName)] is not running, starting VM..."
            $vmInstanceView | Start-AzVm
        }
    }

    process {
        try {
            Write-Information -MessageData "Updating extension for VM: [$($VirtualMachineName)]"

            $extensionArgs = @{
                ArchiveBlobName           = "$ConfigurationFileName.zip"
                ArchiveContainerName      = $ContainerName
                ArchiveResourceGroupName  = $StorageAccountResourceGroupName
                ArchiveStorageAccountName = $StorageAccountName
                ConfigurationName         = $ConfigurationName
                ResourceGroupName         = $ResourceGroupName
                Version                   = '2.76'
                VMName                    = $VirtualMachineName
            }

            if ($null -ne $ConfigurationArguments) {
                $extensionArgs.Add('ConfigurationArgument', $ConfigurationArguments)
            }

            $vmResult = Set-AzVMDscExtension @extensionArgs -AutoUpdate -Force
        } catch {
            Write-Information -MessageData "Error occurred  while adding extension: [$($_.Exception.Message)]"
        }
    }

    end {
        if ($initialPowerState -eq 'deallocated') {
            Write-Information -MessageData "Setting VM to initial power state: [$initialPowerState]"
            Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VirtualMachineName -Force -AsJob > $null
        }

        Write-Output -InputObject $vmResult
    }
}

<#
    .SYNOPSIS
    Function to invoke DSC installer by resource type

    .DESCRIPTION
    This script will be invoked by the main script and will execute the installer script by resource type

    .PARAMETER ArtifactLocation
    Public artifact location uri of where the artifact is stored

    .PARAMETER ArtifactSasToken
    SAS token of the location where the artifact is located

    .PARAMETER ConfigurationArguments
    Arguments that are required by the DSC configuration script

    .PARAMETER ConfigurationFileName
    File name of the DSC configuration

    .PARAMETER ConfigurationName
    Name of the DSC configuration

    .PARAMETER ContainerName
    Name of the storage container where artifact is located

    .PARAMETER ResourceGroupName
    Resource group name where resource is located

    .PARAMETER ResourceName
    Name of the resource

    .PARAMETER ResourceType
    Type of Azure Resource

    .PARAMETER StorageAccountName
    Name of the storage account

    .PARAMETER StorageAccountResourceGroupName
    Resource group name of the storage account

    .EXAMPLE
    $installerArgs = @{
        ArtifactLocation                = 'https://examplestorage01abc.blob.core.windows.net/dscextension/vmBaseline.ps1.zip'
        ArtifactSasToken                = '?sv=2010-01-01&sr=c&sig=00AbcZtQ%2F9OkUqdJTaxhFdN33iOi3gA%2BdyZo4DW9EMY%3D&se=2011-01-01T00%3A49%3A31Z&sp=rwdl'
        ConfigurationFileName           = 'vmBaseline.ps1'
        ConfigurationName               = 'VMBaseline'
        ContainerName                   = 'dscextension'
        ResourceGroupName               = 'vm-rg'
        ResourceName                    = 'example-vm-01'
        ResourceType                    = 'virtualMachines'
        StorageAccountName              = 'examplestorage01abc'
        StorageAccountResourceGroupName = 'storage-rg'
    }
    Invoke-DscInstallerByResourceType @installerArgs
    #>
function Invoke-DscInstallerByResourceType {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ArtifactLocation,

        [Parameter()]
        [System.String] $ArtifactSasToken,

        [Parameter()]
        [System.Collections.Hashtable] $ConfigurationArguments,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationFileName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigurationName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ContainerName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ResourceName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $ResourceType,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $StorageAccountResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.String] $StorageAccountName
    )

    switch ($ResourceType) {
        'virtualMachines' {
            Write-Verbose -Message "Executing installation for VM: [$ResourceName]"

            $installVmDscArgs = @{
                ConfigurationArguments          = $ConfigurationArguments
                ConfigurationFileName           = $ConfigurationFileName
                ConfigurationName               = $ConfigurationName
                ContainerName                   = $ContainerName
                ResourceGroupName               = $ResourceGroupName
                StorageAccountName              = $StorageAccountName
                StorageAccountResourceGroupName = $StorageAccountResourceGroupName
                VirtualMachineName              = $ResourceName
            }
            Write-Debug -Message ($installVmDscArgs | ConvertTo-Json)
            Install-VmDscExtension @installVmDscArgs
        }

        'virtualMachineScaleSets' {
            Write-Verbose -Message "Executing installation for VMSS: [$ResourceName)]"

            $installVmssDscArgs = @{
                ArtifactLocation       = $ArtifactLocation
                ArtifactSasToken       = $ArtifactSasToken
                ConfigurationArguments = $ConfigurationArguments
                ConfigurationFileName  = $ConfigurationFileName
                ConfigurationName      = $ConfigurationName
                ResourceGroupName      = $ResourceGroupName
                VmssName               = $ResourceName
            }
            Write-Debug -Message ($installVmssDscArgs | ConvertTo-Json)
            Install-VmssDscExtension @installVmssDscArgs
        }
    }
}
