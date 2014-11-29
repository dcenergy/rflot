HTMLWidgets.widget({

  name: "flot",

  type: "output",

  initialize: function(el, width, height) { 
    return {};
  },

  resize: function(el, width, height, instance) {
    if (instance.flot)
      instance.flot.resize();
  },

  renderValue: function(el, x, instance) {
    
    var self = this;
    
    var series = x.series;
    var options = x.options;
    
    if (instance.flot) {
      // update exisigng instance
      // Not yet implemented 
    } else {  // create new instance

      var plot = $.plot(el,series,options);
      if(typeof(options.onClick) != 'undefined') {
        $(el).on("plotclick", options.onClick);
      }

      $(el).on("plotselected", function (event, ranges) {
        //What about multiple x-axes?
        $.each(plot.getXAxes(), function(_, axis) {
          var opts = axis.options;
          opts.min = ranges.xaxis.from;
          opts.max = ranges.xaxis.to;
        });
        plot.setupGrid();
        plot.draw();
        plot.clearSelection();
      });

      $(el).on("dblclick", function () {
        //What about multiple x-axes?
        $.each(plot.getXAxes(), function(_, axis) {
          var opts = axis.options;
          opts.min = null;
          opts.max = null;
        });
        plot.setupGrid();
        plot.draw();
        plot.clearSelection();
      });
      instance.flot = plot;
    }
  },
});
