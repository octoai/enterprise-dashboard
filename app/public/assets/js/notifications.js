(function( $ ) {

  $.fn.notifications = function(options) {
    $.fn.notifications.settings = $.extend({}, $.fn.notifications.defaults, options);

    if ( $.fn.notifications.settings.actOn ) {
      $('#' + $.fn.notifications.settings.actOn + '_list tr').click(function(){
        console.log( $(this).data( $.fn.notifications.settings.dataAttr ));
        $.fn.notifications.activeFor = $(this).data($.fn.notifications.settings.dataAttr);
        $.fn.activate();
      });
    }

  };

  $.fn.activate = function(data) {
    var url = '/notification/' + $.fn.notifications.activeFor + '/';
    var opts = {
       ajaxSuccess: showChart
    };
    $.octo.ajax(url, data, opts);
  };

  $.fn.notifications.defaults = {
  };

  $.fn.notifications.updateForTime = function(start_time, end_time) {
     var data = {
       start_time: start_time,
       end_time: end_time
     };
     $.fn.activate(data);
  };

  function showChart(data) {
    var _opts = {
      chartData: data,
      chartType: 'smoothedLine',
      axisTitle: 'User Count',
      category: 'ts'
    }
    $.octo.createGraph(_opts);
    console.log(data);
  };

})(jQuery);
