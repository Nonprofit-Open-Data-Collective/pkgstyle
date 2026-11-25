---
name: nodc-pkgdown
description: Set up or restyle a pkgdown documentation site for a Nonprofit Open Data Collective (NODC) R package with the shared pkgstyle template. Use when asked to "add pkgdown documentation", "apply the pkgstyle style", "use the NODC site style", or to build, restyle or add pages to a NODC package site.
---

# NODC pkgdown sites with pkgstyle

`pkgstyle` (github.com/Nonprofit-Open-Data-Collective/pkgstyle) is a pkgdown
template package. It holds the shared site style: Bootstrap 5 with a
light/dark switch, a navy navbar with a burnt-orange rule, Zilla Slab
headings, Source Sans 3 body text, Source Code Pro code, and quiet ruled
tables. A package gets all of it from one setting in `_pkgdown.yml`:

```yaml
template:
  package: pkgstyle
```

Reference sites: concordance990 and titleclassifier
(nonprofit-open-data-collective.github.io/concordance990/).

## Set up a package

1. Install the template if needed:
   `remotes::install_github("Nonprofit-Open-Data-Collective/pkgstyle")`.
2. In the package root, run `pkgstyle::use_pkgstyle()`. It writes a starter
   `_pkgdown.yml` (or says what to change in an existing one), adds
   `Config/Needs/website: Nonprofit-Open-Data-Collective/pkgstyle` to
   `DESCRIPTION`, and warns about local style files.
3. In an existing `_pkgdown.yml`, replace any `template:` block (bootstrap,
   bslib colours or fonts, light-switch) with `template: package: pkgstyle`.
   Delete `pkgdown/extra.css` / `pkgdown/extra.scss` unless the site needs
   page-specific styles that are not in the template. Settings in the
   package's own file override the template's, so leaving old ones in place
   silently undoes the shared style.
4. Make sure `_pkgdown.yml` is listed in `.Rbuildignore` (`^_pkgdown\.yml$`),
   and so are `^docs$` and `^pkgdown$`.
5. Build with `pkgdown::build_site()` and check the result (below).

## What each package sets itself

The template sets only the look and the right side of the navbar (search,
light switch, GitHub). Each package's `_pkgdown.yml` sets:

* `url:` `https://nonprofit-open-data-collective.github.io/<package>/` and
  `destination: docs`.
* `home: title:` when the package name alone is not a good page title.
* `navbar: structure: left:`. The usual order is
  `[intro, <guide menus>, reference, news]`. Group articles into dropdown
  menus with `navbar: components:` (for example "Guides" and "Data
  dictionaries") rather than one long Articles menu.
* `articles:` sections with titles, so the articles index is grouped.
* `reference:` sections with `title:` and a short `desc:` grouping functions
  by task (using the data, building it, validating it), not alphabetically.

## Content conventions

* **Vignettes vs site-only articles.** Short guides that should ship with
  the package go in `vignettes/`. Large or slow pages (data dictionaries,
  previews of whole tables) go in `vignettes/articles/`, which is listed in
  `.Rbuildignore` (`^vignettes/articles$`) and refer to them in
  `_pkgdown.yml` as `articles/<name>`.
* **Generate tables from the package, not from files.** When a page shows
  the package's data, call the package's own functions in the article so the
  page cannot drift from the package. For a download, write the file at
  build time into `docs/` (for example `docs/data/<file>.csv`, path
  `../../docs/data` from `vignettes/articles`) and link to it.
* **Large HTML from R.** When a chunk with `results = "asis"` prints a large
  HTML table, wrap the output in a raw HTML block, or pandoc reads cell text
  (blank lines, `*`, `_`, `|`) as markdown and silently drops rows:

  ````r
  cat("\n```{=html}\n", html, "\n```\n")
  ````

  Strip per-cell inline styles (`knitr::kable()` adds
  `style="text-align:left;"` to every cell) from big tables to cut page size.
* **Links in README.md.** README becomes the home page, so links to files in
  the repository (`[data.csv](data.csv)`) break on the site. Use absolute
  links to the site page or to the GitHub file instead.
* **Page-specific CSS** goes in the article (a `<style>` block from a helper),
  using the template's colour tokens so it works in dark mode:
  `var(--tc-navy)`, `--tc-accent`, `--tc-accent-ink`, `--tc-accent-wash`,
  `--tc-ink`, `--tc-ink-mid`, `--tc-ink-soft`, `--tc-rule`,
  `--tc-rule-strong`, `--tc-surface`, `--tc-ground`.

## Building and publishing

* NODC sites are published by GitHub Pages from `docs/` on `main`. Commit the
  rebuilt `docs/` with the change that caused it.
* The template is read when the site builds. After pkgstyle changes,
  reinstall it and rebuild each site to pick up the new style.
* **Windows:** pandoc is often not on the PATH. Point R at the copy bundled
  with RStudio before building:
  `Sys.setenv(RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools")`.
* A full `build_site()` can take many minutes on a large package. Run it in
  the background, or rebuild only what changed with
  `pkgdown::build_article("<name>")`, `build_home()` or `build_reference()`.
  A change to `_pkgdown.yml` (navbar, template) touches every page, so it
  needs a full build.

## Check the result

Serve `docs/` locally (for example
`httpuv::runStaticServer("docs", port = 4321)`) and open the site:

* The navbar is navy with an orange bottom rule; headings are Zilla Slab.
* The light/dark switch works and pages stay readable in dark mode.
* Every navbar link resolves; no article has an empty or broken table.
* `pkgdown::check_pkgdown()` reports no problems.
