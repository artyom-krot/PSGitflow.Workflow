## Processing logic

### Case 1 sourceBranch  hotfix/{taskNumber}-{short description [0-9A-Za-z-]*}

Validate latest release tag in the repository. Increase patch version based on the version in most recent release tag

        hotfix branch should be created only for the release, that currently used in production. After release was deployed on production the code should be merged from release/{majorVersion}.{minorVersion} to master and tag to be applied tag=release/{majorVersion}.{minorVersion}.{patchVersion}

### Case 2 sourceBranch = release/{majorVersion}.{minorVersion}

check existance of any release tag
get the version from the current release branch

        case a. If tag is missing, apply current version from the source branch
        (Example: release/1.0  => releaseVersion  should be 1.0.0)

        case b. If tag exists, apply {majorVersion}.{minorVersion} from the tag and increase patch version.
        (Example: release/1.0 and tag=1.1.0 => release_version  should be 1.1.1)

### Case 3 sourceBranch = develop

        case a. If there is no any release/* branch, default release version 0.1.0 will be applied

        case b. If most recent release/* branch exist, apply {majorVersion} from release branch and increase minor version {minorVersion} + 1
        (Example: release/1.0 and release/1.1 branches are present => releaseVersion 1.2.0 will be generated)

        Info: patch version always should be 0 for the version from develop branch.

### Case 4 sourceBranch feature/{taskNumber}-{short description [0-9A-Za-z-]*}:

        The same logic as for develop branch will be applied, because feature/* branches should be created from develop branch only.

### Case 5 sourceBranch bugfix/{taskNumber}-{short description [0-9A-Za-z-]*}:

        case a. If bugfix branch was created from develop branch, than the same logic as for develop branch will be applied.
        (Example: develop - branche is source branch for the bugfix; most recent release branch - release/1.0 => releaseVersion 1.1.0 will be generated)

        case b. If bugfix branch was created from release/{majorVersion}.{minorVersion} branch, than version {majorVersion}.{minorVersion} 
                from the release branch will be applied and patch version will be increases {majorVersion}.{minorVersion}.1
        (Example: most recent release branch - release/1.1 => releaseVersion 1.1.1 will be generated)

### Case 6 sourceGitBranch = master:

        check existance of any release tag, get the version from the latest release tag 
        
        case a. If tag is missing, apply default initial release version
        (Example: releaseVersion will be 0.1.0)

        case b. If tag exists, apply {majorVersion}.{minorVersion} from the tag.
        (Example: tag = release/1.0.1 => release_version  should be 1.0.1).