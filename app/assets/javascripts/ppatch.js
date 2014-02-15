$(document).ready(function() {
  
// removing an item
  $(".borrow-tool").click(function(event) {
    var list = $(this).parents('li'); 
    $.ajax({
      url: $('.borrow-tool').attr("href"), 
      type: 'GET', 
      dataType: 'json',
      success: function(data, textStatus, xhr) { 
        list.remove();
        console.log("Tool borrowed!"); 
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem borrowing this tool!")
      }
    });
    return false
  });

}); 