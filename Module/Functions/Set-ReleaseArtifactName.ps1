
<#PSScriptInfo

.VERSION 1.0

.GUID 697ba018-f448-4a51-911c-48723fa8b257

.AUTHOR Artsiom Krot

.COPYRIGHT Copyright (c) 2020 Artsiom Krot. All rights reserved.

.RELEASENOTES

.REQUIREDSCRIPTS New-ReleaseVersion

Script file name:

    Set-ReleaseArtifactName.ps1

#>

<# 

.DESCRIPTION 
 The script is an integral part of PS.GitFlow solution (https://github.com/artyom-krot/PS.Gitflow) 

#> 

Function Set-ReleaseArtifactName {
<#
.SYNOPSIS
    PowerShell script for setting up generalized artifact name, which contains public version number, private version number and unique identifier according with the Gitflow and semver standard.

.DESCRIPTION
    Set-ReleaseArtifactName defines generalized artifact name, like web.api.1.1.0-rc-235

.INPUTS
    -solutionId <string[]>
    -releaseVersion <string[]>
    -sourceGitBranch <string[]>
    -buildId <string[]>
.OUTPUTS
    variable $releaseArtifactName with release version 
.NOTES
    
  
.EXAMPLE
    Set-ReleaseArtifactName -solutionId "web.api" -releaseVersion "0.1.0" -sourceGitBranch refs/heads/develop -buildId "12345"

#>


param(
    [parameter(Position = 0, Mandatory = $true, HelpMessage="Short name of solution")]
    [ValidateNotNullOrEmpty()]
    [string]
    $solutionId,

    [parameter(Position = 1, Mandatory = $true, HelpMessage="release version in Semver standard")]
    [ValidateNotNullOrEmpty()]
    [version]
    $releaseVersion,

    [parameter(Position = 2, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sourceGitBranch,

    [parameter(Position = 3, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $buildId
)


#region functions
function Get-ShortBranchName (
    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sourceBranchName,

    [parameter(Mandatory = $false)]
    [int]
    $lenght = 20
){
    
    $branchName = $sourceBranchName.Replace('refs/heads/', '')
    
    if ($branchName -match "^release\/\d+\.\d+$") {
        return "rc"
    }
    else {
        $branchName = ($branchName -replace '[\W]', '').ToLower()

        if ($branchName.Length -le $lenght) {
            $lenght = $branchName.Length
        }
        $sourceBranchName = ($branchName).Substring(0, $lenght)
        return $sourceBranchName
    } 
}

#region main

$initialLocation = Get-Location

# make branch name shorter
$sourceBranchName = Get-ShortBranchName -sourceBranchName $sourceGitBranch

# generate artifact name 
$releaseArtifactName = "$solutionId.$($releaseVersion.Major).$($releaseVersion.Minor).$($releaseVersion.Build)-$SourceBranchName-$buildId"


Write-Verbose "Generated artifact name: $releaseArtifactName"

#get back to the previous location
Set-Location $initialLocation

# set new environment variable releaseVersion
$Env:releaseArtifactName = $releaseArtifactName

return $releaseArtifactName

#endregion main

}