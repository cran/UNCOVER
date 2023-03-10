% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SMC.wrap.R
\name{IBIS.logreg}
\alias{IBIS.logreg}
\title{Logistic regression iterated batch importance sampling}
\usage{
IBIS.logreg(
  X,
  y,
  options = IBIS.logreg.opts(),
  prior_mean = rep(0, ncol(X) + 1),
  prior_var = diag(ncol(X) + 1)
)
}
\arguments{
\item{X}{Co-variate matrix}

\item{y}{Binary response vector}

\item{options}{Additional arguments that can be specified for \code{IBIS.logreg}.
See \code{\link[=IBIS.logreg.opts]{IBIS.logreg.opts()}} for details. Can be ignored.}

\item{prior_mean}{Mean for the multivariate normal prior used in the SMC
sampler. See details. Defaults to the origin.}

\item{prior_var}{Variance matrix for the multivariate normal prior used in
the SMC sampler. See details. Defaults to the identity matrix.}
}
\value{
An object of class \code{"IBIS"}, which is a list consisting of:

\describe{
\item{\code{covariate_matrix}}{The co-variate matrix provided.}
\item{\code{response_vector}}{The binary response vector provided.}
\item{\code{samples}}{A matrix of samples from the posterior.}
\item{\code{log_Bayesian_evidence}}{An estimate of the log Bayesian evidence (or
normalisation constant) of the posterior.}
\item{\code{diagnostics}}{A data frame recording the features of the SMC sampler
as the observations were added.}
}

If \code{weighted==TRUE} then an additional element of the list (\code{weights}) is
added detailing the weights of the posterior samples.
}
\description{
This function uses an Iterated Batch Importance Sampling (IBIS)
scheme with batch size one to go from prior to full posterior. We
assume a Bayesian logistic regression model.
}
\details{
Details of the internal mechanisms of the SMC sampler such as the
Metropolis-Hastings MCMC resample move can be found in Emerson and Aslett
(2023) and Chopin (2002).

It is never recommended to use anything other than
\code{IBIS.logreg.opts} to provide the \code{options} argument. See
examples and \code{\link[=IBIS.logreg.opts]{IBIS.logreg.opts()}} for more information.

The prior used for the IBIS procedure will take the form of a multivariate
normal, where the parameters can be specified directly by the user. It is
however possible to override this default prior distributional form by
specifying \code{prior.override=TRUE} and providing the relevant prior functions
in \code{IBIS.logreg.opts}.
}
\examples{

\donttest{
require(graphics)
# First we generate a co-variate matrix X and binary response vector y
CM <- matrix(rnorm(200),100,2)
rv <- sample(0:1,100,replace=TRUE)

# Now we can obtain 1000 samples from the posterior from a standard
# multivariate normal prior
out.1 <- IBIS.logreg(X = CM,y = rv)
plot(out.1)
out.1$log_Bayesian_evidence

# We can specify that the samples be weighted
out.1.w <- IBIS.logreg(X = CM,y = rv,
                       options = IBIS.logreg.opts(weighted = TRUE))
out.1.w$weights
plot(out.1.w)

# We can also specify different arguments for a specific prior
out.2 <- IBIS.logreg(X = CM,y = rv,prior_mean = rep(-3,3),
                     prior_var = 0.1*diag(3))
samp.df <- data.frame(rbind(out.1$samples,out.2$samples))
colnames(samp.df) <- paste0("beta[",c(0:2),"]")
GGally::ggpairs(samp.df,
                labeller = "label_parsed",
                ggplot2::aes(color = as.factor(rep(c(1,2),each=1000))),
                upper = list(continuous = GGally::wrap("density")),
                lower = list(continuous = GGally::wrap("points",size=0.5)))
out.2$log_Bayesian_evidence
out.3 <- IBIS.logreg(X = CM,y = rv,prior_mean = rep(3,3),
                     prior_var = 0.1*diag(3))
samp.df <- data.frame(rbind(out.1$samples,out.2$samples,out.3$samples))
colnames(samp.df) <- paste0("beta[",c(0:2),"]")
GGally::ggpairs(samp.df,
                labeller = "label_parsed",
                ggplot2::aes(color = as.factor(rep(c(1,2,3),each=1000))),
                upper = list(continuous = GGally::wrap("density")),
                lower = list(continuous = GGally::wrap("points",size=0.5)))
out.3$log_Bayesian_evidence

# We can also change the prior, for example a multivariate independent
# uniform
rmviu <- function(n,a,b){
return(mapply(FUN = function(min.vec,max.vec,pn){stats::runif(pn,a,b)},
              min.vec=a,max.vec=b,MoreArgs = list(pn = n)))
}
dmviu <- function(x,a,b){
for(ii in 1:ncol(x)){
  x[,ii] <- dunif(x[,ii],a[ii],b[ii])
}
return(apply(x,1,prod))
}

out.4 <- IBIS.logreg(X = CM,y = rv,
                     options = IBIS.logreg.opts(prior.override = TRUE,
                                                rprior = rmviu,
                                                dprior = dmviu,a=rep(0,3),
                                                b=rep(1,3)))
samp.df <- data.frame(rbind(out.1$samples,out.4$samples))
colnames(samp.df) <- paste0("beta[",c(0:2),"]")
GGally::ggpairs(samp.df,
                labeller = "label_parsed",
                ggplot2::aes(color = as.factor(rep(c(1,4),each=1000))),
                upper = list(continuous = GGally::wrap("points",size=0.5)),
                lower = list(continuous = GGally::wrap("points",size=0.5)))
out.4$log_Bayesian_evidence
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
\code{\link[=IBIS.logreg.opts]{IBIS.logreg.opts()}}, \code{\link[=print.IBIS]{print.IBIS()}}, \code{\link[=predict.IBIS]{predict.IBIS()}}, \code{\link[=plot.IBIS]{plot.IBIS()}}
}
\keyword{IBIS}
\keyword{carlo}
\keyword{monte}
\keyword{sequential}
