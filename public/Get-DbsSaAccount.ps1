function Get-DbsSaAccount {
    <#
    .SYNOPSIS
        Gets a list of non-compliant logins named 'sa' or 'sa' accounts that are still enabled

    .DESCRIPTION
        Gets a list of non-compliant logins named 'sa' or 'sa' accounts that are still enabled

    .PARAMETER SqlInstance
        The target SQL Server instance or instances

    .PARAMETER SqlCredential
        Login to the target instance using alternative credentials

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

    .NOTES
        Tags: V-79319, V-79317, NonCompliantResults
        Author: Chrissy LeMaire (@cl), netnerds.net
        Copyright: (c) 2020 by Chrissy LeMaire, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

    .EXAMPLE
        PS C:\> Get-DbsSaAccount -SqlInstance sql2017, sql2016, sql2012

        Gets a list of logins named 'sa' or 'sa' accounts that are still enabled from sql2017, sql2016, and sql2012
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [DbaInstanceParameter[]]$SqlInstance,
        [PsCredential]$SqlCredential,
        [switch]$EnableException
    )
    process {
        $accounts = Get-DbaLogin @PSBoundParameters | Where-Object Id -eq 1
        foreach ($account in $accounts) {
            if ($account.Name -eq 'sa' -or $account.IsDisabled -eq $false) {
                $account
            }
        }
    }
}