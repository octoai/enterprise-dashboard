(function( $ ) {

  $.octo = {};

  $.octo.ajax = function(url, data, options) {
    $.octo.ajax.settings = $.extend({}, $.octo.ajax.defaults, options);

    var opts = {
      beforeSend: showLoadingRequestActive,
      error: showLoadingRequestError,
      success: onSuccess,
      data: data,
      contentType: $.octo.ajax.settings.contentType,
      dataType: $.octo.ajax.settings.dataType,
      method: $.octo.ajax.settings.method
    };

    $.ajax(url, opts);

  };

  $.octo.ajax.defaults = {
    alertboxId: 'alertbox',
    contentType: 'json',
    dataType: 'json',
    method: 'GET'
  };

  $.octo.createGraph = function( chartData, element_id="chartdiv", chartType="column", axisTitle, category="date"){
    var balloonText = "<span>[[category]]</span><br><span style='font-size:14px'>[[title]]:<b>[[value]]</b></span>";
    $('#'+element_id).html('');

    chart = new AmCharts.AmSerialChart();
    chart.dataProvider = chartData;
    chart.categoryField = category; // By default category = date
    chart.plotAreaBorderAlpha = 0.2;
    chart.depth3D = 25; // 3D angle
    chart.angle = 30; // 3D depth

    var categoryAxis = chart.categoryAxis;
    categoryAxis.gridAlpha = 0.1;
    categoryAxis.axisAlpha = 0;
    categoryAxis.gridPosition = "start";
    categoryAxis.parseDates = true;
    categoryAxis.minPeriod = "DD";
    categoryAxis.title = "DATE";
    categoryAxis.dateFormats = [{
          period: 'fff',
          format: 'JJ:NN:SS'
      }, {
          period: 'ss',
          format: 'JJ:NN:SS'
      }, {
          period: 'mm',
          format: 'JJ:NN'
      }, {
          period: 'hh',
          format: 'JJ:NN'
      }, {
          period: 'DD',
          format: 'DD'
      }, {
          period: 'WW',
          format: 'DD'
      }, {
          period: 'MM',
          format: 'MMM'
      }, {
          period: 'YYYY',
          format: 'YYYY'
      }];

    // value
    var valueAxis = new AmCharts.ValueAxis();
    valueAxis.stackType = "regular";
    valueAxis.gridAlpha = 0.1;
    valueAxis.axisAlpha = 0;
    valueAxis.title = axisTitle;
    chart.addValueAxis(valueAxis);

    $.each(chartData[0], function( key, value) {
      if (key == category){
        // Continue leaving category axis 
      } else {
        let graph = new AmCharts.AmGraph();
        graph.title = key;
        graph.valueField = key;
        graph.type = chartType; // chartType should be like "column" or ""
        graph.balloonText = balloonText;

        if(chartType == "smoothedLine" || chartType == "line"){
          graph.bullet = "round";
          graph.lineThickness = 2;
          graph.bulletSize = 8;
          graph.bulletBorderAlpha = 1;
          graph.bulletBorderThickness = 2;
        } else if(chartType == "column"){
          graph.lineAlpha = 0;
          graph.fillAlphas = 0.5;
        } else {

        }
        chart.addGraph(graph);
      }
    });

    if(chartType == "smoothedLine" || chartType == "line"){
      var chartCursor = new AmCharts.ChartCursor();
      chartCursor.cursorAlpha = 0;
      chartCursor.cursorPosition = "mouse";
      chart.addChartCursor(chartCursor);

      var chartScrollbar = new AmCharts.ChartScrollbar();
      chart.addChartScrollbar(chartScrollbar);

      chart.creditsPosition = "bottom-right";
    } else if(chartType == "column"){
      var legend = new AmCharts.AmLegend();
      legend.borderAlpha = 0.2;
      legend.horizontalGap = 10;
      chart.addLegend(legend);
    }
    chart.write(element_id);
  };

  function showLoadingRequestActive() {
    $('#' + $.octo.ajax.settings.alertboxId).addClass('alert').addClass('alert-info').html('Loading Data...');
  };

  function showLoadingRequestError() {
    $('#' + $.octo.ajax.settings.alertboxId).addClass('alert').addClass('alert-danger').html('Unable to load data. Retrying...');
  };

  function showLoadingRequestComplete() {
    debug('completed');
  };

  function onSuccess(data) {
    if ( $.octo.ajax.settings.ajaxSuccess && typeof($.octo.ajax.settings.ajaxSuccess) === 'function') {
      $.octo.ajax.settings.ajaxSuccess(data);
    }
    else {
      debug(data);
    }
    hideLoadingRequest();
  };

  function hideLoadingRequest() {
    $('#' + $.octo.ajax.settings.alertboxId).removeClass().html('');
  };

  function debug( obj ) {
      if ( window.console && window.console.log ) {
          window.console.log( obj );
      }
  };


})(jQuery);

