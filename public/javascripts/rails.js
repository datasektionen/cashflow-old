jQuery(function ($) {
    var csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content');

    $.fn.extend({
        /**
         * Triggers a custom event on an element and returns the event result
         * this is used to get around not being able to ensure callbacks are placed
         * at the end of the chain.
         *
         * TODO: deprecate with jQuery 1.4.2 release, in favor of subscribing to our
         *       own events and placing ourselves at the end of the chain.
         */
        triggerAndReturn: function (name, data) {
            var event = new $.Event(name);
            this.trigger(event, data);

            return event.result !== false;
        },

        /**
         * Handles execution of remote calls. Provides following callbacks:
         *
         * - ajax:before   - is execute before the whole thing begings
         * - ajax:loading  - is executed before firing ajax call
         * - ajax:success  - is executed when status is success
         * - ajax:complete - is execute when status is complete
         * - ajax:failure  - is execute in case of error
         * - ajax:after    - is execute every single time at the end of ajax call 
         */
        callRemote: function () {
            var el      = this,
                method  = el.attr('method') || el.attr('data-method') || 'GET',
                url     = el.attr('action') || el.attr('href'),
                dataType  = el.attr('data-type')  || 'script';

            if (url === undefined) {
              throw "No URL specified for remote call (action or href must be present).";
            } else {
                if (el.triggerAndReturn('ajax:before')) {
                    var data = el.is('form') ? el.serializeArray() : [];
                    $.ajax({
                        url: url,
                        data: data,
                        dataType: dataType,
                        type: method.toUpperCase(),
                        beforeSend: function (xhr) {
                            el.trigger('ajax:loading', xhr);
                        },
                        success: function (data, status, xhr) {
                            el.trigger('ajax:success', [data, status, xhr]);
                        },
                        complete: function (xhr) {
                            el.trigger('ajax:complete', xhr);
                        },
                        error: function (xhr, status, error) {
                            el.trigger('ajax:failure', [xhr, status, error]);
                        }
                    });
                }

                el.trigger('ajax:after');
            }
        }
    });

    /**
     *  confirmation handler
     */
    var jqueryVersion = $().jquery;

    if ( (jqueryVersion === '1.4') || (jqueryVersion === '1.4.1') || (jqueryVersion === '1.4.2')){
      $('a[data-confirm], button[data-confirm], input[data-confirm]').live('click', function () {
          var el = $(this);
          if (el.triggerAndReturn('confirm')) {
              if (!confirm(el.attr('data-confirm'))) {
                  return false;
              }
          }
      });
    } else {
      $('body').delegate('a[data-confirm], button[data-confirm], input[data-confirm]', 'click', function () {
          var el = $(this);
          if (el.triggerAndReturn('confirm')) {
              if (!confirm(el.attr('data-confirm'))) {
                  return false;
              }
          }
      });
    }
    


    /**
     * remote handlers
     */
    $('form[data-remote]').live('submit', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    $('a[data-remote],input[data-remote]').live('click', function (e) {
        $(this).callRemote();
        e.preventDefault();
    });

    $('a[data-method]:not([data-remote])').live('click', function (e){
        var link = $(this),
            href = link.attr('href'),
            method = link.attr('data-method'),
            form = $('<form method="post" action="'+href+'"></form>'),
            metadata_input = '<input name="_method" value="'+method+'" type="hidden" />';

        if (csrf_param != null && csrf_token != null) {
          metadata_input += '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />';
        }

        form.hide()
            .append(metadata_input)
            .appendTo('body');

        e.preventDefault();
        form.submit();
    });

    /**
     * disable-with handlers
     */
    var disable_with_input_selector           = 'input[data-disable-with]',
        disable_with_form_remote_selector     = 'form[data-remote]:has('       + disable_with_input_selector + ')',
        disable_with_form_not_remote_selector = 'form:not([data-remote]):has(' + disable_with_input_selector + ')';

    var disable_with_input_function = function () {
        $(this).find(disable_with_input_selector).each(function () {
            var input = $(this);
            input.data('enable-with', input.val())
                .attr('value', input.attr('data-disable-with'))
                .attr('disabled', 'disabled');
        });
    };

    $(disable_with_form_remote_selector).live('ajax:before', disable_with_input_function);
    $(disable_with_form_not_remote_selector).live('submit', disable_with_input_function);

    $(disable_with_form_remote_selector).live('ajax:complete', function () {
        $(this).find(disable_with_input_selector).each(function () {
            var input = $(this);
            input.removeAttr('disabled')
                 .val(input.data('enable-with'));
        });
    });

});

$(document).ready(function(){
  $('.datatable').dataTable({
    "bPaginate": false,
    "bLengthChange": false,
    "bFilter": true,
    "bSort": true,
    "bInfo": false,
    "bAutoWidth": false,
    "bJQueryUI": true,
    "oLanguage": {
    	"sProcessing":   "Laddar...",
    	"sLengthMenu":   "Visa _MENU_ rader",
    	"sZeroRecords":  "Inga matchande resultat funna",
    	"sInfo":         "Visar _START_ till _END_ av totalt _TOTAL_ rader",
    	"sInfoEmpty":    "Visar 0 till 0 av totalt 0 rader",
    	"sInfoFiltered": "(filtrerade från totalt _MAX_ rader)",
    	"sInfoPostFix":  "",
    	"sSearch":       "Sök:",
    	"sUrl":          "",
    	"oPaginate": {
    		"sFirst":    "Första",
    		"sPrevious": "Föregående",
    		"sNext":     "Nästa",
    		"sLast":     "Sista"
    	}
    }
  });
  
  $("#add_purchase_item").click(function(){
    var list_items = $("#add_purchase_item").parents('ol').children('li');
    var item_fields = $(list_items).slice(list_items.length - 4, list_items.length - 1).clone();
    var new_index = parseInt($(item_fields[0]).attr('id').match(/_(\d+)_/)[1]) + 1;
    var field;
    for(var i = 0; i < 3; i++){
      $(item_fields[i]).attr('id', $(item_fields[0]).attr("id").replace(/_\d+_/, '_' + new_index + '_'));
      field = $(item_fields[i]).children("label")[0];
      $(field).attr('for', $(field).attr('for').replace(/_\d+_/, '_'+new_index+'_'));
      field = $(item_fields[i]).children()[1];
      $(field).attr('id', $(field).attr('id').replace(/_\d+_/, '_'+new_index+'_'));
      $(field).attr('name', $(field).attr('name').replace(/\[\d+\]/, '['+new_index+']'));
    }
    $("#add_purchase_item").parent('li').before($(item_fields));
  });

  $('input.ui-datepicker').datepicker({dateFormat: 'yy-mm-dd'});
})

