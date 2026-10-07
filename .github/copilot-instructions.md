# 2GIS On-Premise Helm Charts — Code Review Instructions

This repository contains Helm charts for deploying 2GIS On-Premise products on Kubernetes.
Charts may optionally share a common library chart (`generic-chart`) and follow internal coding standards.

## Review Language

When performing a code review, respond in **Russian**.

## Where the rules live

- `styleguide.md` in the repository root is the primary source of chart authoring rules. If a check is not covered below or in the path-specific files, consult the styleguide.
- `.github/instructions/values.instructions.md` — rules applied when reviewing `**/values.yaml`
- `.github/instructions/templates.instructions.md` — rules applied when reviewing `**/templates/**`
- `.github/instructions/chart-yaml.instructions.md` — rules applied when reviewing `**/Chart.yaml`

The path-specific files are the review checklist for matching files: flag every violation of them. They summarize the styleguide and are not a replacement for it.

## Scope

- Review the change, not the repository: only report problems the diff introduces, or problems it leaves behind in the lines it touches. A pre-existing problem in code the diff does not touch is out of scope — do not report it, however real it is. Reading that code to judge the change is expected; reporting on it is not.
- If the change breaks something elsewhere (e.g. a removed values key used by an unchanged template, or a guard change that breaks a Secret reference in another file), that is in scope: anchor the finding at the changed line that causes it and name the affected file in the comment body.
- If the change is small and sound, say so and leave no findings. A short review is a correct outcome, not a failed one — do not pad it with remarks you would not otherwise raise.

## Repository Structure

- `charts/` — application Helm charts, one directory per chart, plus the shared `generic-chart` library
- `installer/` — helmfile-based installer for the platform. Its `*.secrets.yaml` files are sops plaintext skeletons with empty or placeholder values: the empty skeletons are by design, not a plaintext-secrets finding; a real secret committed in one is
- `changelogs/` — per-product-group changelogs (`core/`, `platform/`, `pro/`, `citylens/`, `evergis/`)
  - Breaking changes are tracked in `changelogs/<group>/*-Breaking-Changes.md`
  - `Breaking-Changes.md` at the repo root is an index that links to the group files
  - files in this directory are updated only by release scripts and must not be edited manually
- `.github/workflows/` — CI: chart linting, README regeneration check (`check-readme.yaml`), release flows
- `CONTRIBUTING.md` — branching model (Gitflow, PRs target `develop`)

## PR Checklist (mirrors `pull_request_template.md`)

The first three items describe pull request metadata (target branch, title, description), not the diff. Verify them from the pull request itself; if the information is not available to you, skip the item instead of commenting on code lines.

- PR targets `develop` branch (except urgent hotfixes, which target `master`)
- PR title starts with the service name, e.g. `navi-back: add X feature` or `[tiles-api] Upgraded version`
- PR description includes a **Changelog** section and **Issues** references
- If `values.yaml` was changed, `README.md` must be regenerated (`make prepare && make charts/<chart-name>`, Linux only); CI `check-readme.yaml` enforces this — flag it so the author fixes it before CI fails
- If a new chart is added, it has `templates/NOTES.txt` and a generated `README.md`

## Breaking Changes

When performing a code review, verify:

- Any change that removes or renames a parameter, changes a default value in a breaking way, or changes the chart API is listed in the PR description **Changelog** section (per `pull_request_template.md`). Do not ask the author to edit `changelogs/<group>/*-Breaking-Changes.md` manually — release scripts update those files from the PR description. If the PR description lacks the entry, flag it as a blocking issue.
- For renamed/removed parameters, a deprecation notice is added in `templates/NOTES.txt` instead of silently dropping them (see `templates.instructions.md`).

## Severity and comment format

Copilot labels each review comment with a severity (High/Medium/Low). Use the built-in severity instead of textual `[CRITICAL]`/`[WARNING]` prefixes:

- **High** — issues that should block the merge: the chart does not render or renders a broken deployment (missing `required` validation, guard mismatches that crash pods, hardcoded cluster-specific values), undocumented breaking changes.
- **Medium/Low** — naming, style, documentation and consistency issues.

Structure each comment as:

```
**Brief title**

Description of the issue.

**Why this matters:** explanation of impact.

**Suggested fix:** corrected example (if applicable).
```
