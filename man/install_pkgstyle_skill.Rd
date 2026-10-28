\name{install_pkgstyle_skill}
\alias{install_pkgstyle_skill}
\title{Install the agent skill for pkgstyle sites}
\usage{
install_pkgstyle_skill(dir = file.path("~", ".claude", "skills"), overwrite = TRUE)
}
\arguments{
\item{dir}{The skills folder. The default is the user-level folder, which
every project on this computer sees.}

\item{overwrite}{Replace an installed copy.}
}
\value{
The path of the installed file, invisibly.
}
\description{
Copies the Claude Code skill shipped with pkgstyle to
\file{<dir>/nodc-pkgdown/SKILL.md}. Once installed, an agent asked to "add
pkgdown documentation and apply the pkgstyle style" follows it.
}
