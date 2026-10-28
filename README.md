# pkgstyle

The shared pkgdown site style for Nonprofit Open Data Collective (NODC)
packages, as a [pkgdown template package](https://pkgdown.r-lib.org/articles/customise.html#template-packages).
It is the style of the
[concordance990](https://nonprofit-open-data-collective.github.io/concordance990/)
and titleclassifier sites: navy and burnt orange, Zilla Slab headings,
Source Sans 3 body text, quiet ruled tables and a light/dark switch.

## Use it in a package

```r
remotes::install_github("Nonprofit-Open-Data-Collective/pkgstyle")
pkgstyle::use_pkgstyle()     # run in the package root
pkgdown::build_site()
```

`use_pkgstyle()` writes a starter `_pkgdown.yml` (or says what to change in an
existing one) and adds `Config/Needs/website:
Nonprofit-Open-Data-Collective/pkgstyle` to `DESCRIPTION`. The one setting that
matters is:

```yaml
template:
  package: pkgstyle
```

Each package still sets its own `url`, navbar menus, articles and reference
index. Settings in a package's `_pkgdown.yml` override the template's, so
remove old `bslib` settings and `pkgdown/extra.css` when switching a site
over.

## Use it with a coding agent

`inst/agent/SKILL.md` is a [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills)
with the setup steps and the conventions of NODC sites (menus, site-only
articles, generated tables and downloads, publishing from `docs/`). Install
it once per computer:

```r
pkgstyle::install_pkgstyle_skill()   # copies it to ~/.claude/skills/nodc-pkgdown/
```

Then, in any package: *"Add pkgdown documentation and apply the pkgstyle
style."*

## What is in the package

| File | Contents |
|---|---|
| `inst/pkgdown/_pkgdown.yml` | Site defaults: Bootstrap 5, light switch, bslib colours and Google fonts, navbar type and right-hand items. |
| `inst/pkgdown/extra.scss` | The style sheet: colour tokens for light and dark mode, navbar, headings, text, code, tables, sidebar, footer, home page. |
| `inst/templates/_pkgdown.yml` | The starter file written by `use_pkgstyle()`. |
| `inst/agent/SKILL.md` | Instructions for a coding agent. |

## Changing the style

Edit `inst/pkgdown/`, bump the version, and push. Sites pick up the change
when they are rebuilt with the new version installed; their committed `docs/`
does not change until then.
