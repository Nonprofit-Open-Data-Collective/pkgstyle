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

This repository is also a Claude Code plugin marketplace. Its `nodc` plugin
holds two [skills](https://code.claude.com/docs/en/skills):

* **`nodc-pkgdown`**: set up or restyle a NODC pkgdown site. It covers the
  setup steps and the site conventions (menus, site-only articles, generated
  tables and downloads, publishing from `docs/`).
* **`nodc-example-code`**: the house style for the example code readers see
  in vignettes, articles, README and `@examples`. Long arguments are built
  first, assignments are lined up, steps get short comments, and results are
  printed as `knitr::kable()` tables.

Install the plugin once on each computer. In a Claude Code session:

```
/plugin install nodc --marketplace Nonprofit-Open-Data-Collective/pkgstyle
```

Or from a terminal:

```sh
claude plugin marketplace add Nonprofit-Open-Data-Collective/pkgstyle
claude plugin install nodc@nodc
```

Every project on that computer then sees the skills, as `nodc:nodc-pkgdown`
and `nodc:nodc-example-code`. Claude uses them when a task matches, for
example *"Add pkgdown documentation and apply the pkgstyle style"* or *"Tidy
the vignette examples"*. To pick up a new version, run
`claude plugin update nodc@nodc`, or turn on auto-update for the `nodc`
marketplace in `/plugin` (Marketplaces tab).

If you use R but not the plugin, `pkgstyle::install_pkgstyle_skill()` copies
the same two skills to `~/.claude/skills/`. Use one route or the other: with
both, each skill is listed twice.

## What is in the package

| File | Contents |
|---|---|
| `inst/pkgdown/_pkgdown.yml` | Site defaults: Bootstrap 5, light switch, bslib colours and Google fonts, navbar type and right-hand items. |
| `inst/pkgdown/extra.scss` | The style sheet: colour tokens for light and dark mode, navbar, headings, text, code, tables, sidebar, footer, home page. |
| `inst/templates/_pkgdown.yml` | The starter file written by `use_pkgstyle()`. |
| `inst/claude/skills/*/SKILL.md` | The two agent skills. |
| `inst/claude/.claude-plugin/plugin.json` | The `nodc` plugin manifest. |
| `.claude-plugin/marketplace.json` | Makes this repository a plugin marketplace. |

## Changing the style

Edit `inst/pkgdown/`, bump the version, and push. Sites pick up the change
when they are rebuilt with the new version installed; their committed `docs/`
does not change until then.

## Changing the skills

Edit `inst/claude/skills/<skill>/SKILL.md`. Then bump `version` in
`inst/claude/.claude-plugin/plugin.json` and push. Plugin users get the
change only when that version changes. Check the files with
`claude plugin validate .` before you push.
