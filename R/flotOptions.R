#' flot options
#'
#' Add options to a flot chart. All options are completely optional. They are documented individually
#  in the
#' \href{https://github.com/flot/flot/blob/master/API.md\#plot-options}{online documentation} of the JS
#' library as accepted without validation and converted using RJSONIO::toJSON
#' 
#' 
#' @param flotChart An object instantiated using \code{\link{flotChart}})
#'  to add a series definition to.
#' @param legend list See \href{https://github.com/flot/flot/blob/master/API.md\#plot-options}{online documentation} (optional)
#' @param xaxis,yaxis,xaxes,yaxes list See \href{https://github.com/flot/flot/blob/master/API.md\#plot-options}{online documentation} (optional)
#' @param series list See \href{https://github.com/flot/flot/blob/master/API.md\#plot-options}{online documentation} (optional)
#' @param grid list See \href{https://github.com/flot/flot/blob/master/API.md\#plot-options}{online documentation} (optional)
#' @param tooltip logical See \href{https://github.com/krzysu/flot.tooltip}{online documentation} (optional)
#' @param tooltipOpts list See \href{https://github.com/krzysu/flot.tooltip}{online documentation} (optional)
#' @param selection list See \href{http://www.flotcharts.org/flot/examples/selection/}{online documentation} (optional)
#' @param title list See \href{https://github.com/dcenergy/rflot/blob/master/inst/htmlwidgets/lib/flot/jquery.flot.title.js}{online documentation} (optional)
#'   
#' @return flotChart with additional series
#'   
#' @note See the 
#'   \href{http://dcenergy.github.io/rflot/}{online
#'   documentation} for additional details and examples.
#'   
#'   
#'   
#' @export
flotOptions <- function(flotChart,...) {

  lst.existing.opts = flotChart$x$options
  # merge options into attrs$options
  flotChart$x$options <- mergeLists(lst.existing.opts, list(...))
   
  # return modified flotCharth
  flotChart
}

