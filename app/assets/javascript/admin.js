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


$.jMaskGlobals.watchDataMask = true;

window.sweetAlertConfirmConfig = {
    type: 'info',
    showCancelButton: true,
    confirmButtonColor: '#DD6B55',
    confirmButtonText: 'Oui',
    cancelButtonText: 'Non'
};

$(function() {
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green'
    });

    tinyMCE.init({
        mode : "textareas",
        editor_selector : "tinymce",
        menubar:false,
        height: 600,
        plugins: "image, link",
        toolbar1: 'insertfile undo redo | styleselect fontsizeselect fontselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
    });

    lightbox.option({
        'showImageNumberLabel': false
    });

    lightbox.init();

    autosize($('textarea.auto-height'));

    $('#rental_form input[type=radio]').on('ifChecked', function(event){
        if($(this).val() === "true") {
            if($('#rental_form #reference').val().length === 0) {
                $('#rental_form #reference').val("Logement complet")
            }
        }
        else {
            if($('#rental_form #reference').val() === "Logement complet") {
                $('#rental_form #reference').val("")
            }
        }

    });

    var url = document.URL;
    var hash = url.substring(url.indexOf('#'));

    $(".nav-tabs").find("li a").each(function(key, val) {
        if (hash == $(val).attr('href')) {
            $(val).click();
        }

        $(val).click(function(ky, vl) {
            location.hash = $(this).attr('href');
        });
    });

    $('.dataTables').DataTable({
        pageLength: 25,
        responsive: true,
        language: {
            thousands: I18n.t('number.format.separator'),
            processing: "Traitement en cours...",
            search: "Rechercher&nbsp;:",
            lengthMenu: "Afficher _MENU_ &eacute;l&eacute;ments",
            info: "Affichage de l'&eacute;lement _START_ &agrave; _END_ sur _TOTAL_ &eacute;l&eacute;ments",
            infoEmpty: "Affichage de l'&eacute;lement 0 &agrave; 0 sur 0 &eacute;l&eacute;ments",
            infoFiltered: "(filtr&eacute; de _MAX_ &eacute;l&eacute;ments au total)",
            infoPostFix: "",
            loadingRecords: "Chargement en cours...",
            zeroRecords: "Aucun &eacute;l&eacute;ment &agrave; afficher",
            emptyTable: "Aucune donnée disponible dans le tableau",
            paginate: {
                first: "Premier",
                previous: "Pr&eacute;c&eacute;dent",
                next: "Suivant",
                last: "Dernier"
            },
            aria: {
                sortAscending: ": activer pour trier la colonne par ordre croissant",
                sortDescending: ": activer pour trier la colonne par ordre décroissant"
            }
        }
    });

    /* initialize the calendar
     -----------------------------------------------------------------*/
    $('#calendar').fullCalendar({
        header: {
            left: '',
            center: 'title',
            right: 'prev,next today'
        },
        contentHeight: "100",
        timeFormat: 'H:mm',
        locale: I18n.locale,
        editable: true,
        monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Decembre"],
        monthNamesShort: ["Jan","Fév","Mar","Avr","Mai","Jun","Jul","Aou","Sep","Oct","Nov","Dec"],
        dayNames: ["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"],
        dayNamesShort: ["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"],
        buttonText: {
            today: "Aujourd'hui",
            month: "Mois",
            week: "Semaine",
            day: "Jour"
        },
        firstDay: 1,
        events: [],
    });

    $('.opportunities-caroussel').flickity({
        // options
        cellAlign: 'center',
        autoPlay: 4000,
        contain: true,
        pageDots: false,
        setGallerySize: true
    });

    $('.images-carousel').flickity({
        // options
        freeScroll: true,
        wrapAround: true,
        pageDots: false,
        autoPlay: false,
        prevNextButtons: false,
    });

    $('.input-group.date').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        calendarWeeks: false,
        autoclose: true,
        language: I18n.locale,
        format: 'dd-mm-yyyy'
    });

    $('.dataTables-images').DataTable({
        pageLength: 2,
        ordering: false,
        searching: false,
        lengthChange: false,
        paging: true,
        responsive: true,
        info: false,
        language: {
            thousands: I18n.t('number.format.separator'),
            processing: "Traitement en cours...",
            search: "Rechercher&nbsp;:",
            lengthMenu: "Afficher _MENU_ &eacute;l&eacute;ments",
            info: "Affichage de l'&eacute;lement _START_ &agrave; _END_ sur _TOTAL_ &eacute;l&eacute;ments",
            infoEmpty: "Affichage de l'&eacute;lement 0 &agrave; 0 sur 0 &eacute;l&eacute;ments",
            infoFiltered: "(filtr&eacute; de _MAX_ &eacute;l&eacute;ments au total)",
            infoPostFix: "",
            loadingRecords: "Chargement en cours...",
            zeroRecords: "Aucun &eacute;l&eacute;ment &agrave; afficher",
            emptyTable: "Aucune donnée disponible dans le tableau",
            paginate: {
                first: "Premier",
                previous: "Pr&eacute;c&eacute;dent",
                next: "Suivant",
                last: "Dernier"
            }
        }
    });

    let participants = $('#issue_assigned_id').html();
    return $('#issue_rental_id').change(function() {
        var rental, escaped_rental, options;
        rental = $('#issue_rental_id :selected').text();
        if(rental) {
            escaped_rental = rental.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
            options = $(participants).filter("optgroup[label=" + escaped_rental + "]").html();
            if (options) {
                return $('#issue_assigned_id').html(options);
            } else {
                return $('#issue_assigned_id').empty();
            }
        }
        else {
            return $('#issue_assigned_id').empty();
        }

    });

});
