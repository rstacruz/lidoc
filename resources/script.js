(function() {

  function openSidebarTab(href) {
    $('#sidebar .tabs button').removeClass('active');
    $('#sidebar .tabs button[data-tab="'+href+'"]').addClass('active');

    $('#sidebar .list').hide();
    $('#sidebar .list.'+href).show();
  }

  $('#sidebar .tabs button').on('click', function() {
    var href = $(this).attr('data-tab');
    openSidebarTab(href);
  });

  $(function() {
    if (window.location.hash === '#_files') {
      openSidebarTab('files');
    }
  });

})();
