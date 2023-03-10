% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SMC.wrap.R
\name{plot.IBIS}
\alias{plot.IBIS}
\title{Plot various outputs of IBIS}
\usage{
\method{plot}{IBIS}(x, type = "samples", plot_var = NULL, diagnostic_x_axis = "full", ...)
}
\arguments{
\item{x}{Object of class \code{"IBIS"}}

\item{type}{Can be one of; \code{"samples"} for posterior visualisation,
\code{"fitted"} for co-variate visualisation or \code{"diagnostics"} for diagnostic
plots. See details. Defaults to \code{"samples"}.}

\item{plot_var}{Vector specifying which columns (or associated logistic
regression coefficients) of the co-variate matrix should be plotted. Does not
apply when \code{type=="diagnostics"}. Defaults to all columns being selected.}

\item{diagnostic_x_axis}{Only applies if \verb{"type=="diagnostics"}. Either
\code{"full"} (default) for all observations indices to be plotted on the x-axis
or \code{"minimal"} for only some observations indices to be plotted on the
x-axis.}

\item{...}{Arguments to be passed to methods}
}
\value{
No return value, called for side effects
}
\description{
Allows visualisation of many aspects of IBIS, including
co-variate, posterior and diagnostic plots.
}
\details{
If \code{type=="samples"}, the resulting plot will be a ggpairs plot
giving the coefficient densities in the diagonal, points plots of the
posterior samples in the lower triangle and contour plots in the upper
triangle.

If \verb{"type=="fitted"}, the resulting plot will be a ggpairs plot. The
diagonal entries will be two density plots, one for training data predicted
to have response 0 by the model (red) and one for training data predicted
to have response 1 by the model (green). The off-diagonal elements are
scatter-plots of the observations, given a label according to their actual
response and a colour scale based on their predicted response. If
\code{length(plot_var)==1} then the co-variate variable is plotted against it's
index and a density plot is not provided. If \code{length(plot_var)==1} then the
density plot and the scatter-plot are combined. If a predicted class (0 or
\enumerate{
\item contains less than two data points the density will not be plotted.
}

If \code{"type==diagnostics"}, the resulting plot will be a combination of three
plots; one tracking the log Bayesian evidence as observations are added to
the posterior, one tracking the effective sample size of the particles for
each step of the SMC sampler and one tracking the acceptance rate of the
Metropolis-Hastings step when a resample-move is triggered. See
Emerson and Aslett (2023) and Chopin (2002) for more details. Multiple
Metropolis-Hastings steps can be performed when a resample-move step is
triggered, and so for the acceptance rate plot observations are suffixed
with "." and then the index of current Metropolis-Hastings step. For example
the x-axis label for the acceptance rate of the 2nd Metropolis-Hastings step
which was triggered by adding observation 1 to the posterior would be
labelled "1.2". When the training data for the \code{"IBIS"} object created is
large setting \code{diagnostic_x_axis=="minimal"} is recommended as it gives a
more visually appealing output.
}
\examples{

\donttest{
require(graphics)
# First we generate a co-variate matrix X and binary response vector y
CM <- matrix(rnorm(200),100,2)
rv <- sample(0:1,100,replace=TRUE)

# Now we can obtain 1000 samples from the posterior from a standard
# multivariate normal prior and plot the results
out <- IBIS.logreg(X = CM,y = rv)
plot(out,type = "samples")
plot(out,type = "fitted")
plot(out,type = "diagnostics",diagnostic_x_axis = "minimal")

# If we only wanted to view the second co-variate
plot(out,type = "samples",plot_var = 2)
plot(out,type = "fitted",plot_var = 2)
}

}
\references{
\itemize{
\item Emerson, S.R. and Aslett, L.J.M. (2023). Joint cohort and prediction
modelling through graphical structure analysis (to be released)
\item Chopin, N. (2002). A sequential particle filter method for
static models. Biometrika, 89(3), 539-552, \doi{10.1093/biomet/89.3.539}
}
}
\seealso{
\code{\link[=IBIS.logreg]{IBIS.logreg()}}
}
\keyword{IBIS}
\keyword{plot}
