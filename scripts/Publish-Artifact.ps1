<#
    .SYNOPSIS
    Script to publish DSC artifact locally or to storage account

    .DESCRIPTION
    Publish script that can handle local build of artifact and build to storage account

    .PARAMETER BuildPath
    Path to where the artifact will be build

    .PARAMETER ConfigurationFileName
    File name of the configuration file

    .PARAMETER ContainerName
    Name of the container

    .PARAMETER ResourceGroupName
    Name of the resource group where storage account resides

    .PARAMETER Scenario
    Scenario's 'local' for local build and pipeline to publish directly to storage account

    .PARAMETER SolutionRootPath
    Path to solution 'dscpolicies'

    .PARAMETER StorageAccountName
    Name of the concerning storage account

    .PARAMETER SubscriptionId
    Subscription id of concerning resources

    .EXAMPLE
    Publish artifact locally
    $publishArtifactLocalArgs = @{
        BuildPath             = 'C:\Users\SomeUser\Sources\somerepo\solutions\dscpolicies\out'
        ConfigurationFileName = 'vmBaseline.ps1'
        SolutionRootPath      = 'C:\Users\SomeUser\Sources\somerepo\solutions\dscpolicies'
    }
    . .\Publish-Artifact.ps1 @publishArtifactLocalArgs

    Publish artifact to storage account
    $publishArtifactToStorageArgs = @{
        ConfigurationFileName = 'vmBaseline.ps1'
        ContainerName         = 'dscextension'
        ResourceGroupName     = 'storage-rg'
        SolutionRootPath      = 'C:\Users\SomeUser\Sources\somerepo\solutions\dscpolicies'
        StorageAccountName    = 'examplestorage'
        SubscriptionId        = '00000000-0000-0000-0000-000000000000'
    }
    . .\Publish-Artifact.ps1 @publishArtifactToStorageArgs
#>
[CmdletBinding(DefaultParameterSetName = 'StorageAccount')]
param (
    [Parameter(Mandatory, ParameterSetName = 'Local')]
    [ValidateNotNullOrEmpty()]
    [System.String] $BuildPath,

    [Parameter(Mandatory, ParameterSetName = 'StorageAccount')]
    [Parameter(Mandatory, ParameterSetName = 'Local')]
    [ValidateNotNullOrEmpty()]
    [System.String] $ConfigurationFileName,

    [Parameter(Mandatory, ParameterSetName = 'StorageAccount')]
    [ValidateNotNullOrEmpty()]
    [System.String] $ContainerName,

    [Parameter(Mandatory, ParameterSetName = 'StorageAccount')]
    [ValidateNotNullOrEmpty()]
    [System.String] $ResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateScript( {
            Test-Path -Path $_
        },
        ErrorMessage = 'Please provide a valid path where solution resides'
    )]
    [System.String] $SolutionRootPath,

    [Parameter(Mandatory, ParameterSetName = 'StorageAccount')]
    [ValidateNotNullOrEmpty()]
    [System.String] $StorageAccountName,

    [Parameter(Mandatory, ParameterSetName = 'StorageAccount')]
    [ValidateNotNullOrEmpty()]
    [System.String] $SubscriptionId
)

$InformationPreference = 'Continue'

#region Load dependencies
$modulesPath = Join-Path -Path $SolutionRootPath -ChildPath 'configuration' -AdditionalChildPath 'modules' -Resolve
$configurationPath = Join-Path -Path $SolutionRootPath -ChildPath 'configuration' -Resolve
$configurationFilePath = Join-Path -Path $configurationPath -ChildPath $ConfigurationFileName -Resolve

# Create cache path in case of local scenario
if (-not [string]::IsNullOrEmpty($BuildPath)) {
    Write-Information -MessageData "Creating cache path at [$BuildPath]"
    New-Item -Path $BuildPath -ItemType Directory -ErrorAction SilentlyContinue > $null
}

Write-Information -MessageData 'Importing custom modules'
$pathSeparator = [System.IO.Path]::PathSeparator
$modulesPaths = $env:PSModulePath -split $pathSeparator

if ($null -ne $env:ProgramFiles) {
    Write-Debug -Message "Path to program files exists: [$($env:ProgramFiles)]"
    $destinationPath = Join-Path -Path $env:ProgramFiles -ChildPath '\powershell\7\Modules'
} else {
    $userModulePath = $modulesPaths.Where{ $_ -match $env:USERNAME -and $_ -cmatch "Modules" -and (Test-Path -Path $_) } | Select-Object -First 1
    Write-Debug -Message "Current user module path is: [$userModulePath]"
    $destinationPath = $userModulePath | Resolve-Path
}
Write-Verbose -Message "Destination path: [$destinationPath)]"

(Get-ChildItem -Path $modulesPath -Directory).ForEach{
    Write-Information -MessageData "Copying module [$($_.Name)] to path [$destinationPath]"
    Copy-Item -Path $_.FullName -Destination $destinationPath -Recurse -Force
    Import-Module -Name $_.Name
}

Write-Information -MessageData 'Installing modules'
@('SecurityPolicyDSC', 'AuditPolicyDSC').ForEach{
    $moduleInstalled = Get-InstalledModule -Name $_ -ErrorAction 'SilentlyContinue'
    if (-not $moduleInstalled) {
        Install-Module $_ -Force -Confirm:$false
    }
}
#endregion

#region Publish Artifact
try {
    if ($StorageAccountName -ne '') {
        $currentContext = Get-AzContext
        Write-Information -MessageData "Current context is: [$($currentContext.Subscription.Name)]"
        if (-not ($currentContext.Subscription.Id -ne $SubscriptionId)) {
            Write-Information -MessageData "Attempt to switch context to subscription id: [$SubscriptionId]"
            Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop > $null

            $publishArgs = @{
                ConfigurationPath  = $configurationFilePath
                ContainerName      = $ContainerName
                ResourceGroupName  = $ResourceGroupName
                StorageAccountName = $StorageAccountName
            }
        }
    } else {
        $publishArgs = @{
            ConfigurationPath = $configurationFilePath
            OutputArchivePath = (Join-Path -Path $BuildPath -ChildPath "$ConfigurationFileName.zip")
        }
    }

    Write-Information -MessageData 'Checking dependencies and publishing artifact'
    $publishResult = Publish-AzVMDscConfiguration @publishArgs -Force
    if ($null -ne $publishResult) {
        Write-Host "##vso[task.setVariable variable=artifacturi;]$publishResult"
    }
} catch {
    Write-Information -MessageData "Unable to publish VM DSC configuration file(s), Exception: [$($_.Exception.Message)]"
}
#endregion
