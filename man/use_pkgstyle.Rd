\name{use_pkgstyle}
\alias{use_pkgstyle}
\title{Use the pkgstyle site style in a package}
\usage{
use_pkgstyle(path = ".")
}
\arguments{
\item{path}{The package's root folder.}
}
\value{
\code{path}, invisibly.
}
\description{
Sets up a package's pkgdown site to use the shared NODC style: writes a
starter \file{_pkgdown.yml} with \code{template: package: pkgstyle} (or says
what to add to an existing one), adds
\code{Config/Needs/website: Nonprofit-Open-Data-Collective/pkgstyle} to
\file{DESCRIPTION}, and warns about local style files that would override the
template.
}
