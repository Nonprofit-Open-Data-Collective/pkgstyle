---
name: nodc-example-code
description: House style for R example code that readers see in Nonprofit Open Data Collective (NODC) packages - vignettes, pkgdown articles, README.Rmd and roxygen @examples. Use when writing, editing or cleaning up any of these in a NODC package (npmerger, peopleparser, titleclassifier, concordance990, ...), or when asked to "tidy the examples", "make the vignette code easier to read" or "apply the example code style".
---

# NODC example code style

Example code in a vignette or on a pkgdown page is read, not run. The reader
is scanning for which function to call and what to pass it. Every rule below
serves one goal: **the function calls should stand out, and the clutter around
them should get out of the way.**

These rules are for code readers see (vignettes, `vignettes/articles/`,
`README.Rmd`, roxygen `@examples`). Do not reformat package source in `R/` to
match unless asked.

Reference page: the npmerger matching article
(nonprofit-open-data-collective.github.io/npmerger/articles/matching.html).

## 1. Pull long arguments out of the call

When an argument is a long literal or a nested expression, build it on its own
line first and pass it by name. The call that matters then fits on one short
line.

```r
# Avoid
orgs <- data.table( EIN2 = sprintf("ORG-%03d", 1:400), NTEE = sample(c("E21", "E22", "P20", "B82"), 400, TRUE), SIZE = exp(rnorm(400, 14, 1.5)) )

# Prefer
EIN2  <- sprintf( "ORG-%03d", 1:400 )
NTEE  <- sample( c("E21", "E22", "P20", "B82"), 400, TRUE )
SIZE  <- exp( rnorm(400, 14, 1.5) )
FIRST <- sample( 2009:2014, 400, TRUE )

orgs <- data.table( EIN2, NTEE, SIZE, FIRST )
```

The same goes for input vectors in name-parsing examples: define `x <- c(...)`
first, then call the function on `x`. Column lists work the same way:
`vars <- c( "name", "first_name", "last_name" )`, then `d[ , vars ]`.

Watch out for data.tables: `dt[ , vars ]` looks for a column called `vars`
and fails. Use `dt[ , ..vars ]` in data.table-heavy pages (npmerger), or
`subset( dt, keep, vars )` where readers may not know data.table.

## 2. Line up runs of assignments and arguments

* A run of consecutive assignments aligns its `<-`.
* A call with more than two or three named arguments, or that does not fit in
  about 70 characters, puts one argument per line, indented two spaces, with
  the `=` signs aligned and the closing paren on its own line.
* Long vectors break one element (or one short group) per line, aligned.

```r
panel[ , `:=`(
  REAL_ASSETS   = SIZE * exp( rnorm(.N, 0, 0.1) ),
  REAL_EXPENSES = 0.6 * SIZE * exp( rnorm(.N, 0, 0.1) ),
  MARGIN        = rnorm( .N, 0.03, 0.08 ),
  EQUITY_RATIO  = runif( .N, 0.2, 0.9 )
) ]

md <-
  build_merger_data(
    years = efile_years(),
    path  = "PANEL990"
  )

x <- c( "KARA JAMES- JOHNSON",
        "ADKINS- RICEHOUSE PAULA",
        "JASON FRENN- MANAGING DIRECTOR",
        "RICK DIETZ- JAN THRU JUNE" )
```

Short calls stay on one line. Do not explode `f( x, y )` just to be
consistent.

## 3. Spaces inside the parens of the main call

The house style puts a space inside the outer parentheses of a call
(`sample( 2009:2014, 400, TRUE )`, `build_match_data( md, path = "PANEL990" )`)
and inside `[ ]` for data.table indexing (`mm$candidates$margin[ RANK <= 5 ]`,
`panel[ , ... ]`). Inner, nested calls stay tight (`exp( rnorm(400, 14, 1.5) )`),
so the outer call - the one the reader is learning - is the one with air
around it. Follow whatever an existing page already does consistently; apply
this on new or cleaned-up pages.

## 4. A comment above each step that is not self-evident

Group a chunk into steps separated by a blank line. Put a one-line lowercase
comment above any step whose purpose, cost or result is not obvious from the
code. Say what it gives you or why, not what the syntax does.

```r
# builds the full 990 panel first (several minutes)
mm <- build_match_data( md, path = "PANEL990" )

# the five closest comparison org-years for each recipient
top5 <- mm$candidates$margin[ RANK <= 5 ]
```

Good comments: slow steps, what a filter keeps, what the columns of a result
mean, why an argument is set. Skip comments that repeat the function name.

## 5. Print results as tables with knitr::kable()

Console printouts of data frames and tables (`#>` lines, wrapped columns,
`[1]` prefixes) are hard to scan on a web page. In vignettes and articles,
print tabular results with `knitr::kable()`, which pkgstyle renders as a clean
ruled table.

* **Data frames:** put inputs and outputs side by side.

  ```r
  data.frame( raw = x, cleaned = de_clutter(x) ) |> knitr::kable()
  ```

* **One-way `table()`:** name the dimension inside `table()` so the column
  header is meaningful (otherwise kable labels it `Var1` or the variable name)
  and rename `Freq` with `col.names`. Sort when order carries no meaning.

  ```r
  titles <- known_titles()

  table( type = titles$type ) |>
    sort( decreasing = TRUE ) |>
    knitr::kable( col.names = c("Title type", "Count") )
  ```

* **Two-way `table()`:** `knitr::kable()` prints it as a cross-tab directly,
  rows by the first factor, columns by the second.

  ```r
  table( first_name_pairs$type, first_name_pairs$lexicon ) |> knitr::kable()
  ```

* Long results: show the top rows (`head(n = 10)`) and say how many there
  are, rather than printing hundreds of rows.
* Keep plain console output for things that are not tables: a single value,
  a short character vector, a `str()` or `summary()` of an object.
* Roxygen `@examples` run in the console, not on a web page, so they print
  normally - no `kable()` there. Rules 1 to 4 still apply.

## 6. Check after editing

* Rebuild the page (`pkgdown::build_article("<name>")`, or `devtools::build_readme()`
  for the README) and look at it: tables render, nothing wraps badly, no chunk
  errors. See the `nodc-pkgdown` skill for building and serving the site.
* Reformatting must not change results. If a chunk's output changed, the
  edit changed the code, not just its layout - find out why.
