(function( $ ) {

  $.fn.octoDateRangePicker = function(options) {

    $.fn.octoDateRangePicker.settings = $.extend({}, $.fn.octoDateRangePicker.defaults, options);

    $(settings().daterangeEl).on('apply.daterangepicker', function(ev, picker){

      let start_time = picker.startDate.format('YYYY/MM/DD h:mm:ss a');
      let end_time = picker.endDate.format('YYYY/MM/DD h:mm:ss a');

      $(this).val(start_time + ' - ' + end_time);

      var ajax_opts = {
        beforeSend: showLoadingRequestActive,
        success: successCallback,
        error: showLoadingRequestError,
        contentType: 'json',
        dataType: 'json',
        data: settings().data,
        method: settings().method,
      };
      $.ajax(settings().url, ajax_opts);

    });

    $(settings().daterangeEl).daterangepicker({
      "timePicker": true,
      "opens": "left",
      "startDate": "05/11/2016",
      "endDate": "05/17/2016"
    });
  };

  // set the defaults here
  $.fn.octoDateRangePicker.defaults = {
    success: successCallback,
  };

  // success callback
  function successCallback(response) {
    if ( $.fn.octoDateRangePicker.settings.chart ) {
      var chartdata = null;
      if($.fn.octoDateRangePicker.settings.dataForChart) {
        chartdata = $.fn.octoDateRangePicker.settings.dataForChart(response);
      }
      else {
       chartdata = dataForChart(response);
      }
      updateChart(chartdata);
    }else { debug('no chart to update'); }

    if ($.fn.octoDateRangePicker.settings.tableId) {
      var tabledata = null;
      if( $.fn.octoDateRangePicker.settings.dataForTable ) {
        tabledata = $.fn.octoDateRangePicker.settings.dataForTable(response);
      }
      else {
        tabledata = dataForTable(response);
      }
      updateTable(tabledata);
    }
    else { debug('No table to display'); }
  };

  // a converter function for converting response to data for chart
  function dataForChart(response) {
    var chartData = [];
    $.each( response.data, function( index, value ) {
      json_data = {
        date: new Date(value['ts']),
        value: value['value'].toFixed(2)
      };
      chartData.push(json_data);
    });
    return chartData;
  };

  // a converter function for converting response to data for table
  function dataForTable(response) {
    return response;
  };

  // update chart
  function updateChart(data, chart = $.fn.octoDateRangePicker.settings.chart) {
    chart.dataProvider = chartData;
    chart.validateData();
  };

  // update table
  function updateTable(data) {
    var tableID = settings().tableId;

    responsiveHelper = undefined;
    breakpointDefinition = {
      tablet: 1024,
      phone: 480
    };

    var tableElement = $('#' + tableID);

    if ( $.fn.dataTable.isDataTable( tableElement ) ) {
      table = $(tableElement).DataTable();
      table.clear();
      table.rows.add(data);
      table.draw();
    }
    else {
      tableElement.dataTable({
          autoWidth      : false,
          oLanguage: {
            EmptyTable: "No data available. <a href='#faq12'>Find out why?</a>",
          },
          data: data,
          preDrawCallback: function () {
              if (!responsiveHelper) {
                  responsiveHelper = new ResponsiveDatatablesHelper(tableElement, breakpointDefinition);
              }
          },
          rowCallback    : function (nRow) {
              responsiveHelper.createExpandIcon(nRow);
          },
          drawCallback   : function (oSettings) {
              responsiveHelper.respond();
          },
      });
    }
    // Hide the loading request
    hideLoadingRequest();
  };

  function hideLoadingRequest() {
    $(settings().alertbox).removeClass().html('');
  };

  function showLoadingRequestError() {
    $(settings().alertbox).addClass('alert').addClass('alert-danger').html('Unable to load data. Retrying...');
  }

  function showLoadingRequestActive() {
    $(settings().alertbox).addClass('alert').addClass('alert-info').html('Loading Data...');
  };

  function showLoadingRequestComplete() {
    debug('completed');
  };

  function settings() {
    return $.fn.octoDateRangePicker.settings;
  };

  // Private function for debugging.
  function debug( obj ) {
      if ( window.console && window.console.log ) {
          window.console.log( obj );
      }
  };


})( jQuery );

