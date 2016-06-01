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

