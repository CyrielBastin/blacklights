// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
//

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require admin/inspinia.js
//= require admin/search_filter_list.js
//= require admin/event_form.js
//= require multi-select
//= require dynamic-fields-for
//= require flatpickr
//= require flatpickr/l10n/fr


$(function() {

    /*
     * Allows multiple selection of a field in forms
     */
    $('.multiple_select').multiSelect()

    /*
     * Used in forms for having a calendar with datetime data
     */
    $('#event_start_date').flatpickr({
        altInput: true,
        dateFormat: 'Y-m-d H:i',
        altFormat: 'd/m/Y, à H:i',
        enableTime: true,
        minuteIncrement: 5,
        time_24hr: true,
        locale: Flatpickr.l10ns.fr
    });
    $('#event_end_date').flatpickr({
        altInput: true,
        dateFormat: 'Y-m-d H:i',
        altFormat: 'd/m/Y, à H:i',
        enableTime: true,
        minuteIncrement: 5,
        time_24hr: true,
        locale: Flatpickr.l10ns.fr
    });
    $('#event_registration_deadline').flatpickr({
        altInput: true,
        dateFormat: 'Y-m-d H:i',
        altFormat: 'd/m/Y, à H:i',
        enableTime: true,
        minuteIncrement: 5,
        time_24hr: true,
        locale: Flatpickr.l10ns.fr
    });

});
