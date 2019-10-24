# PSGitflow.Workflow
PowerShell module that provides helper routines which can be used in automation of CI/CD solutions for the Gitflow workflow on your projects.

# Current release version

0.1.0

# Contribution

Any feedback, [issues](https://github.com/artyom-krot/PSGitflow.Workflow/issues) or [pull requests](https://github.com/artyom-krot/PSGitflow.Workflow/pulls) are appreciated.

# Prerequisites

* PowerShell v5.1
* git command line

# Release strategy for the Gitflow

## Versioning overview

Versioning strategy for the git flow:
* [GitFlow for SemVer](https://medium.com/@HendrikPrinsZA/gitflow-with-semver-dde625429aca) _by [Hendrik Prinsloo](https://medium.com/@HendrikPrinsZA)_
* [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/) _by [Vincent Driessen](https://nvie.com/about/)_
* [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) _by [Atlassian](https://www.atlassian.com)_

[SemVer standard](https://semver.org/) was taken as basis.

* **MAJOR** version when you make incompatible API changes,
* **MINOR** version when you add functionality in a backwards compatible manner, and
* **PATCH** version when you make backwards compatible bug fixes.

The script generates **public version** only. **Public version** is intended for business purpose. It should contain only major, minor and patch sections.

Examples:

* 0.0.0
* 1.0.0
* 1.1.2

**Private version** can be generated with custom logic from **public version**.

## Workflow modifications

### Multiple release branches

Release branch is considered long-term (but not permanent).
At any point of time it is possible to have several release branches, which are currently deployed on different stages in your release pipeline.

Release branch can be removed only after the newer release version is already release on go-live environment. 
As an example, release/1.0 branch can be decommissioned, when release/1.3 is deployed on go-live environment. 

## Master branch

Master branch is used only for reference of the most recent code version currently installed environment.

## Code tagging

After successful release on the go-live environment, appropriate release branch should be merged into master and tag should be manually applied with reference version number.

Tag naming on master branch contains only version on SemVer format. Proper Tag naming should be format **release/{Major}.{Minor}.{Patch}**

## Hotfix & bugfix branches

**hotfix** branch can be created from appropriate release/* branch for a version currently deployed to go-live environment.
**bugfix** branch is created in all other issue related cases. No branched should be created directly from the master, as this branch is only for reference.
**Both hotfix and bugfix branches have to be merged into a reference branch from where they were originated**

## Release change propagation

Changes are always propagated from lower release number to upper, e.g., R1 to R2, R2 to R3 and so on. The current production version is usually the lowest version to get change. Propagation process is not automated, and it might have code conflicts and should be handled by a team.

## Types of Branches that can be used

| Naming convention| Description | Time to live | Naming example |
|--|--|--|--|
| master | Usually this branch reflects a "live" state. After the release branch has been deployed on go-live environment, the code should be merged to the master branch and release tag should be manually applied. Master branch is used only for reference of the most recent code version currently installed environment to support several release versions. | Permanent | master |
| develop | Active development is happening in the develop branch usually. Reflects a state with the latest delivered development changes for the next release. |Permanent | develop|
| feature/{taskNumber}-{short feature description} | feature branches are used to develop new features for the upcoming or a distant future release. |Short-term | feature/SAA-120-new-feature |
| bugfix/{taskNumber}-{short bugfix description} | Bugfix branches are like feature branches but created not for a new feature development, but to fix some detected issue in develop or release/* branches. | Short-term | bugfix/SAA-121-apifix |
| hotfix/{taskNumber}-{short hotifx description} | **hotfix** branches are like bugfix branches, but created from **release** branches and intended to fix issues in them for the release that is currently running on go-live environment. | Short-term | hotfix/SAA-122-applicationfix |
| release/{MajorVer}.{MinorVer} | New release branch is created from develop when develop reflects the desired state of the new release for the potential deployment on go-live environment.| Long-term | release/1.1 |

## Key principles

* Active development happening in **develop**
* release branches created manually and should be created with names containing only major and minor versions. (eg. release/1.0)
* when new release branch is created, develop version will be increased on the minor version. (release/1.0 created - develop version should become 1.1)
* release version for **feature, bugfix, hotfix** are the same as reference main branch has
* feature patch version remains the same as reference branch has
* {Patch} version will be increased for the bugfix/hotfix branches 
* tag naming on master branch contains only public version. tag name in format **release/{Major}.{Minor}.{Patch}**

# Module's current functionality

## New-ReleaseVersion function

**Use**: version generation can be used in CI (continuous integration) process for versioning of produced deployment artifacts.
As an example, with the help of {releaseVersion} **private version** can be created, containing {releaseVersion} and additionally any build unique value (like buildId of used build tool).
In such case build artifacts can be generated with unique version, like _**{releaseVersion}.{buildId}**_ = **0.1.0.12345**

### Processing logic

#### Case 1 sourceBranch  hotfix/{taskNumber}-{short description [0-9A-Za-z-]*}

Validate latest release tag in the repository. Increase patch version based on the version in most recent release tag

        hotfix branch should be created only for the release, that currently used in production. After release was deployed on production the code should be merged from release/{majorVersion}.{minorVersion} to master and tag to be applied tag=release/{majorVersion}.{minorVersion}.{patchVersion}

#### Case 2 sourceBranch = release/{majorVersion}.{minorVersion}

check existance of any release tag
get the version from the current release branch

        case a. If tag is missing, apply current version from the source branch
        (Example: release/1.0  => releaseVersion  should be 1.0.0)

        case b. If tag exists, apply {majorVersion}.{minorVersion} from the tag and increase patch version.
        (Example: release/1.0 and tag=1.1.0 => release_version  should be 1.1.1)

#### Case 3 sourceBranch = develop

        case a. If there is no any release/* branch, default release version 0.1.0 will be applied

        case b. If most recent release/* branch exist, apply {majorVersion} from release branch and increase minor version {minorVersion} + 1
        (Example: release/1.0 and release/1.1 branches are present => releaseVersion 1.2.0 will be generated)

        Info: patch version always should be 0 for the version from develop branch.

#### Case 4 sourceBranch feature/{taskNumber}-{short description [0-9A-Za-z-]*}:

        The same logic as for develop branch will be applied, because feature/* branches should be created from develop branch only.

#### Case 5 sourceBranch bugfix/{taskNumber}-{short description [0-9A-Za-z-]*}:

        case a. If bugfix branch was created from develop branch, than the same logic as for develop branch will be applied.
        (Example: develop - branche is source branch for the bugfix; most recent release branch - release/1.0 => releaseVersion 1.1.0 will be generated)

        case b. If bugfix branch was created from release/{majorVersion}.{minorVersion} branch, than version {majorVersion}.{minorVersion} 
                from the release branch will be applied and patch version will be increases {majorVersion}.{minorVersion}.1
        (Example: most recent release branch - release/1.1 => releaseVersion 1.1.1 will be generated)