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

  /* Load file list */
  $(function() {
    if (window.location.hash === '#f') {
      openSidebarTab('files');
    }
  });

  /* Toggle */
  $(".files.list .folder").on('click', function() {
    $(this).toggleClass('expanded');
    var ul = $(this).closest('li').find('>ul');
    console.log(ul);
    ul.slideToggle(200);
  });

})();
