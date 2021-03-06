#
# Module manifest for module 'PSGitflow.Workflow'
#
# Generated by: Artsiom Krot
#
# Generated on: 12.10.2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSGitflow.Workflow.psm1'

# Version number of this module.
ModuleVersion = '1.3'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'a424cb30-3096-4f98-ad21-22c4d2db11dc'

# Author of this module
Author = 'Artsiom Krot'

# Company or vendor of this module
# CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2020 Artsiom Krot. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module is created for automation CI/CD processes according with the widely used workflow in Agile world - "GitFlow"
               Module provides helper routines which can be used in automation of CI/CD solutions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
        'New-ReleaseVersion',
        'Set-ReleaseArtifactName'
        'Invoke-GitFlowWorkflow'
        )

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/artyom-krot/PSGitflow.Workflow'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '
        ## 1.0.0
        * New-ReleaseVersion function new version 1.1 defined
        * Set-ReleaseArtifactName function new version 1.0 defined
        * Invoke-GitFlowWorkflow function new version 1.0 defined
        * Create parameter file parameters.ps1 with default parameters values.

        ## 1.1.0
        * quick hotfix in New-ReleaseVersion function. New version 1.2 defined

        ## 1.2.0
        * quick hotfix in New-ReleaseVersion function. New version 1.3 defined

        ## 1.3.0
        * added main branch name on a par with master branch
        '

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
#HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}