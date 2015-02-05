/* Flot plugin for drawing chart title onto overlay canvas

Copyright (c) 2015 D.C. Energy L.L.C.
Licensed under GPL >=v3.

The plugin supports these options:

  title: {
    text: ""
    font: object 
  }

The font object is a specification defined similar to the axis font specification.

For example, a valid specification is:

{
    size: 11,
    lineHeight: 13,
    style: "italic",
    weight: "bold",
    family: "sans-serif",
    variant: "small-caps",
    color: "#545454"
}

(https://github.com/flot/flot/blob/master/API.md#customizing-the-axes)

In [R], this translates to:
.... %>%
  flotOptions(...,title=list(text='Number of cancer cases by age group', font=list(size=20)))
*/

(function ($) {
    var options = {
      title: {
        text: "",
        font: null,
        position: "top", //Can also be "bottom"
        inside: fals //Can also be true
      }
    };

    function init(plot) {
      /*
      * In the event the user has specified a non-trivial title
      * in this hook we create space on the canvas by increasing the top offset
      * by the lineHeight quantity
      */
      plot.hooks.processOffset.push(function (plot, offset) {
        var plotOptions=plot.getOptions(),
        titleTxt = plotOptions.title.text,
        placeholder = plot.getPlaceholder(),
        fontSize = placeholder.css("font-size"),
        fontSizeDefault = fontSize ? +fontSize.replace("px", "") : 13,
        fontDefaults = {
          style: placeholder.css("font-style"),
          size: Math.round(0.8 * fontSizeDefault),
          variant: placeholder.css("font-variant"),
          weight: placeholder.css("font-weight"),
          family: placeholder.css("font-family")
        };
        if(typeof(titleTxt) === 'string' && titleTxt != "") {
          if(typeof(plotOptions.title.font) === 'object') {
            plotOptions.title.font = $.extend(true, {}, fontDefaults, plotOptions.title.font);
            if (!plotOptions.title.font.lineHeight) {
             plotOptions.title.font.lineHeight = Math.round(plotOptions.title.font.size * 1.15);
            }
          }
          if(typeof(plotOptions.title.position) == 'string' && plotOptions.title.position == 'top' && plotOptions.title.inside === false) {
            offset.top=offset.top+plotOptions.title.font.lineHeight;
          } else if(plotOptions.title.inside === false){
            offset.bottom=offset.bottom+plotOptions.title.font.lineHeight;
          }
        }
      });

      /*
      * In the event the user has specified a non-trivial title
      * in this hook we draw in the text using the overlay canvas
      * TODO: Something better than the hard-coded 5px offset from top of plot
      */

      plot.hooks.drawOverlay.push(function (plot, ctx) {
        var titleXcoord = ctx.canvas.width / 2,
          plotOptions=plot.getOptions(),
          titleTxt = plotOptions.title.text,
          placeholder = plot.getPlaceholder(),
          margin = {top:-5, bottom:-5};
        if(typeof(titleTxt) === 'string' && titleTxt != "") {
          ctx.font = plotOptions.title.font.style + " " + plotOptions.title.font.variant + " " + plotOptions.title.font.weight + " " + plotOptions.title.font.size + "px/" + plotOptions.title.font.lineHeight + "px " + plotOptions.title.font.family;
          ctx.textAlign = 'center';

          if(plotOptions.title.inside) {
            margin = {top: plotOptions.title.font.lineHeight, bottom: -plot.getPlotOffset().bottom -5};
          }

          if(typeof(plotOptions.title.position) == 'string' && plotOptions.title.position == 'top') {
            titleYcoord =  plot.getPlotOffset().top + margin.top;
          } else {
            titleYcoord =  ctx.canvas.height + margin.bottom;
          }
          ctx.fillText(titleTxt, titleXcoord, titleYcoord);
        }
      });
    }
    
    $.plot.plugins.push({
        init: init,
        options: options,
        name: 'title',
        version: '1.0'
    });
})(jQuery);
