% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MDIFF.R
\name{MDIFF}
\alias{MDIFF}
\title{Compute multidimensional difficulty index}
\usage{
MDIFF(x, which.items = NULL, group = NULL)
}
\arguments{
\item{x}{an object of class 'SingleGroupClass', or an object of class 'MultipleGroupClass' if a suitable
\code{group} input were supplied}

\item{which.items}{a vector indicating which items to select. If NULL is used
(the default) then MDISC will be computed for all items}

\item{group}{group argument to pass to \code{\link{extract.group}} function. Required when the input object is
a multiple-group model}
}
\description{
Returns a matrix containing the MDIFF values (Reckase, 2009). Only supported for items of class
'dich' and 'graded'.
}
\examples{
\donttest{

mod <- mirt(Science, 2)
MDIFF(mod)

mod <- mirt(expand.table(LSAT7), 2)
MDIFF(mod)

}
}
\references{
Chalmers, R., P. (2012). mirt: A Multidimensional Item Response Theory
Package for the R Environment. \emph{Journal of Statistical Software, 48}(6), 1-29.
\doi{10.18637/jss.v048.i06}

Reckase, M. D. (2009). Multidimensional Item Response Theory. Springer.
}
\seealso{
\code{\link{extract.group}}, \code{\link{MDISC}}
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\keyword{discrimination}
