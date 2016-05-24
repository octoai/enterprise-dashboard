(function( $ ) {

  $.fn.showTrend = function( options ) {
    var settings = $.extend({}, $.fn.showTrend.defaults, options );

    $.fn.showTrend.settings = settings;

    var x = settings.counter_text;
    var counter_text_map = {};
    for (i in x) {
      p = x[i];
      counter_text_map[p.id] = p.text
    };

    $.fn.showTrend.map = counter_text_map;

    // setup the callbacks on counters
    $('#' + settings.trendfor + '_list tr').click(function(){
      selected_counter = $(this).data('counter-id');
      $.fn.showTrend.activeCounter = selected_counter;
      setActiveCounter();
    });

  };

  $.fn.showTrend.defaults = {
    trendfor: 'categories',
    counter: 0,
  };

  $.fn.showTrend.updateForTime = function(start_time, end_time) {
    var data = {
      start_time: start_time,
      end_time: end_time
    };
    setActiveCounter(data);
  };

  // activate a counter
  function setActiveCounter(data = {}) {

    // send a backend call to fetch the data
    var url = '/trends/' + $.fn.showTrend.settings.trendfor + '/' + $.fn.showTrend.activeCounter + '/';

    opts = {
      beforeSend: showLoadingRequestActive,
      contentType: 'json',
      data: data,
      dataType: 'json',
      error: showLoadingRequestError,
      method: 'GET',
      success: showTrendData,
    };
    $.ajax(url, opts);
  };

  function performDataUpdate() {

  };

  function hideLoadingRequest() {
    $('#alertbox').removeClass().html('');
  };

  function showLoadingRequestError() {
    $('#alertbox').addClass('alert').addClass('alert-danger').html('Unable to load data. Retrying...');
  }

  function showLoadingRequestActive() {
    $('#alertbox').addClass('alert').addClass('alert-info').html('Loading Data...');
  };

  function showLoadingRequestComplete() {
    debug('completed');
  };

  function showTrendData(data) {

    // update title
    var title = $.fn.showTrend.map[$.fn.showTrend.activeCounter] + ' Trend for ' + $.fn.showTrend.settings.trendtext;
    $('.bg-primary-darker').html('<h2>'+ title +'</h2>');

    var tableID = 'tableWithExportOptions';

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


  // Private function for debugging.
  function debug( obj ) {
      if ( window.console && window.console.log ) {
          window.console.log( obj );
      }
  };
})( jQuery );

