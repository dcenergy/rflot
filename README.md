### rflot: Flot (JS) charts in [R]

The [rflot](http://dcenergy.github.io/rflot/) package is an R interface to the [Flot](http://www.flotcharts.org/) JavaScript charting library. It is a *thin* wrapper, giving the [R] user unfettered access to the parameters of the JS library.  It boasts the ability to display point, line, and bar charts and features:

- Configurable interactive features including tooltips, click handlers, as well as the ability to zoom-in on the same canvas
- Configurable axes and legends, including the ability to display data tied to multiple axes
- Ability to display grouped data
- Ability to easily produce plots in RStudio, RMarkdown or Shiny

For more details and usage examples please visit the package [homepage](http://dcenergy.github.io/rflot/).

#### Installation

rflot depends on the htmlwidgets and data.table packages, both available on
CRAN.  You can install rflot using the devtools package:

```S
devtools::install_github(c("dcenergy/rflot"))
```

#### Credits

- Much of the credit goes to the community developing the [Flot JS charting library](https://github.com/flot/flot).
- The ease with which I ported the flot JS library to [R] would not possible without the [htmlwidghets](https://github.com/ramnathv/htmlwidgets) package developed by Ramnath Vaidyanathan, in addition to members of the [RStudio](http://rstudio.com) team.
- This library is inspired by the [dygraphs](http://github.com/rstudio/dygraphs) package for plotting time-series under development by JJ Alaire.  In many ways I have structured the syntax in this package in a similar fashion, and I have borrowed some of the plumbing verbatim from there (see for example, R/utils.R:mergeLists)

##### Plugins included

- [Time series] (https://github.com/flot/flot/blob/master/jquery.flot.time.js)
- [Stacking] (https://github.com/flot/flot/blob/master/jquery.flot.stack.js)
- [Resize] (https://github.com/flot/flot/blob/master/jquery.flot.resize.js)
- [Selection] (https://github.com/flot/flot/blob/master/jquery.flot.selection.js)
- [Categories] (https://github.com/flot/flot/blob/master/jquery.flot.categories.js)
- [Tooltip] (https://github.com/krzysu/flot.tooltip/blob/master/js/jquery.flot.tooltip.js)
- [Side by side] (https://github.com/pkoltermann/SideBySideImproved/blob/master/jquery.flot.orderBars.js)
- [Axis Labels] (https://github.com/markrcote/flot-axislabels/blob/master/jquery.flot.axislabels.js)
