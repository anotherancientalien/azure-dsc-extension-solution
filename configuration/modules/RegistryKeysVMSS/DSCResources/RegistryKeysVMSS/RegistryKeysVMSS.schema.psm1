Configuration RegistryKeysVMSS
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\DisableRunAs' {
        ValueName = 'DisableRunAs'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client\AllowDigest' {
        ValueName = 'AllowDigest'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Explorer\NoAutoplayfornonVolume' {
        ValueName = 'NoAutoplayfornonVolume'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation\AllowInsecureGuestAuth' {
        ValueName = 'AllowInsecureGuestAuth'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application\MaxSize' {
        ValueName = 'MaxSize'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
        ValueData = 32768
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\DisablePasswordSaving' {
        ValueName = 'DisablePasswordSaving'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fPromptForPassword' {
        ValueName = 'fPromptForPassword'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup\MaxSize' {
        ValueName = 'MaxSize'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup'
        ValueData = 32768
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutorun' {
        ValueName = 'NoAutorun'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security\MaxSize' {
        ValueName = 'MaxSize'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
        ValueData = 196608
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\EventLog\System\MaxSize' {
        ValueName = 'MaxSize'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
        ValueData = 32768
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DefaultOutboundAction' {
        ValueName = 'DefaultOutboundAction'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\EnableFirewall' {
        ValueName = 'EnableFirewall'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun' {
        ValueName = 'NoDriveTypeAutoRun'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        ValueData = 255
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\EnableFirewall' {
        ValueName = 'EnableFirewall'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\EnableSmartScreen' {
        ValueName = 'EnableSmartScreen'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenCamera' {
        ValueName = 'NoLockScreenCamera'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Personalization\NoLockScreenSlideshow' {
        ValueName = 'NoLockScreenSlideshow'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds\DisableEnclosureDownload' {
        ValueName = 'DisableEnclosureDownload'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient\EnableMulticast' {
        ValueName = 'EnableMulticast'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\UndockWithoutLogon' {
        ValueName = 'UndockWithoutLogon'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\Scan\DisableRemovableDriveScanning' {
        ValueName = 'DisableRemovableDriveScanning'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Scan'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows Defender\SpyNet\SubmitSamplesConsent' {
        ValueName = 'SubmitSamplesConsent'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows Defender\SpyNet'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Windows Search\AllowCortanaAboveLock' {
        ValueName = 'AllowCortanaAboveLock'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Windows Search\AllowCortana' {
        ValueName = 'AllowCortana'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\InputPersonalization\AllowInputPersonalization' {
        ValueName = 'AllowInputPersonalization'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\InputPersonalization'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\MSAOptional' {
        ValueName = 'MSAOptional'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\DataCollection\AllowTelemetry' {
        ValueName = 'AllowTelemetry'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Windows Search\AllowSearchToUseLocation' {
        ValueName = 'AllowSearchToUseLocation'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\BlockUserFromShowingAccountDetailsOnSignin' {
        ValueName = 'BlockUserFromShowingAccountDetailsOnSignin'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch\DriverLoadPolicy' {
        ValueName = 'DriverLoadPolicy'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch'
        ValueData = 3
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fAllowToGetHelp' {
        ValueName = 'fAllowToGetHelp'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\DontDisplayNetworkSelectionUI' {
        ValueName = 'DontDisplayNetworkSelectionUI'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\CredUI\DisablePasswordReveal' {
        ValueName = 'DisablePasswordReveal'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\CredUI'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\DataCollection\DoNotShowFeedbackNotifications' {
        ValueName = 'DoNotShowFeedbackNotifications'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Rpc\EnableAuthEpResolution' {
        ValueName = 'EnableAuthEpResolution'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DontDisplayLastUserName' {
        ValueName = 'DontDisplayLastUserName'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters\RequireSecuritySignature' {
        ValueName = 'RequireSecuritySignature'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters\RequireSecuritySignature' {
        ValueName = 'RequireSecuritySignature'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters\EnableSecuritySignature' {
        ValueName = 'EnableSecuritySignature'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymous' {
        ValueName = 'RestrictAnonymous'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\UseMachineId' {
        ValueName = 'UseMachineId'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\LmCompatibilityLevel' {
        ValueName = 'LmCompatibilityLevel'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
        ValueData = 5
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinClientSec' {
        ValueName = 'NTLMMinClientSec'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueData = 537395200
    }

    Registry 'Registry(POL): HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0\NTLMMinServerSec' {
        ValueName = 'NTLMMinServerSec'
        ValueType = 'Dword'
        Key       = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueData = 537395200
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Network Connections\NC_AllowNetBridge_NLA' {
        ValueName = 'NC_AllowNetBridge_NLA'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Network Connections\NC_ShowSharedAccessUI' {
        ValueName = 'NC_ShowSharedAccessUI'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\fEncryptRPCTraffic' {
        ValueName = 'fEncryptRPCTraffic'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard\ExitOnMSICW' {
        ValueName = 'ExitOnMSICW'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\System\DisableLockScreenAppNotifications' {
        ValueName = 'DisableLockScreenAppNotifications'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\FilterAdministratorToken' {
        ValueName = 'FilterAdministratorToken'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin' {
        ValueName = 'ConsentPromptBehaviorAdmin'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 2
    }

    Registry 'Registry(POL): HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorUser' {
        ValueName = 'ConsentPromptBehaviorUser'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\AllowLocalIPsecPolicyMerge' {
        ValueName = 'AllowLocalIPsecPolicyMerge'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DisableNotifications' {
        ValueName = 'DisableNotifications'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DefaultOutboundAction' {
        ValueName = 'DefaultOutboundAction'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\AllowLocalIPsecPolicyMerge' {
        ValueName = 'AllowLocalIPsecPolicyMerge'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DisableNotifications' {
        ValueName = 'DisableNotifications'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\EnableFirewall' {
        ValueName = 'EnableFirewall'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DefaultOutboundAction' {
        ValueName = 'DefaultOutboundAction'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\AllowLocalIPsecPolicyMerge' {
        ValueName = 'AllowLocalIPsecPolicyMerge'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DisableNotifications' {
        ValueName = 'DisableNotifications'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\AuthenticodeEnabled' {
        ValueName = 'AuthenticodeEnabled'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\DisableUnicastResponsesToMulticastBroadcast' {
        ValueName = 'DisableUnicastResponsesToMulticastBroadcast'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\DisableUnicastResponsesToMulticastBroadcast' {
        ValueName = 'DisableUnicastResponsesToMulticastBroadcast'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        ValueData = 0
    }

    Registry 'Registry(POL): HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\DisableUnicastResponsesToMulticastBroadcast' {
        ValueName = 'DisableUnicastResponsesToMulticastBroadcast'
        ValueType = 'Dword'
        Key       = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        ValueData = 1
    }

    Registry 'Registry(POL): HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\UserAuthentication' {
        ValueName = 'UserAuthentication'
        ValueType = 'Dword'
        Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
        ValueData = 1
    }
}
