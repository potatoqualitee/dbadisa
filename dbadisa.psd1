#
# Module manifest for module 'dbadisa'
#
# Generated by: Chrissy LeMaire
#
# Generated on: 10/28/2019
#
@{
    # Version number of this module.
    ModuleVersion     = '0.1.1'

    # ID used to uniquely identify this module
    GUID              = '4a160a6e-750b-4674-aefb-110e3ae046d5'

    # Author of this module
    Author            = 'Chrissy LeMaire'

    # Company or vendor of this module
    CompanyName       = 'Chrissy LeMaire'

    # Copyright statement for this module
    Copyright         = '2019 Chrissy LeMaire'

    # Description of the functionality provided by this module
    Description       = 'DISA STIG Automation for SQL Server'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '3.0'

    # Modules that must be imported into the global environment prior to importing this module
    # @{ ModuleName = 'dbachecks'; ModuleVersion = '1.2.15' }
    RequiredModules   = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '1.0.19' },
        @{ ModuleName = 'dbatools'; ModuleVersion = '1.0.61' }
        @{ ModuleName = 'dbachecks'; ModuleVersion = '1.2.22' }
        @{ ModuleName = 'Pester'; ModuleVersion = '4.9.0' }
    )

    # Script module or binary module file associated with this manifest.
    RootModule        = 'dbadisa.psm1'

    FunctionsToExport = @(
        'Install-DbsAudit',
        'Get-DbsStig',
        'Set-DbsAcl',
        'New-DbsDocTemplate',
        'Disable-DbsSaAccount',
        'Set-DbsAllowedProtocol',
        'Disable-DbsBrowser',
        'Test-DbsInstallPath',
        'Test-DbsServiceAccount',
        'Set-DbsConnectionLimit',
        'New-DbsBaseline',
        'Get-DbsDbAuthorizedUser',
        'Compare-DbsStig',
        'Export-DbaUserPermission',
        'Get-DbsDbComputerUser',
        'Export-DbsDbTrustworthy',
        'Set-DbaDbAuditMaintainer',
        'Get-DbsDbRecoveryModel',
        'Disable-DbsDbContainment',
        'Disable-DbsMixedMode',
        'Get-DbsMixedMode',
        'Get-DbsDbContainedUser',
        'Set-DbsDbRecoveryModel'
    )

    CmdletsToExport   = @( )
    AliasesToExport   = @( )

    PrivateData       = @{
        # PSData is module packaging and gallery metadata embedded in PrivateData
        # It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
        # We had to do this because it's the only place we're allowed to extend the manifest
        # https://connect.microsoft.com/PowerShell/feedback/details/421837
        PSData = @{
            # The primary categorization of this module (from the TechNet Gallery tech tree).
            Category     = 'Security'

            # Keyword tags to help users find this module via navigations and search.
            Tags         = @('security', 'disa', 'stig', 'compliance')

            # The web address of an icon which can be used in galleries to represent this module
            IconUri      = 'https://user-images.githubusercontent.com/8278033/68308152-a886c180-00ac-11ea-880c-ef6ff99f5cd4.png'

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'False'
        }
    }
}