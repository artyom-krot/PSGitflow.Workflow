| Download |
| :------: |
| [![Download](https://img.shields.io/powershellgallery/v/PSGitflow.Workflow?color=green)](https://www.powershellgallery.com/packages/PSGitflow.Workflow/0.2)

# PSGitflow.Workflow
PowerShell module that provides helper routines which can be used in automation of CI/CD solutions for the Gitflow workflow on your projects.

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

### Key principles

* **release** branches should be created with names containing **only** major and minor versions (release/0.1) 
* with each new release branch created, development minor version will be increased (default release version for the develop brach 0.1. When release/0.1 branch created - develop version becomes 0.2 .... when release/2.4 created - develop version becomes 2.5)
* **patch version** for the develop branch always 0;
* **major/minor version** for **feature, bugfix, hotfix** remains the same as reference branch has
* **patch version** for the feature branch remains the same as reference branch has
* when **bugfix/hotfix** branches created off mainline branch, patch version will be increased

**Private version** can be generated with custom logic from **public version**.

## Workflow overview

### Multiple release branches

Release branch is considered long-term (but not permanent).
At any point of time it is possible (but not mandatory) to have several release branches, which are currently deployed on different stages in your release pipeline.

Release branch can be removed only after the newer release version is already released on go-live environment.
As an example, release/1.0 branch can be decommissioned, when release/1.1 is deployed on go-live environment, the release/1.1 branch merged into master and new tag for the current version is applied.

## Master branch

Master branch is used for reference of the most recent code version currently installed on production environment. It always reflects a production-ready state with appropriate release tag for the deployed version on production.

## Code tagging

After successful release on the go-live environment, appropriate release branch should be merged into master and tag should be manually applied with reference version number.

Tag naming on master branch contains only version on SemVer format. Proper Tag naming should be format **release/{Major}.{Minor}.{Patch}**

## Hotfix & bugfix branches

**hotfix** branch can be created from appropriate release/* branch for a version currently deployed to go-live environment.
**bugfix** branch is created in all other issue related cases. No branched should be created directly from the master, as master branch is used for reference.
**Both hotfix and bugfix branches have to be merged into a reference branch from where they were originated**

## Release change propagation

Changes are always propagated from lower release number to upper, e.g., R1 to R2, R2 to R3 and so on. The current production version is usually the lowest version to get change. Propagation process is not automated, and it might have code conflicts and should be handled by a team.

## Types of Branches that can be used

| Naming convention| Description | Time to live | Naming example |
|--|--|--|--|
| master | Usually this branch reflects a "live" state. After the release branch has been deployed on go-live environment, the code should be merged to the master branch and release tag should be manually applied. Master branch reflects the most recent code version currently installed environment to support several release versions. | Permanent | master |
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
* **{PatchVersion}** will be increased for the bugfix/hotfix branches 
* tag naming on master branch contains only public version. tag name in format **release/{Major}.{Minor}.{Patch}**

# Module's current functionality

## Invoke-GitFlowWorkflow function
The function is generic and executes all dependent functions below in sequence.

## New-ReleaseVersion function

### Applicability

Version generation can be used in CI (continuous integration) process for versioning of produced deployment artifacts and build numbers definition.
As an example, with the help of generated **release version**, **private version** can be generated in additional build step as a part of CI process.

**Private version** can contain **{releaseVersion}** and additionally **any build unique value** (like BuildId of used build tool).
In such case build artifacts can be generated with unique version. Examples:

* _**{releaseVersion}.{buildId}**_ = **0.1.0.12345**
* _**{releaseVersion}-demo.{buildId}**_ = **0.1.0-demo.12345**
* _**{releaseVersion}-demo.{buildId}**_ = **0.1.0-demo-12345**

Processing logic described [here](https://github.com/artyom-krot/PSGitflow.Workflow/blob/master/Documentation/New-ReleaseVersion.md)

## Set-ReleaseArtifactName function

### Use case

Sets the generic artifact name, based on solution name, release version, short source branch name and unique identifier.
Example: web.api.0.1.0-rc.12345, where solution name = web.api, 0.1.0 = release version, 12345 - unique identifier, like buildId.