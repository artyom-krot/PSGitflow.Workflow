
<#PSScriptInfo

.VERSION 1.0

.GUID a9a5f5f4-95c4-4567-ad82-6a6369a78914

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
    The script is an integral part of PS.GitFlow solution (https://github.com/artyom-krot/PS.Gitflow).
    Parameters file.

#> 

# mapping parameters with environment variables
$Constants = @{
    
    # Generic constants
    SolutionName                    = "SOLUTION_NAME"
    SolutionFile                    = "SOLUTION_FILE"


    # Source Control
    Branch                          = "BRANCH_NAME"
    Commit                          = "COMMIT"


    # Build info
    BuildId                         = "BUILD_ID"


    # Versioning
    ReleaseVersion                  = "RELEASE_VERSION"


    # Build server
    RootDir                         = "ROOT_DIR"
    SrcDir                          = "SRC_DIR"


    # Paths
    SolutionFilePath                = "SOLUTION_FILE_PATH"

}

# default parameter's values
$Parameters = @{

    # Generic parameters
    SolutionName                    = "todo"
    SolutionFile                    = "$SolutionName.sln"
        
    
    # Source Control
    Branch                          = "refs/heads/develop"
    Commit                          = ""


    # Build info
    BuildId                         = "0"


    # Versioning
    ReleaseVersion                  = "0.1.0"


    # Build server
    RootDir                         = "./.."
    SrcDir                          = "$RootDir/src"


    # Paths
    SolutionFilePath                = "$SrcDir/$SolutionFile"
}
