# azure-dsc-extension-solution

A DSC configuration consisting of composite resources wrapped around an automated build solution.
This DSC configuration uses the 'push' method and the Azure DSC extension.

This folder contains Windows Powershell Desired State Configurations (DSC) and composite resources.
The configurations contains a setup of settings and configuration for Audit Policies , Security Policies and Registry keys. This set of configurations will remediate security recommendations such as: `Vulnerabilities in security configuration on your virtual machine scale sets should be remediated` in the Azure Security Center. Also these configurations are applicable for both Virtual Machines and VM Scale Sets.
This configuration has a dependency on DSC modules such as: 'AuditPolicyDSC' and 'SecurityPolicyDSC'. The dependency modules are automatically downloaded and installed.

## Configuration

The configuration setup is made with composite resources that are composed in a single configuration script. The initial setup of the script is called `vmBaseline.ps1`. The script can be enhanced with further configurations of a machine or can be migrated with an existing configuration.
Every type of DSC configuration is placed in a single module.
The module folder structure is setup as following:

    ├── dscpolicies
    │ ├── configuration
    | | |–– modules
    │ │ | |––[CompositeResourceName]
    │ │ | |–– DSCResources
    │ │ | ├── DSCResources ├── [ModuleName]
    │ │ | ├── DSCResources ├── [ModuleName] ├── [ModuleName].psd1
    │ │ | ├── DSCResources ├── [ModuleName] ├── [ModuleName].schema.psm1
    │ │ | ├── DSCResources ├── [ModuleName].psd1
    | | |–– [ConfigurationFileName].ps1

More information about composite resources can be found [here](https://docs.microsoft.com/en-us/powershell/scripting/dsc/resources/authoringresourcecomposite?view=powershell-7.1).

The main script that uses the composite resources is pre-configured with the name `vmBaseline.ps1` and is placed in the folder `configuration`.
This structure should be maintained so that the automation pipeline can work correctly.

## Scripts and helpers

The DSC configuration solution is created with supporting scripts and functions.

| Path      | Script                          | Description                                                                                                                               |
| --------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| /.helpers | DscPoliciesHelpers.ps1          | Helper script containing functions that are used in main script `Install-DscPolicies.ps1`                                                 |
| /scripts  | Install-DscPolicies.ps1         | Main installer script to install DSC policies for different types of Azure VM resources that are automatically fetched by resource group. |
| /scripts  | New-ConfigurationStorage.ps1    | Script to create a temporary storage account with required permissions.                                                                   |
| /scripts  | Remove-ConfigurationStorage.ps1 | Script to remove the temporary storage account.                                                                                           |
| /scripts  | Publish-Artifact.ps1            | Script to create the artifact with required dependencies and methods to publish local or to storage account.                              |

## Pipeline

The script `dscpolicies_cicd.yaml` is the automation pipeline script located in the solution root folder.
It follows the deployment process as following:

1. Create temporary storage account
2. Publish artifact to storage account
3. Install DSC policies for required VM/ VMSS types.
4. Remove temporary storage account.

### Required variables

The pipeline script is pre-configured to use a variable group: `vm-dsc-policies-vars`.
The variable group should contain the following variables:

| Variable Name          | Example Value                                                           | Description                                                 |
| ---------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------- |
| configurationfilename  | vmBaseline.ps1                                                          | File name of the configuration script                       |
| configurationarguments | {"UserName":"manage","FileText":"some text required for configuration"} | Arguments required for the configuration script             |
| configurationname      | VMBaseline                                                              | Name of the configuration                                   |
| containername          | dscextension                                                            | Storage container name where the artifact resides           |
| excluderesourcenames   | examplevm01, examplevmss01, examplevmss02                               | Names of the resources within the resource group to exclude |
| resourcegroupname      | dsc-rg                                                                  | Resource group name of where the resources resides          |
| resourcetypes          | virtualMachines, virtualMachineScaleSets                                | Azure resource types that the dsc policies solution covers  |
| serviceconnectionname  | dsc-spn                                                                 | Service connection name of the resource group               |
| subscriptionid         | 00000000-0000-0000-0000-000000000000                                    | Subscription id where the resource group resides            |
