% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SingleGroup-methods.R
\name{logLik-method}
\alias{logLik-method}
\alias{logLik,SingleGroupClass-method}
\alias{logLik,MixtureClass-method}
\alias{logLik,MultipleGroupClass-method}
\alias{logLik,MixedClass-method}
\alias{logLik,DiscreteClass-method}
\title{Extract log-likelihood}
\usage{
\S4method{logLik}{SingleGroupClass}(object)
}
\arguments{
\item{object}{an object of class \code{SingleGroupClass},
\code{MultipleGroupClass}, or \code{MixedClass}}
}
\description{
Extract the observed-data log-likelihood.
}
\examples{

\donttest{
x <- mirt(Science, 1)
logLik(x)

}
}
\references{
Chalmers, R., P. (2012). mirt: A Multidimensional Item Response Theory
Package for the R Environment. \emph{Journal of Statistical Software, 48}(6), 1-29.
\doi{10.18637/jss.v048.i06}
}
