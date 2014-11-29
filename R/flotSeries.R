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
#' @param names Character vector containing variable names to be used as part of
#'  data-set for this series.  The first two variables will be used as x, and y coordinates.
#'  Other, auxiliary variables can be used in tool-tip callbacks, for example.
#' @param group String containing a variable name to be used to transform the data-set
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
                     names = NULL,
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
    #TO DO: validation
    data
  }
  labels <- names(data)
  # get the cols where this series is located and verify that they are
  # available within the underlying dataset
  cols <- which(labels %in% names)
  if (length(cols) != length(names)) {
    stop("One or more of the specified series were not found. ",
         "Valid series names are: ", paste(labels[-1], collapse = ", "))
  }
  
  # create series object
  if(is.null(group)) {
    series <- list()
    series$data <- unname(as.matrix(data[,names, with=F]))
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
    # default the label if we need to
    if (is.null(series$label))
      series$label <- rev(names)[1]
    #for consistent series object handling across the not/grouped cases
    series<-list(series)
  } else {
    series<-sapply(unique(data[[group]]), function(str.group) {
      series.group <- list()
      #series.group$data <- unname(as.matrix(data[eval(as.name(group))==str.group,][,names,with=F]))
      series.group$data <- unname(as.matrix(subset(data,eval(as.name(group))==str.group)[,names]))
      #To/Do: Per/Group Options?
      series.group$color <- color
      series.group$label <- str.group
      series.group$lines <- lines
      series.group$bars <- bars
      series.group$points <- points
      series.group$xaxis <- xaxis
      series.group$yaxis <- yaxis
      series.group$clickable <- clickable
      series.group$hoverable <- hoverable
      series.group$shadowSize <- shadowSize
      series.group$highlightColor <- highlightColor
      series.group
    }, USE.NAMES=F, simplify=F)
  }
  flotChart$x$series <- c(flotChart$x$series, series)
  
  # return modified flotChart
  flotChart
}
