$(function() {
    $('#add-tool-area').hide();

  $(".add-tool-link").click(function(e){
    $('#add-tool-link').hide();
    $('#add-tool-area').show();
    e.preventDefault();
  });

  $(".tool-action").click(function(e){
    $("#add-tool-area").hide();
  });
});


$(document).ready(function() {
  $(".tool-action").click(function() {

    var tools = $(".tools");

    $.ajax({
      url: $(this).parents('#tool-form').attr("action"),
      type: 'POST',
      dataType: 'json',
      data: {tool: {name: $("#tool_name").val() }},
      success: function(data, textStatus, xhr) {
        var delete_button = '<a class="delete" data-method="delete" href="/tools/'+ data.list_id +'/tools/' + data.id + '" rel="nofollow">delete tool</a>'
        tools.append("<tr><td>"+ data.name + "</td><td>" + delete_button + "</td></tr>");
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem adding this tool");
      }
    });
    return false;
  });
});
