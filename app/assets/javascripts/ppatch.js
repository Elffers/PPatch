$(document).ready(function() {

// borrowing tool
  $(".borrow-tool").click(function(event) {
    var tool = $(this).parents('td');
    $.ajax({
      url: $('.borrow-tool').attr("href"),
      type: 'GET',
      dataType: 'json',
      success: function(data, textStatus, xhr) {
        tool.remove();
        console.log("Tool borrowed!");
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem borrowing this tool!")
      }
    });
    return false
  });


});
