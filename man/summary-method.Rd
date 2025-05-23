% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SingleGroup-methods.R
\name{summary-method}
\alias{summary-method}
\alias{summary,SingleGroupClass-method}
\alias{summary,MultipleGroupClass-method}
\alias{summary,MixedClass-method}
\alias{summary,DiscreteClass-method}
\alias{summary,MixtureClass-method}
\title{Summary of model object}
\usage{
\S4method{summary}{SingleGroupClass}(
  object,
  SE = TRUE,
  rotate = "oblimin",
  Target = NULL,
  suppress = 0,
  suppress.cor = 0,
  verbose = TRUE,
  ...
)
}
\arguments{
\item{object}{an object of class \code{SingleGroupClass},
\code{MultipleGroupClass}, or \code{MixedClass}}

\item{SE}{logical; include the standard errors for the
standardized loadings? Requires the initial model to have included
and estimated of the asymptotic covariance matrix (via, for instance,
\code{mirt(..., SE = TRUE)}). If \code{TRUE} SEs are computed using the
delta method}

\item{rotate}{a string indicating which rotation to use for exploratory models, primarily
  from the \code{GPArotation} package (see documentation therein).

  Rotations currently supported are: \code{'promax'}, \code{'oblimin'}, \code{'varimax'},
  \code{'quartimin'}, \code{'targetT'}, \code{'targetQ'}, \code{'pstT'}, \code{'pstQ'},
  \code{'oblimax'}, \code{'entropy'}, \code{'quartimax'}, \code{'simplimax'},
  \code{'bentlerT'}, \code{'bentlerQ'}, \code{'tandemI'}, \code{'tandemII'},
  \code{'geominT'}, \code{'geominQ'}, \code{'cfT'}, \code{'cfQ'}, \code{'infomaxT'},
  \code{'infomaxQ'}, \code{'mccammon'}, \code{'bifactorT'}, \code{'bifactorQ'}.

  For models that are not exploratory this input will automatically be set to \code{'none'}}

\item{Target}{a dummy variable matrix indicting a target rotation pattern. This is required for
rotations such as \code{'targetT'}, \code{'targetQ'}, \code{'pstT'}, and \code{'pstQ'}}

\item{suppress}{a numeric value indicating which (possibly rotated) factor
loadings should be suppressed. Typical values are around .3 in most
statistical software. Default is 0 for no suppression}

\item{suppress.cor}{same as \code{suppress}, but for the correlation matrix
output}

\item{verbose}{logical; allow information to be printed to the console?}

\item{...}{additional arguments to be passed}
}
\description{
Transforms coefficients into a standardized factor loading's metric. For \code{MixedClass} objects,
the fixed and random coefficients are printed. Note that while the output to the console is rounded
to three digits, the returned list of objects is not. For simulations, use
\code{output <- summary(mod, verbose = FALSE)} to suppress the console messages.
}
\examples{

\donttest{
x <- mirt(Science, 2)
summary(x)
summary(x, rotate = 'varimax')

}
}
\references{
Chalmers, R., P. (2012). mirt: A Multidimensional Item Response Theory
Package for the R Environment. \emph{Journal of Statistical Software, 48}(6), 1-29.
\doi{10.18637/jss.v048.i06}
}
\seealso{
\code{\link{coef-method}}
}
