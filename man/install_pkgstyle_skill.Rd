\name{install_pkgstyle_skill}
\alias{install_pkgstyle_skill}
\title{Install the NODC agent skills}
\usage{
install_pkgstyle_skill(dir = file.path("~", ".claude", "skills"), overwrite = TRUE)
}
\arguments{
\item{dir}{The skills folder. The default is the user-level folder, which
every project on this computer sees.}

\item{overwrite}{Replace installed copies.}
}
\value{
The paths of the installed files, invisibly.
}
\description{
Copies the Claude Code skills shipped with pkgstyle to
\file{<dir>/<skill>/SKILL.md}:
\itemize{
\item \code{nodc-pkgdown}: set up or restyle a NODC pkgdown site.
\item \code{nodc-example-code}: the house style for example code in
vignettes, articles, README and \code{@examples}.
}
}
\details{
The same skills are also published as a Claude Code plugin from this
repository, which is the better route when you work on several computers
(see the README). Use one route or the other, not both, or each skill is
listed twice.
}
