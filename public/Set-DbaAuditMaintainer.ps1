function Set-DbaAuditMaintainer {
    <#
    .SYNOPSIS
        Create the audit maintainer role, sets the permissions for the role, and adds logins.

        NOTE! This command revokes permz.

    .DESCRIPTION
        Create the audit maintainer role, sets the permissions for the role, and adds logins.

    .PARAMETER SqlInstance
        The target SQL Server instance or instances. Server version must be SQL Server version 2012 or higher.

    .PARAMETER SqlCredential
        Login to the target instance using alternative credentials. Accepts PowerShell credentials (Get-Credential).

        Windows Authentication, SQL Server Authentication, Active Directory - Password, and Active Directory - Integrated are all supported.

        For MFA support, please use Connect-DbaInstance.

    .PARAMETER Role
        Name to be given the audit maintainer role.

    .PARAMETER Login
        The login or logins that are to be granted permissions. This should be a Windows Group or you may violate another STIG.

    .PARAMETER WhatIf
        If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

    .NOTES
        Tags: V-79135
        Author: Chrissy LeMaire (@cl), netnerds.net

        Copyright: (c) 2020 by Chrissy LeMaire, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

    .EXAMPLE
        PS C:\> Set-DbaAuditMaintainer -SqlInstance sql2017, sql2016, sql2012 -Login "AD\SQL Admins"

        Set permissions for the SERVER_AUDIT_MAINTAINERS role on sql2017, sql2016, sql2012 for user AD\SQL Admins on Prod database.

    .EXAMPLE
        PS C:\> Set-DbaAuditMaintainer -SqlInstance sql2017, sql2016, sql2012 -Role auditmaintainers -Login "AD\SQL Admins"

        Set permissions for the auditmaintainers role on sql2017, sql2016, sql2012 for user AD\SQL Admins on Prod database.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [DbaInstanceParameter[]]$SqlInstance,
        [PsCredential]$SqlCredential,
        [string]$Role = "SERVER_AUDIT_MAINTAINERS",
        [parameter(Mandatory)]
        [string[]]$Login,
        [switch]$EnableException
    )
    process {
        foreach ($instance in $SqlInstance) {
            try {
                $server = Connect-DbaInstance -SqlInstance $instance -SqlCredential $SqlCredential -DisableException:$(-not $EnableException)

                $sql = "IF NOT EXISTS(SELECT name FROM sys.server_principals WHERE type = 'R' AND name='[$Role]') CREATE SERVER ROLE [$($Role)]" # CREATE  ROLE SERVER_AUDIT_MAINTAINERS;
                Write-PSFMessage -Level Verbose -Message $sql
                $server.Query($sql)

                $sql = "GRANT ALTER ANY SERVER AUDIT TO [$($Role)]"
                Write-PSFMessage -Level Verbose -Message $sql
                $server.Query($sql)

                foreach ($login in $server.Logins) {
                    # Not so sure about this!
                    # CONTROL SERVER, ALTER ANY DATABASE and CREATE ANY DATABASE
                    $sql = "REVOKE ALTER ANY DATABASE FROM [$($login.Name)]"
                    Write-PSFMessage -Level Verbose -Message $sql
                    $server.Query($sql)
                    $sql = "REVOKE CONTROL SERVER FROM [$($login.Name)]"
                    Write-PSFMessage -Level Verbose -Message $sql
                    $server.Query($sql)
                    $sql = "REVOKE CREATE ANY DATABASE FROM [$($login.Name)]"
                    Write-PSFMessage -Level Verbose -Message $sql
                    $server.Query($sql)
                }

                foreach ($loginname in $Login) {
                    $serverlogin = $server.Logins | Where-Object Name -eq $loginname
                    if (-not $serverlogin) {
                        if ($loginname -notmatch '\\' -and $loginname -notmatch '@') {
                            Stop-PSFFunction -Message "The only way we can create a new user is if it's Windows. Please either use a Windows account or add the user manually." -Continue
                        }
                        $serverlogin = New-DbaLogin -SqlInstance $server -Login $loginname
                    }

                    $sql = "ALTER ROLE [$($Role)] ADD MEMBER $serverlogin"
                    Write-PSFMessage -Level Verbose -Message $sql
                    $server.Refresh()
                    $server.Query($sql)

                    [pscustomobject]@{
                        SqlInstance = $instance
                        Login       = $loginname
                        Status      = "Successfully added to $Role"
                    }
                }
            } catch {
                Stop-Function -EnableException:$EnableException -Message "Failure on $($server.Name)" -ErrorRecord $_ -Continue
            }
        }
    }
}