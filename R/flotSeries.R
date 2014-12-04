#' flot data series
#' 
#' Add a data series to a flot chart. Note that function call is necessary and sufficient
#' for at least one series to be charted on your plot.  This API allows you to customize
#' per-series parameters, overriding global settings specified using \code{\link{flotOptions}}).
#' All parameters of the single-series object as desribed in the
#' \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} of the JS
#' library as accepted without validation and converted using RJSONIO::toJSON
#'   
#' @param flotChart An object instantiated using \code{\link{flotChart}})
#'  to add a series definition to.
#' @param x expression Evaluated in the context of the underlying data.table,
#'  used to obtain values for the x-coordinate in the series
#' @param y expression Evaluated in the context of the underlying data.table,
#' used to obtain values for the y-coordinate in the series
#'  @param extra.cols expression Possibly a vector of expressions evaluated in the context of the underlying data.table,
#'  used to obtain values included in the data-series outside of the x- or
#'  y-coordinate (optional)
#' @param group expression Evaluated in the context of hte underlying data.table, used to transform the data-set
#'  from a long, to a wide data.table. (optional)
#' @param data data.table containing an alternative source for the data in this series. (optional)
#' @param label Label to display for series (uses names[2] if not supplied). (optional)
#' @param color Color for series. The color is either a CSS color specification 
#'  (like "rgb(255, 100, 123)") or an integer that specifies which of auto-generated 
#'  colors to select, e.g. 0 will get color no. 0, etc. (optional)
#' @param lines list See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param points list See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param bars list See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param xaxis numeric See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param yaxis numeric See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param clickable logical See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param hoverable logical See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param shadowSize numeric See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#' @param highlightColor color or number See \href{https://github.com/flot/flot/blob/master/API.md\#data-format}{online documentation} (optional)
#'   
#' @return flotChart with additional series
#'   
#' @note See the 
#'   \href{http://dcenergy.com}{online
#'   documentation} for additional details and examples.
#'   
#' @export
flotSeries <- function(flotChart,
                     x = NULL,
                     y = NULL,
                     extra.cols = NULL,
                     group = NULL,
                     data = NULL,
                     color = NULL, 
                     label = NULL,
                     lines = NULL,
                     bars = NULL,
                     points = NULL,
                     xaxis = NULL,
                     yaxis = NULL,
                     clickable = F,
                     hoverable = F,
                     shadowSize = NULL,
                     highlightColor = NULL) { 
  
  # get a reference to the underlying data and labels
  #data <- attr(flotChart$x, "data")
  data<-if(is.null(data)) {
    attr(flotChart$x, "data")
  } else {
    if(!is.data.table(data)) {
      stop("flotSeries: data parameter must be NULL (default) or of class data.table")
    }
    data
  }
  lst.eval.vars<-as.list(match.call()[-1])[c('x','y', 'extra.cols', 'group')]
  #In the event that the user has not defined extra.cols or group
  lst.eval.vars<-lst.eval.vars[!is.na(names(lst.eval.vars))]
  if(!all(c('x','y') %in% names(lst.eval.vars))) {
    stop("flotSeries: Must specify expressions for both x, and y parameters")
  }
  #TODO: Validate these expressions make sense in the context of `data`
  # create series object
  if(!c('group') %in% names(lst.eval.vars)) {
    #User did not specify a grouping
    series <- list()
    tryCatch({
      series$data <- unname(sapply(lst.eval.vars[names(lst.eval.vars) %in% c('x','y')], function(x) data[,eval(x)]))
    }, error = function(e) {
      paste0(stop("flotSeries: Failed in evaluating x and/or y in the context of the underlying data.table.  Error: ", e$message))
    })
    series$color <- color
    series$label <- label
    series$lines <- lines
    series$bars <- bars
    series$points <- points
    series$xaxis <- xaxis
    series$yaxis <- yaxis
    series$clickable <- clickable
    series$hoverable <- hoverable
    series$shadowSize <- shadowSize
    series$highlightColor <- highlightColor
    if(c('extra.cols') %in% names(lst.eval.vars)) {
      series$extra_data <- as.matrix(data[,eval(lst.eval.vars$extra.cols)])
      paste0(stop("flotSeries: Failed in evaluating extra.cols in the context of the underlying data.table.  Error: ", e$message))
    }
    # default the label if we need to
    if (is.null(series$label))
      series$label <- deparse(lst.eval.vars$y)
    #for consistent series object handling across the not/grouped cases
    series<-list(series)

  } else {

    #enable legend globally
    flotChart$x$options$legend$show <- T
    #Define the series objects, one per group
    series<-sapply(unique(data[,eval(lst.eval.vars$group)]), function(this.group) {
      series.group <- list()
      tryCatch({
        series.group$data <- unname(sapply(lst.eval.vars[names(lst.eval.vars) %in% c('x','y')], function(x) data[eval(lst.eval.vars$group)==this.group,eval(x)]))
      }, error = function(e) {
        paste0(stop("flotSeries: Failed in evaluating x/y in the context of the underlying data.table.  Error: ", e$message))
      })
      #series.group$data <- unname(as.matrix(subset(data,eval(as.name(group))==str.group)[,names]))
      #To/Do: Per/Group Options?
      series.group$color <- color
      series.group$label <- this.group
      series.group$lines <- lines
      series.group$bars <- bars
      series.group$points <- points
      series.group$xaxis <- xaxis
      series.group$yaxis <- yaxis
      series.group$clickable <- clickable
      series.group$hoverable <- hoverable
      series.group$shadowSize <- shadowSize
      series.group$highlightColor <- highlightColor
      if(c('extra.cols') %in% names(lst.eval.vars)) {
        series.group$extra_data <- as.matrix(data[eval(lst.eval.vars$group)==this.group,eval(lst.eval.vars$extra.cols)])
        paste0(stop("flotSeries: Failed in evaluating extra.cols in the context of the underlying data.table.  Error: ", e$message))
      }
      series.group
    }, USE.NAMES=F, simplify=F)
  }

  #If we haven't named the axes by now, let's use the variable names for this
  #series
  if(is.null(flotChart$x$options$xaxis$axisLabel)) {
    flotChart$x$options$xaxis$axisLabel <- deparse(lst.eval.vars$x)
  }

  if(is.null(flotChart$x$options$yaxis$axisLabel)) {
    flotChart$x$options$yaxis$axisLabel <- deparse(lst.eval.vars$y)
  }

  flotChart$x$series <- c(flotChart$x$series, series)
  
  # return modified flotChart
  flotChart
}
