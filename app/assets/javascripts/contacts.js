$(function() {
  $('.ajax_contact_update').on('submit', function(e) {
    e.preventDefault();
    debugger;
    var parentElement = $(this).parent();
    $.ajax({
      url: e.target.action,
      data: $(this).serializeArray(),
      dataType: 'json',
      type: 'PUT',
      success: function(data) {
        var htmlString = "<i class='fa fa-check-circle fa-2x text-success'></i>&nbsp;<span>Updated!</span>"
        $(parentElement).html(htmlString);
      },
      error: function() {
        var htmlString = "<i class='fa fa-times-circle fa-2x text-danger'></i>&nbsp;<span>Error!</span>"
        $(parentElement).html(htmlString);
      }
    });
  })
});
