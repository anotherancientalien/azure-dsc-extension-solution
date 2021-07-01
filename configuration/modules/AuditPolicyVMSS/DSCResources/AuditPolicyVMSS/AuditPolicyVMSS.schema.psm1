Configuration AuditPolicyVMSS {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName AuditPolicyDsc

    AuditPolicyGuid LogonSuccess {
        Name      = 'Logon'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid Logoff {
        Name      = 'Logoff'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid Logon {
        Name      = 'Logon'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid OtherLogonOffEevents {
        Name      = 'Other Logon/Logoff Events'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid AuditPNPActivity {
        Name      = 'Plug and Play Events'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid AuditPolicyChange {
        Name      = 'Audit Policy Change'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid ProcessCreation {
        Name      = 'Process Creation'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid SecurityGroupManagement {
        Name      = 'Security Group Management'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid SecuritySystemExtension {
        Name      = 'Security System Extension'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid SensitivePrivilegeUse {
        Name      = 'Sensitive Privilege Use'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid RemovableStorage {
        Name      = 'Removable Storage'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid SpecialLogon {
        Name      = 'Special Logon'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid SystemIntegrity {
        Name      = 'System Integrity'
        AuditFlag = 'Success and Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid UserAccountManagement {
        Name      = 'User Account Management'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid AccountLockout {
        Name      = 'Account Lockout'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid AuthenticationPolicyChange {
        Name      = 'Authentication Policy Change'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid CredentialValidation {
        Name      = 'Credential Validation'
        AuditFlag = 'Success And Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid GroupMemberShip {
        Name      = 'Group Membership'
        AuditFlag = 'Success'
        Ensure    = 'Present'
    }

    AuditPolicyGuid OtherObjectAccess {
        Name      = 'Other Object Access Events'
        AuditFlag = 'Success and Failure'
        Ensure    = 'Present'
    }

    AuditPolicyGuid MPSSVCRuleLevelPolicyChange {
        Name      = 'MPSSVC Rule-Level Policy Change'
        AuditFlag = 'Success and Failure'
        Ensure    = 'Present'
    }
}
