<#PSScriptInfo

.VERSION 1.3

.GUID d8aefbbf-d092-433b-8baa-3db3256a8734

.AUTHOR Artsiom Krot

.COPYRIGHT Copyright (c) 2020 Artsiom Krot. All rights reserved.

.PROJECTURI https://github.com/artyom-krot/PSGitflow.Workflow

.RELEASENOTES 
    1.2: quick hotfix Where-Object { $_ -match "^release\/\d+\.\d+$" }
    1.3: quick hotfix Where-Object { $_ -match "^release\/\d+\.\d+$" }

Script file name:

    New-ReleaseVersion.ps1

.DESCRIPTION

    The script is an integral part of PS.GitFlow solution (https://github.com/artyom-krot/PS.Gitflow)

#>


Function New-ReleaseVersion {
<#
.SYNOPSIS
    PowerShell script for generating release version number according with the Gitflow and semver standard.
.DESCRIPTION
    This function generates release version according with the semver standards and Gitflow workflow.

    Version generation logic:
    ================================================================================================
    Case 1# branch  hotfix/{taskNumber}-{short description [0-9A-Za-z-]*}:
        Info:   hotfix branch should be created only for the release, that currently used in production. 
                After release was deployed on production the code should be merged from release/{majorVersion}.{minorVersion} to master and tag to be applied tag=release/{majorVersion}.{minorVersion}.{patchVersion}
        
        Validate latest release tag in the repository. Increase patch version based on the version in most recent release tag
    
    Case 2# branch = release/{majorVersion}.{minorVersion}:
    check existance of any release tag
    get the version from the current release branch 
        
        case a. If tag is missing, apply current version from the source branch
        (Example: release/1.0  => releaseVersion  should be 1.0.0)

        case b. If tag exists, apply {majorVersion}.{minorVersion} from the tag and increase patch version.
        (Example: release/1.0 and tag=1.1.0 => release_version  should be 1.1.1)

    Case 3# branch = develop
        case a. If there is no any release/* branch, default release version 0.1.0 will be applied

        case b. If most recent release/* branch exist, apply {majorVersion} from release branch and increase minor version {minorVersion} + 1
        (Example: release/1.0 and release/1.1 branches are present => releaseVersion 1.2.0 will be generated)

        Info: patch version always should be 0 for the version from develop branch.

        
    Case 4# branch feature/{taskNumber}-{short description [0-9A-Za-z-]*}:
        The same logic as for develop branch will be applied, because feature/* branches should be created from develop branch only.

    Case 5# branch bugfix/{taskNumber}-{short description [0-9A-Za-z-]*}:
        case a. If bugfix branch was created from develop branch, than the same logic as for develop branch will be applied.
        (Example: develop - branche is source branch for the bugfix; most recent release branch - release/1.0 => releaseVersion 1.1.0 will be generated)

        case b. If bugfix branch was created from release/{majorVersion}.{minorVersion} branch, than version {majorVersion}.{minorVersion} 
                from the release branch will be applied and patch version will be increases {majorVersion}.{minorVersion}.1
        (Example: most recent release branch - release/1.1 => releaseVersion 1.1.1 will be generated)

    Case 6# branch = master/main:
    check existance of any release tag
    get the version from the latest release tag 
        
        case a. If tag is missing, apply default initial release version
        (Example: releaseVersion will be 0.1.0)

        case b. If tag exists, apply {majorVersion}.{minorVersion} from the tag.
        (Example: tag = release/1.0.1 => release_version  should be 1.0.1)

    ================================================================================================
.INPUTS
    -rootDir <string[]>

    -branch <string[]>
    
    -commit <string[]>
.OUTPUTS
    variable $releaseVersion and environment variable RELEASE_VERSION with the same release version value
.NOTES
    
  
.EXAMPLE
    New-ReleaseVersion -rootDir C:\gitrepos\myrepo -branch refs/heads/develop -commit 1a532017421e8dsf4d3f18ec1ddc5fe4e655d575

    Major  Minor  Build  Revision
    -----  -----  -----  --------
    0      1      0      -1
#>


param(
    [parameter(Position = 0, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ -PathType Container })]
    [string]
    $rootDir,

    [parameter(Position = 1, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $branch,

    [parameter(Position = 2, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $commit
)

#region functions
Function Get-LastReleaseTag {
    
    # Ensure proper sorting in case patchVersion has more than one digit
    $semVerFormat = @{Expression={if ($_ -match '(\d+)\.(\d+).(\d+)') {[int]$Matches[3]}}; Ascending=$true}
    
    try {
        # get most recent git tag
        $lastGitTag = [array](git tag -l "release/*" | Sort-Object -Property $semVerFormat | Select-Object -Last 1)
    }
    catch {
        Write-Warning "Last git tag is not avaliable";
    }
    
    return $lastGitTag
}

#endregion functions

#region main

$initialLocation = Get-Location

Set-Location $rootDir
Write-Verbose "Root directory: $rootDir."

Write-Verbose "Processing Branch: $branch."
$sourceBranchName = $branch.Replace('refs/heads/', '')

Write-Verbose "List all avaliable remote branches for the current git repo: $rootDir"
try {
    $remoteBranchesList = @()
    git branch -r | ForEach-Object {
        $remoteBranchesList += $_.Trim()
    }
}
catch {
    $Host.UI.WriteErrorLine("Remote branches list is not avaliable!")
    Write-error "$($_.Exception.Message)"
}

# Case 1# branch  hotfix/{taskNumber}-{short description [0-9A-Za-z-]*}
if ($sourceBranchName -like "hotfix/*") {

    Write-Verbose "Processing source branch name: $sourceBranchName."

    # get most recent release/ tag
    $lastGitTag = Get-LastReleaseTag

    if ($lastGitTag) {
        Write-Verbose "Last git tag: $lastGitTag"
        [version]$lastGitTagVer = $lastGitTag | split-path -leaf

        Write-Verbose "Increse Patch version accoring with the latest tag version"
        
        # define releaseVersion
        $releaseVersion = "$($lastGitTagVer.Major).$($lastGitTagVer.Minor).$($lastGitTagVer.Build + 1)"
    }
}

# Case 2# branch = release/{majorVersion}.{minorVersion}
elseif ($sourceBranchName -match "^release\/\d+\.\d+$") {
    
    Write-Verbose "Processing source branch name: $sourceBranchName."
    
    [version]$releaseVersion = $sourceBranchName | split-path -leaf
    
    Write-Verbose "Current release version $releaseVersion"

    # define releaseVersion
    [version]$releaseVersion = "$($releaseVersion.Major).$($releaseVersion.Minor).0"

    # get most recent release/ tag
    $lastGitTag = Get-LastReleaseTag

    if ($lastGitTag) {
        Write-Verbose "Last tag: $lastGitTag"
        [version]$lastGitTagVer = $lastGitTag | split-path -leaf

        $lastGitTagCommitIdReference = git rev-list -n 1 $lastGitTag
        Write-Verbose "CommitId = $lastGitTagCommitIdReference pointing to the last tag $lastGitTag."

        if ($lastGitTagVer -ge $releaseVersion) {

            if($lastGitTagCommitIdReference -eq $commit) {
                Write-Verbose "Release version corresponds to latest tag version for the reference commitId=$($commit)"
                [version]$releaseVersion = $lastGitTagVer
            }
            else {
                Write-Verbose "Increse Patch version according with the latest tag version"
                [version]$releaseVersion = "$($lastGitTagVer.Major).$($lastGitTagVer.Minor).$($lastGitTagVer.Build +1)"
            }
        }
    }
}
# Case 3# branch = develop
# and
# Case 4# branch feature/{taskNumber}-{short description [0-9A-Za-z-]*}
elseif ($sourceBranchName -like "develop" -or $sourceBranchName -like "feature/*") {

    # Ensure proper sorting in cases when versions have more than one digit
    $semVerMajor = @{Expression={if ($_ -match '(\d+)\.(\d+)') {[int]$Matches[1]}}; Ascending=$true}
    $semVerMinor = @{Expression={if ($_ -match '(\d+)\.(\d+)') {[int]$Matches[2]}}; Ascending=$true}

    Write-Verbose "Processing source branch name: $sourceBranchName."
    
    $latestReleaseBranch = [array]($remoteBranchesList | Where-Object { $_ -match "release\/\d+\.\d+$" } | Sort-Object -Property $semVerMajor, $semVerMinor | Select-Object -Last 1)
    
    if($latestReleaseBranch)
    {
        Write-Verbose "Most recent release branch: $latestReleaseBranch"

        [version]$latestReleaseVersion = ($latestReleaseBranch | split-path -leaf)
        
        Write-Verbose "Increse minor version accoring to the most recent release branch $($latestReleaseBranch)"
        [version]$releaseVersion = "$($latestReleaseVersion.Major).$($latestReleaseVersion.Minor+1).0"
    }
    else {
        Write-Verbose "No any release/* branches detected. The default release version 0.1.0 will be applied."
        [version]$releaseVersion = "0.1.0"
    }
}

# Case 5# branch bugfix/{taskNumber}-{short description [0-9A-Za-z-]*}
elseif ($sourceBranchName -like "bugfix/*") {

    Write-Verbose "Processing source branch name: $sourceBranchName."

    # get fork point with develop branch
    try {
        $forkPoint = git merge-base --fork-point origin/develop origin/$branch
    }
    Catch {
        $_.Exception;
    }

    # exitsing forkPoint means that current bugfix branch has been created from develop branch and versioning logic develop branch should be applied
    if (-Not [string]::IsNullOrEmpty($forkPoint)) {
        # Ensure proper sorting once versions will have more than one digit
        $major = @{Expression={if ($_ -match '(\d+)\.(\d+)') {[int]$Matches[1]}}; Ascending=$true}
        $minor = @{Expression={if ($_ -match '(\d+)\.(\d+)') {[int]$Matches[2]}}; Ascending=$true}

        $latestReleaseBranch = [array]($remoteBranchesList | Where-Object { $_ -match "release\/\d+\.\d+$" } | Sort-Object -Property $major, $minor | Select-Object -Last 1)
    
        if($latestReleaseBranch)
        {
            Write-Verbose "Most recent release branch: $latestReleaseBranch"

            [version]$latestReleaseVersion = ($latestReleaseBranch | split-path -leaf)
            Write-Verbose "Increse minor version accoring to the most recent release branch $($latestReleaseBranch)"
            [version]$releaseVersion = "$($latestReleaseVersion.Major).$($latestReleaseVersion.Minor+1).0"
        }
        else {
            Write-Verbose "No any release/* branches detected. The default release version 0.1.0 will be applied."
            [version]$releaseVersion = "0.1.0"
        }
    }

    # in case bugfix branch was created from release/* branch, patch version should be increased.
    else {
        $allReleaseBranches = $remoteBranchesList.Replace("origin/","") | Where-Object { $_ -match "^release\/\d+\.\d+$" }

        foreach ($releaseBranch in $allReleaseBranches) {

            $forkPoint = git merge-base --fork-point origin/$releaseBranch origin/$branch

            # apply version according with the release branch that has fork point with bugfix branch and increase patch version
            if (-Not [string]::IsNullOrEmpty($forkPoint)) {

                Write-Verbose "Reference release branch: $releaseBranch"
                [version]$latestReleaseVersion = ($releaseBranch | split-path -leaf)

                Write-Verbose "Increse patch version accoring to the most recent release branch $($releaseBranch)"
                [version]$releaseVersion = "$($latestReleaseVersion.Major).$($latestReleaseVersion.Minor).1"
            
            }
        }
    }
}

# Case 6# branch = master
elseif ($sourceBranchName -like "master" -or $sourceBranchName -like "main") {

    Write-Verbose "Processing source branch name: $sourceBranchName."
    
    # get most recent release/ tag
    $lastGitTag = Get-LastReleaseTag

    if ($lastGitTag) {
        Write-Verbose "Last tag: $lastGitTag"
        [version]$lastGitTagVer = $lastGitTag | split-path -leaf

        $lastGitTagCommitIdReference = git rev-list -n 1 $lastGitTag
        Write-Verbose "CommitId = $lastGitTagCommitIdReference pointing to the last tag $lastGitTag."

        Write-Verbose "Release version corresponds to latest tag version for the reference commitId=$($commit)"
        [version]$releaseVersion = $lastGitTagVer

    }
    else {
        Write-Warning "No any release tags were detected in the current repository"
        Write-Verbose "Default release version 0.1.0 will be applied."
        [version]$releaseVersion = "0.1.0"
    }
}

# In case of wrong branch name was used, throw an exception
else {
    Write-Error "Type of the branch $branch could not be defined!";
    Write-Warning "Please validate branch name.";
    Exit 1;
}

Write-Verbose "Generated release version: $releaseVersion"

#get back to the previous location
Set-Location $initialLocation

# set new environment variable RELEASE_VERSION
$Env:RELEASE_VERSION = $releaseVersion

return $releaseVersion

#endregion main
}