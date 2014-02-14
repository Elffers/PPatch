$(document).ready(function() {
  
// removing an item
$(".list").on("click", ".remove-item", function(event) {
    
    var item = $(this).parents('li'); 
    $.ajax({
      url: $(this).attr("href"), 
      type: 'DELETE', 
      dataType: 'json',
      success: function(data, textStatus, xhr) { 
        item.remove();
        console.log(data); 
        console.log("Item removed!");
        console.log(item); 
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem removing the item!")
      }
    });
    return false
  });

}); 