#' Data from 'Happy to Help?'
#'
#' A systematic review and meta-analysis of the effects of performing acts of
#' kindness on the well-being of the actor.
#'
#' @format A data.frame with 56 rows and 18 columns.
#' \tabular{lll}{
#'    \strong{study_id} \tab \code{factor} \tab Unique identifier of the study\cr
#'    \strong{effect_id} \tab \code{integer} \tab Unique identifier of the effect size\cr
#'    \strong{d} \tab \code{numeric} \tab Standardized mean difference between the control group and intervention group\cr
#'    \strong{vi} \tab \code{numeric} \tab Variance of the effect size\cr
#'    \strong{n1i} \tab \code{numeric} \tab Number of participants in the intervention group\cr
#'    \strong{n1c} \tab \code{numeric} \tab Number of participants in the control group\cr
#'    \strong{sex} \tab \code{numeric} \tab Percentage of male participants\cr
#'    \strong{age} \tab \code{numeric} \tab Mean age of participants\cr
#'    \strong{location} \tab \code{character} \tab Geographical location of the study\cr
#'    \strong{donor} \tab \code{character} \tab From what population did the donors (helpers) originate?\cr
#'    \strong{donorcode} \tab \code{factor} \tab From what population did the donors (helpers) originate? Dichotomized to Anxious or Typical\cr
#'    \strong{interventioniv} \tab \code{character} \tab Description of the intervention / independent variable\cr
#'    \strong{interventioncode} \tab \code{factor} \tab Description of the intervention / independent variable, categorized to Acts of Kindness, Prosocial Spending, or Other\cr
#'    \strong{control} \tab \code{character} \tab Description of the control condition\cr
#'    \strong{controlcode} \tab \code{factor} \tab Description of the control condition, categorized to Neutral Activity, Nothing, or Self Help (performing a kind act for oneself)\cr
#'    \strong{recipients} \tab \code{character} \tab Who were the recipients of the act of kindness?\cr
#'    \strong{outcomedv} \tab \code{character} \tab What was the outcome, or dependent variable, of the study?\cr
#'    \strong{outcomecode} \tab \code{factor} \tab What was the outcome, or dependent variable, of the study? Categorized into Happiness, Life Satisfaction, PN Affect (positive or negative), and Other
#' }
#' @references Curry, O. S., Rowland, L. A., Van Lissa, C. J., Zlotowitz, S.,
#' McAlaney, J., & Whitehouse, H. (2018). Happy to help? A systematic review and
#' meta-analysis of the effects of performing acts of kindness on the well-being
#' of the actor. Journal of Experimental Social Psychology, 76, 320-329.
#' \doi{10.1016/j.ecresq.2007.04.005}
#' @usage data(curry)
"curry"
