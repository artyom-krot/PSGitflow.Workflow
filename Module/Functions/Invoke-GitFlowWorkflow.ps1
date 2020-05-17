
<#PSScriptInfo

.VERSION 1.0

.GUID b5c71eb3-4597-433b-8e75-87fdc4aeb262

.AUTHOR Artsiom Krot

.COMPANYNAME

.COPYRIGHT Copyright (c) 2020 Artsiom Krot. All rights reserved.

.TAGS

.LICENSEURI

.PROJECTURI https://github.com/artyom-krot/PSGitflow.Workflow

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
    The script is an integral part of PS.GitFlow solution (https://github.com/artyom-krot/PS.Gitflow) 

#> 

#regions functions
Function Get-AbsoluteDirPath {
    param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]
        $dirPath
    )
    (Resolve-Path $dirPath).Path.ToString()
}


Function Get-AbsoluteFilePath {
    param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # [ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
        [string]
        $filePath
    )
    (Resolve-Path $filePath).Path.ToString()
}


Function Get-ParameterValue  {
    param(
        [parameter(Position = 0, Mandatory = $true)]
        [string]
        $parameter 
    )

    . $PSScriptroot/parameters.ps1

    $constantName = ($Constants.GetEnumerator() | Where-Object { $_.Key -eq $parameter }).Value

    $constantEnvironmentValue = (Get-Item Env:$constantName -ErrorAction SilentlyContinue).Value
    if (-Not [string]::IsNullOrEmpty($constantEnvironmentValue)) {
        Write-Verbose "Environment variable $constantName with value $constantEnvironmentValue exists."
        return $constantEnvironmentValue
    }

    elseif ($Parameters.GetEnumerator() | Where-Object { $_.Key -eq $parameter } ) {
        $value = ($parameters.GetEnumerator() | Where-Object { $_.Key -eq $parameter }).Value
        Write-Verbose "Default parameter value will be used."
        return $value
    }
}

#endregion 

#region main

Function Invoke-GitFlowWorkflow {
<#
.SYNOPSIS
    PowerShell script for generating release version number according with the Gitflow and semver standard.
.DESCRIPTION
    This is general function which triggers all dependent gitflow functions generates release version according with the semver standards and Gitflow workflow.

.INPUTS
    # Generic constants
    -SolutionName                    <string[]>
    -SolutionFile                    <string[]>
    

    # Source Control
    -Branch                          <string[]>
    -Commit                          <string[]>


    # Build info
    -BuildId                         <string[]>


    # Versioning
    -ReleaseVersion                  <string[]>

    # Build server
    -RootDir                         <string[]>
    -SrcDir                          <string[]>

    # Paths
    -SolutionFilePath                <string[]>

.OUTPUTS
    variable $releaseVersion with release version value
.NOTES
    
  
.EXAMPLE
    
    Invoke-GitFlowWorkflow -RootDir "C:\gitrepos\myrepo" -Branch "refs/heads/release/1.0" -Commit 1a532017421e8dsf4d3f18ec1ddc5fe4e655d575 -SolutionFile web.app.sln -SolutionName web.app


#>

    [CmdletBinding()]
    param(
        # Generic constants
        $SolutionName                    = (Get-ParameterValue "SolutionName"),
        $SolutionFile                    = (Get-ParameterValue "SolutionFile"),
        

        # Source Control
        $Branch                          = (Get-ParameterValue "Branch"),
        $Commit                          = (Get-ParameterValue "Commit"),


        # Build info
        $BuildId                         = (Get-ParameterValue "BuildId"),


        # Versioning
        $ReleaseVersion                  = (Get-ParameterValue "ReleaseVersion"),

        # Build server
        $RootDir                         = (Get-ParameterValue "RootDir"),
        $SrcDir                          = (Get-ParameterValue "SrcDir"),

        # Paths
        $SolutionFilePath                = (Get-ParameterValue "SolutionFilePath")

    )
    
    $PSDefaultParameterValues=@{

        # Generic parameters
        "*:solutionName"                = "$SolutionName";
        "*:solutionFile"                = "$SolutionFile";
                

        # Source Control
        "*:branch"                      = "$Branch";
        "*:commit"                      = "$Commit"


        # Build info
        "*:buildId"                     = "$BuildId"


        # Versioning
        "*:releaseVersion"              = "$ReleaseVersion";

        # Build server
        "*:rootDir"                     = Get-AbsoluteDirPath $RootDir 
        "*:srcDir"                      = Get-AbsoluteDirPath $SrcDir

        # Paths
        "*:solutionFilePath"            = Get-AbsoluteFilePath $SolutionFilePath;
    }

    Write-Verbose "Running function New-ReleaseVersion"
    New-ReleaseVersion

    Write-Verbose "Running function Set-ReleaseArtifactName"
    Set-ReleaseArtifactName -releaseVersion (Get-Item Env:\RELEASE_VERSION).Value

}

#endregion main