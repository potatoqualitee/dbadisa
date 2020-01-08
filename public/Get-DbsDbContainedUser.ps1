function Get-DbsDbContainedUser {
    <#
    .SYNOPSIS
        Gets contained users for all databases

    .DESCRIPTION
        Gets contained users for all databases

    .PARAMETER SqlInstance
        The target SQL Server instance or instances. Server version must be SQL Server version 2012 or higher.

    .PARAMETER SqlCredential
        Login to the target instance using alternative credentials. Accepts PowerShell credentials (Get-Credential).

        Windows Authentication, SQL Server Authentication, Active Directory - Password, and Active Directory - Integrated are all supported.

        For MFA support, please use Connect-DbaInstance.

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

    .NOTES
        Tags: DISA, STIG
        Author: Chrissy LeMaire (@cl), netnerds.net

        Copyright: (c) 2020 by Chrissy LeMaire, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

    .EXAMPLE
        PS C:\> Get-DbsDbContainedUser -SqlInstance sql2017, sql2016, sql2012

        Gets contained users for all databases on sql2017, sql2016 and sql2012

    .EXAMPLE
        PS C:\> Get-DbsDbContainedUser -SqlInstance sql2017, sql2016, sql2012 | Export-Csv -Path D:\DISA\contained.csv -NoTypeInformation

        Exports contained users for all databases on sql2017, sql2016 and sql2012 to D:\disa\contained.csv
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [DbaInstanceParameter[]]$SqlInstance,
        [PsCredential]$SqlCredential,
        [switch]$EnableException
    )
    process {
        $databases = Get-DbaDatabase @PSBoundParameters
        foreach ($db in $databases) {
            $contained = $db.Query("SELECT Name FROM sys.database_principals WHERE type_desc = 'SQL_USER' AND authentication_type_desc = 'DATABASE';")
            foreach ($user in $contained) {
                [pscustomobject]@{
                    SqlInstance   = $db.Parent.Name
                    Database      = $db.Name
                    ContainedUser = $contained.Name
                }
            }
        }
    }
}