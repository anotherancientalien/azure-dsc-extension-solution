Configuration SecurityPolicyVMSS
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SecurityPolicyDsc

    #Account Policies
    AccountPolicy AzureAccountPolicies {
        Name                     = "Azure Account Policies"
        Minimum_Password_Length  = 14
        Minimum_Password_Age     = 1
        Enforce_password_history = 24
    }

    #region User Rights Assignment
    UserRightsAssignment AccessThisComputerFromNetwork {
        Ensure   = 'Present'
        Identity = 'Administrators', 'Authenticated Users'
        Policy   = 'Access_this_computer_from_the_network'
    }

    UserRightsAssignment AllowLogonLocally {
        Ensure   = 'Present'
        Identity = 'Administrators'
        Policy   = 'Allow_log_on_locally'
    }

    UserRightsAssignment DenylogonAsBatch {
        Ensure   = 'Present'
        Identity = 'Guests'
        Policy   = 'Deny_log_on_as_a_batch_job'
    }

    UserRightsAssignment DenylogonAsService {
        Ensure   = 'Present'
        Identity = 'Guests'
        Policy   = 'Deny_log_on_as_a_service'
    }

    UserRightsAssignment DenylogonLocaly {
        Ensure   = 'Present'
        Identity = 'Guests'
        Policy   = 'Deny_log_on_locally'
    }

    UserRightsAssignment DenyAccessToThisComputerNetwork {
        Ensure   = 'Present'
        Identity = 'Guests'
        Policy   = 'Deny_access_to_this_computer_from_the_network'
    }

    UserRightsAssignment DenylogonRDPSvc {
        Ensure   = 'Present'
        Identity = 'Guests'
        Policy   = 'Deny_log_on_through_Remote_Desktop_Services'
    }

    UserRightsAssignment ByPassTraverseChecking {
        Ensure   = 'Present'
        Identity = 'Administrators', 'Authenticated Users', 'Backup Operators', 'Local Service', 'Network Service'
        Policy   = 'Bypass_traverse_checking'
    }

    UserRightsAssignment ShutdownTheSystem {
        Ensure   = 'Present'
        Identity = 'Administrators'
        Policy   = 'Shut_down_the_system'
    }

    UserRightsAssignment IncreaseProcessWorkSet {
        Ensure   = 'Present'
        Identity = 'Administrators', 'Local Service'
        Policy   = 'Increase_a_process_working_set'
    }
    #endregion
}
