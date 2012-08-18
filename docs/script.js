(function() {

  $('#sidebar .tabs button').on('click', function() {
    var href = $(this).attr('data-tab');

    $('#sidebar .tabs button').removeClass('active');
    $('#sidebar .tabs button[data-tab="'+href+'"]').addClass('active');

    $('#sidebar .list').hide();
    $('#sidebar .list.'+href).show();
  });

})();
