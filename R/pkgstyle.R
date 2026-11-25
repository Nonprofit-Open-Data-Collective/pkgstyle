#' Use the pkgstyle site style in a package
#'
#' Sets up a package's pkgdown site to use the shared NODC style:
#'
#' * writes a starter `_pkgdown.yml` with `template: package: pkgstyle`, or,
#'   when the file exists, tells you what to add;
#' * adds `Config/Needs/website: Nonprofit-Open-Data-Collective/pkgstyle` to
#'   `DESCRIPTION`, so a CI build installs the template;
#' * warns about local style files that would override the template.
#'
#' @param path The package's root folder.
#' @return `path`, invisibly.
#' @export
use_pkgstyle <- function(path = ".") {
  desc_path <- file.path(path, "DESCRIPTION")
  if (!file.exists(desc_path)) stop("No DESCRIPTION in ", normalizePath(path, mustWork = FALSE))
  pkg <- unname(read.dcf(desc_path, fields = "Package")[1, 1])

  # _pkgdown.yml
  yml <- file.path(path, "_pkgdown.yml")
  if (!file.exists(yml)) {
    txt <- readLines(system.file("templates", "_pkgdown.yml", package = "pkgstyle"))
    writeLines(gsub("{{package}}", pkg, txt, fixed = TRUE), yml)
    message("Wrote _pkgdown.yml")
  } else if (!any(grepl("package:\\s*pkgstyle", readLines(yml)))) {
    message("_pkgdown.yml exists. Replace its `template:` block with:\n\n",
            "template:\n  package: pkgstyle\n")
  } else {
    message("_pkgdown.yml already uses pkgstyle")
  }

  # DESCRIPTION: let CI install the template before building the site
  need <- "Nonprofit-Open-Data-Collective/pkgstyle"
  d <- readLines(desc_path)
  field <- grep("^Config/Needs/website:", d)
  if (!length(field)) {
    writeLines(c(d, paste("Config/Needs/website:", need)), desc_path)
    message("Added Config/Needs/website to DESCRIPTION")
  } else if (!any(grepl("pkgstyle", d[field:length(d)]))) {
    message("Add ", need, " to Config/Needs/website in DESCRIPTION")
  }

  # local style files override the template
  local <- file.path(path, "pkgdown", c("extra.css", "extra.scss"))
  if (any(file.exists(local))) {
    message("Local style files override the template; remove them unless needed: ",
            paste(basename(local[file.exists(local)]), collapse = ", "))
  }
  invisible(path)
}

#' Install the NODC agent skills
#'
#' Copies the Claude Code skills shipped with pkgstyle to `<dir>/<skill>/SKILL.md`:
#'
#' * `nodc-pkgdown`: set up or restyle a NODC pkgdown site.
#' * `nodc-example-code`: the house style for example code in vignettes,
#'   articles, README and `@examples`.
#'
#' The same skills are also published as a Claude Code plugin from this
#' repository, which is the better route when you work on several computers
#' (see the README). Use one route or the other, not both, or each skill is
#' listed twice.
#'
#' @param dir The skills folder. The default is the user-level folder, which
#'   every project on this computer sees.
#' @param overwrite Replace installed copies.
#' @return The paths of the installed files, invisibly.
#' @export
install_pkgstyle_skill <- function(dir = file.path("~", ".claude", "skills"), overwrite = TRUE) {
  src    <- system.file("claude", "skills", package = "pkgstyle")
  skills <- list.files(src)
  out    <- file.path(path.expand(dir), skills, "SKILL.md")

  for (i in seq_along(skills)) {
    dir.create(dirname(out[i]), recursive = TRUE, showWarnings = FALSE)
    ok <- file.copy(file.path(src, skills[i], "SKILL.md"), out[i], overwrite = overwrite)
    if (!ok) stop("Could not write ", out[i], if (!overwrite) " (it exists; use overwrite = TRUE)")
    message("Installed ", out[i])
  }
  invisible(out)
}
