# FMJ Studios - `helm` Repository Contributing Guidelines

Contributions are welcome via GitHub's Pull Requests. This document outlines the process to help get your contribution
accepted.

## ⚒️ Building

The project uses the `Make` build tool with targets defined in the projects top-level [`Makefile`](../Makefile). The
file includes a debug mode that will print usage information for each `make` target when the variable `PRINT_HELP=y` is
defined. It will not execute any commands, but solely print the information so no actions will be taken on your machine.

Before running _any_ other target you should run the `tools-check` target which will look for all executables required
to operate the project locally. If any of the required executables are not found the `make` will let you know.

After you have all the necessary tools installed you will want to generate a TLS certificate authority to issue local
TLS certificates for your applications' Ingress manifests. To this you can run:

```shell
make secrets
```

This will create a new `secrets` directory in the project root and fill the directory with a `Kustomization.yaml`, a
TLS certificate as well as a private key, and a CSR (we won't need this). You will need to set up your browser to trust
this CA certificate to avoid TLS issues. For Google Chrome this can be done by navigating to the settings, then
under `Privacy and security > Security > Manage certificates > Authorities` click `Import` and select the generated
certificate.

These files will also be re-used when setting up the development environment. Said environment is facilitated
through `kind` and can be created with:

```shell
make env
```

This will set up a new local `kind`, already pre-configured to
be [ingress-ready](https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx) and
install [Jetstack's Cert-Manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager) as well as
the [Kubernetes Project's Ingress-Nginx Controller](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx).
As mentioned `cert-manager` is already set up to make use of our previously generated CA. Most charts' `ci/test-values`
already include the
necessary `Ingress` [annotations to auto-generate TLS certificates](https://cert-manager.io/docs/usage/certificate/)
with `cert-manager`. Lastly this will also insert the hostnames defined in [`scripts/hosts.sh`](../scripts/hosts.sh) in
your `/etc/hosts/` to be-able to resolve the hostnames in your browser. If your current user has root-privileges then
the script will just insert the hostnames, otherwise you will be prompt for the `sudo` password.

When developing new charts the [`Makefile`](../Makefile) provides a couple of handy targets to `template`, `install`
or `dry-install` any chart. To run them you might execute something like this:

```shell
make template CHART=charts/paperless-ngx VALUES=ci/test-values.yaml RELEASE_NAME=paperless-override
```

Take a look at each target's output with `PRINT_HELP=y` set for more in-depth information.

Updates to the `values.schema.json` and the `README.md` can be performed with the `make gen` target:

```shell
make gen CHART=charts/paperless-ngx
```

If you have made a general change like a stylistic one for the chart `README` or any change which might affect multiple
charts at a time you might want to regenerate the `values.schema.json` and `README.md` files and re-build all charts.
This can be achieved with the `all` target:

```shell
make all
```

When you're done and want to delete the cluster as well as the hostnames inserted in your `/etc/hosts` you might
run the `prune` target which will revert these changes for you.

```shell
make prune
```

## ℹ️ Commit Message Format

This specification is inspired by and supersedes the **AngularJS commit message format**.

We have very precise rules over how our Git commit messages must be formatted.
This format leads to **easier to read commit history**.

Each commit message consists of a **header**, a **body**, and a **footer**.

```text
<header>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The `header` is mandatory and must conform to the [Commit Message Header](#commit-header) format.

The `body` is mandatory for all commits except for those of type "docs".
When the body is present it must be at least 20 characters long and must conform to
the [Commit Message Body](#commit-body) format.

The `footer` is optional. The [Commit Message Footer](#commit-footer) format describes what the footer is used for and
the structure it must have.

### <a name="commit-header"></a>Commit Message Header

```text
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: charts|make|scripts|docs
  │
  └─⫸ Commit Type: build|ci|docs|feat|fix|perf|refactor|test
```

The `<type>` and `<summary>` fields are mandatory, the `(<scope>)` field is optional.

#### Type

Must be one of the following:

* **feat**: New features
* **fix**: bugfixes
* **docs**: Documentation changes
* **refactor**: Code changes which neither add features nor fix bugs
* **test**: Adding tests or improving upon existing tests
* **chore**: Miscellaneous maintenance tasks which can generally be ignored
* **build**: Changes or improvements to the build tool or to the projects dependencies (_supported Scopes_: `make`)
* **ci**: Changes to CI configuration files and scripts (_supported Scopes_: `actions`)

#### Scopes

The following is the list of supported scopes:

* `charts` - Changes affecting a multitude of charts at once
* `charts/*` - Changes affecting single charts
* `k8s` - Changes to Kubernetes manifests (development setup)
* `make` - Changes affecting the Make-based build tool
* `scripts` - Changes to scripts
* `config` - Changes to configuration files

#### Summary

Use the summary field to provide a succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize the first letter
* no dot (.) at the end

#### <a name="commit-body"></a>Commit Message Body

Just as in the summary, use the imperative, present tense: "fix" not "fixed" nor "fixes".

Explain the motivation for the change in the commit message body. This commit message should explain _why_ you are
making the change.
You can include a comparison of the previous behavior with the new behavior in order to illustrate the impact of the
change.

#### <a name="commit-footer"></a>Commit Message Footer

The footer can contain information about breaking changes and deprecations and is also the place to reference GitHub
issues, Jira tickets, and other PRs that this commit closes or is related to.
For example:

```text
BREAKING CHANGE: <breaking change summary>
<BLANK LINE>
<breaking change description + migration instructions>
<BLANK LINE>
<BLANK LINE>
Fixes #<issue number>
```

or

```text
DEPRECATED: <what is deprecated>
<BLANK LINE>
<deprecation description + recommended update path>
<BLANK LINE>
<BLANK LINE>
Closes #<pr number>
```

Breaking Change section should start with the phrase "BREAKING CHANGE: " followed by a summary of the breaking change, a
blank line, and a detailed description of the breaking change that also includes migration instructions.

Similarly, a Deprecation section should start with "DEPRECATED: " followed by a short description of what is deprecated,
a blank line, and a detailed description of the deprecation that also mentions the recommended update path.

#### Revert commits

If the commit reverts a previous commit, it should begin with `revert:`, followed by the header of the reverted commit.

The content of the commit message body should contain:

* information about the SHA of the commit being reverted in the following format: `This reverts commit <SHA>`,
* a clear description of the reason for reverting the commit message.

## ✅ How to Contribute

1. Fork this repository, develop, and test your changes
2. Add your GitHub username to the [`AUTHORS`](../.github/AUTHORS) and [`CODEOWNERS`](../.github/CODEOWNERS) files
3. Submit a pull request

_**NOTE**_: In order to make testing and merging of PRs easier, please submit changes to multiple charts in separate
PRs.

### Technical Requirements

* Must follow [Charts best practices](https://helm.sh/docs/topics/chart_best_practices/)
* Must pass CI jobs for linting and installing changed charts with
  the [chart-testing](https://github.com/helm/chart-testing) tool
* Any change to a chart requires a version bump following [SemVer](https://semver.org/) principles.
  See [Immutability](#immutability) and [Versioning](#versioning) below

Once changes have been merged, the release job will automatically run to package and release changed charts.

### Immutability

Chart releases must be immutable. Any change to a chart warrants a chart version bump even if it is only changed to the
documentation.

### Versioning

The chart `version` should follow [SemVer](https://semver.org/).

New charts should start at `0.1.0`. They will be upgraded to a _stable_ `1.0.0` after they have been used in production
clusters for more than a month without issues. This is obviously hard to do, but as [I](https://github.com/FMJdev)
operate a cluster myself I will be taking care of this.

Any breaking (backwards incompatible) changes to a chart should:

1. Bump the MAJOR version
2. In the README, under a section called "Upgrading", describe the manual steps necessary to upgrade to the new (
   specified) MAJOR version
