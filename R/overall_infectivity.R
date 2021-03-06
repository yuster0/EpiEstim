#########################################################
# Calculates Lambda_t = Sum_1^t I_{t-s} * w_s           #
# with I incidence and w discrete SI distribution       #
#########################################################

#' Overall Infectivity Due To Previously Infected Individuals
#' 
#' \code{overall_infectivity} computes the overall infectivity due to previously infected individuals. 
#' 
#' @param I One of the following
#' \itemize{
#' \item{A vector (or a dataframe with a single column) of non-negative integers containing an incidence time series}
#' \item{A dataframe of non-negative integers with two columns, so that \code{I$local} contains the incidence of cases due to local transmission and \code{I$imported} contains the incidence of imported cases (with \code{I$local + I$imported} the total incidence).}
#' } 
#' Note that the cases from the first time step are always all assumed to be imported cases. 
#' @param si_distr Vector of probabilities giving the discrete distribution of the serial interval.
#' @return A vector which contains the overall infectivity \eqn{\lambda_t} at each time step
#' @details{
#' The overall infectivity \eqn{\lambda_t} at time step \eqn{t} is equal to the sum of the previously infected individuals 
#' (given by the incidence vector \eqn{I}, with \code{I=I$local + I$imported} if \eqn{I} is a matrix), 
#' weigthed by their infectivity at time \eqn{t} (given by the discrete serial interval distribution \eqn{w_k}). 
#' In mathematical terms:   
#' \cr
#' \eqn{\lambda_t = \sum_{k=1}^{t-1}I_{t-k}w_k}
#' \cr
#' }
#' @seealso \code{\link{DiscrSI}}, \code{\link{EstimateR}}
#' @author Anne Cori \email{a.cori@@imperial.ac.uk} 
#' @references Cori, A. et al. A new framework and software to estimate time-varying reproduction numbers during epidemics (AJE 2013).
#' @export
#' @examples
#' ## load data on pandemic flu in a school in 2009
#' data("Flu2009")
#' 
#' ## compute overall infectivity
#' lambda <- overall_infectivity(Flu2009$incidence, Flu2009$si_distr)
#' par(mfrow=c(2,1))
#' plot(Flu2009$incidence, type="s", xlab="time (days)", ylab="incidence")
#' title(main="Epidemic curve")
#' plot(lambda, type="s", xlab="time (days)", ylab="Infectivity")
#' title(main="Overall infectivity")
overall_infectivity <-function (I,si_distr)
{
  I <- process_I(I)
  T<-nrow(I)
  check_si_distr(si_distr, "warning")
  lambda <- vector()
  lambda[1]<-NA
  for (t in 2:T)
  {
    lambda[t] <- sum(si_distr[1:t]*rowSums(I[t:1, c("local","imported")]),na.rm=TRUE)
  }
  return(lambda)
}
