<#

Copyright (c) 2019 Artsiom Krot. All rights reserved..

Module Name:

    PSGitflow.Workflow

Description:

    Module is created for automation CI/CD processes according with the widely used workflow in Agile world - "GitFlow"  
    Module provides helper routines which can be used in automation of CI/CD solutions.

#>

# export function New-ReleaseVersion
. $PSScriptRoot\Functions\New-ReleaseVersion.ps1

Export-ModuleMember -Function *