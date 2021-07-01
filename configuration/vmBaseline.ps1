Configuration VMBaseline {
    Import-DscResource -ModuleName AuditPolicyVMSS -ModuleVersion 1.0.0
    Import-DscResource -ModuleName SecurityPolicyVMSS -ModuleVersion 1.0.0
    Import-DscResource -ModuleName RegistryKeysVMSS -ModuleVersion 1.0.0
    Import-DscResource -ModuleName AuditPolicyDsc
    Import-DscResource -ModuleName SecurityPolicyDsc

    node Localhost
    {
        LocalConfigurationManager {
            ActionAfterReboot              = 'ContinueConfiguration'
            ConfigurationModeFrequencyMins = 15
            RebootNodeIfNeeded             = $false
            ConfigurationMode              = 'ApplyAndAutoCorrect'
            RefreshMode                    = 'Push'
            RefreshFrequencyMins           = 30
        }

        SecurityPolicyVMSS Baseline {
            # nested resource (composite dsc resource)
        }

        AuditPolicyVMSS Baseline {
            # nested resource (composite dsc resource)
        }

        RegistryKeysVMSS Baseline {
            # nested resource (composite dsc resource)
        }
    }
}
