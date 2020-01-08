function Get-DbsMixedMode {
    <#
    .SYNOPSIS
        Gets mixed mode

    .DESCRIPTION
        Gets mixed mode

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
        PS C:\> Get-DbsMixedMode -SqlInstance sql2017, sql2016, sql2012

        Gets mixed mode on sql2017, sql2016 and sql2012
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [DbaInstanceParameter[]]$SqlInstance,
        [PsCredential]$SqlCredential,
        [switch]$EnableException
    )
    process {
        $servers = Connect-DbaInstance -SqlInstance $SqlInstance -SqlCredential $SqlCredential -DisableException:$($EnableException -eq $false)
        foreach ($server in $servers) {
            [pscustomobject]@{
                SqlInstance = $server.Name
                LoginMode   = $server.Settings.LoginMode
            }
        }
    }
}