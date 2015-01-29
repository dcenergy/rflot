#' flot interactive plots
#' 
#' R interface to interactive  plotting using the 
#' \href{http://www.flotcharts.org/}{flot} JavaScript library.
#' 
#' @param data data.frame holding values to be plotted
#' @param width Width in pixels (optional, defaults to automatic sizing)
#' @param height Height in pixels (optional, defaults to automatic sizing)
#'   
#' @return Interactive flot plot
#'   
#' @note
#' See the \href{http://www.flotcharts.org/}{online documentation} for
#' additional details and examples.
#' 
#' @export
flotChart <- function(data, width = NULL, height = NULL) {
  
  x <- list()
  x$series <- list()
  #Some default global options
  #Interactivity enabled globally, including tooltips
  #Do not show legend by default
  #Points rather than lines/bars
  x$options <- list(grid=list(clickable=T, hoverable=T)
                    ,onClick = htmlwidgets::JS("
                      function(event,pos,flotItem) {
                        if(flotItem && typeof(Shiny) != 'undefined') {
                          Shiny.onInputChange($(this).closest('div.shiny-bound-output').attr('id') + '_selected', flotItem.dataIndex);
                        }
                      }")
                    ,legend = list(show=F)
                    ,xaxis = list(position='bottom')
                    ,yaxis = list(position='left')
                    ,tooltip=T)
  if(!is.data.frame(data)) {
    stop("flotChart: An object of class data.frame is expected for the data parameter")
  }
  attr(x, "data") <- data
#  # create widget
  htmlwidgets::createWidget(
    name = "rflot",
    x = x,
    width = width,
    height = height,
    htmlwidgets::sizingPolicy(viewer.padding = 10, browser.fill = TRUE)
  )
}


#' Shiny bindings for flot
#' 
#' Output and render functions for using flot within Shiny 
#' applications and interactive Rmd documents.
#' 
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended.
#' @param expr An expression that generates a networkD3 graph
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This 
#'   is useful if you want to save an expression in a variable.
#'   
#' @name flot-shiny
#'
#' @export
flotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "rflot", width, height)
}

#' @rdname flot-shiny
#' @export
renderFlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, flotOutput, env, quoted = TRUE)
}

