<#

Copyright (c) 2020 Artsiom Krot. All rights reserved..

Module Name:

    PSGitflow.Workflow

Description:

    Module is created for automation CI/CD processes according with the widely used workflow in Agile world - "GitFlow"  
    Module provides helper routines which can be used in automation of CI/CD solutions.

#>

# export function New-ReleaseVersion
. $PSScriptRoot\Functions\New-ReleaseVersion.ps1
. $PSScriptRoot\Functions\Set-ReleaseArtifactName.ps1
. $PSScriptRoot\Functions\Invoke-GitFlowWorkflow.ps1
. $PSScriptRoot\Functions\parameters.ps1

Export-ModuleMember -Function *