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
        var delete_button = '<a class="delete" data-method="delete" href="/tools/'+ data.list_id +'/tools/' + data.id + '" rel="nofollow">delete</a>'
        tools.append("<tr id='tr-1'><td>"
                            + data.name
                            + "</td><td>borrowbutton</td>"
                            + "<td>returnbutton</td></tr>"
                            + "<tr id='tr-2'><td>descript</td><td>"
                            + delete_button
                            + "</td><td>updatebutton</td></tr>");
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem adding this tool");
      }
    });
    return false;
  });
});


$(document).ready(function() {
  $(".tools").on( "click", ".delete", function() {
    var tool1 = $('#tr-1');
    var tool2 = $('#tr-2');

    $.ajax({
      url: $(this).attr("href"),
      type: 'DELETE',
      dataType: 'json',
    })
    .done(function(){
      tool1.remove();
      tool2.remove();
    })
  .fail(function(){
    alert("you are a terrible person and i'm not deleting that");
  });
    return false;
  });
});
