HTMLWidgets.widget({

  name: "rflot",

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
    if (instance.flot) {
      self.updatePlot(self, el, x, instance);
    } else {  // create new instance
      self.createPlot(el, x, instance);
    }
  },

  createPlot: function(el, x, instance) {
    var series = x.series;
    var options = x.options;

    var plot = $.plot(el,series,options);
    if(typeof(options.onClick) != 'undefined') {
      $(el).on("plotclick", options.onClick);
    }

    $(el).on("plotselected", function (event, ranges) {
      $.each(plot.getAxes(), function (name, axis) {
        if (axis.used && typeof(ranges[name]) != 'undefined') {
          axis.options.min = ranges[name].from;
          axis.options.max = ranges[name].to;
        }
      });
      plot.setupGrid();
      plot.draw();
      plot.clearSelection();
    });

    //Can we move this to event 'plotunselected'
    $(el).on("dblclick", function () {
      $.each(plot.getAxes(), function(_, axis) {
        var opts = axis.options;
        opts.min = null;
        opts.max = null;
      });
      plot.setupGrid();
      plot.draw();
      plot.clearSelection();
    });
    instance.flot = plot;
  },

  updatePlot: function(self, el, x, instance) {
    // update exisigng instance
    // Not yet implemented
    self.createPlot(el, x, instance);
  }

});
