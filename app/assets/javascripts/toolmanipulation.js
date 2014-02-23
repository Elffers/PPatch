// show new tool area
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

// post new tool
$(document).ready(function() {
  $(".tool-action").click(function() {

    var tools = $(".tools");

    $.ajax({
      url: $(this).parents('#tool-form').attr("action"),
      type: 'POST',
      dataType: 'json',
      data: {tool: {name: $("#tool_name").val(), description: $("#tool_description").val() }},
      success: function(data, textStatus, xhr) {
        var delete_button = '<a class="delete" data-method="delete" href="/tools/'+  data.id + '" rel="nofollow">delete</a>'
        var borrow_button = '<a class="borrow-tool" data-method="get" href="/tools/' + data.id + '/borrow" rel="nofollow">borrow</a>'
        tools.append("<tr class='tr-1'><td>"
                            + data.name
                            + "</td><td>"
                            + borrow_button
                            + "</td><td></td><td>"
                            + "</td></tr><tr class='tr-2'><td>"
                            + data.description
                            + "</td><td>"
                            + delete_button
                            + "</td><td>this will become an ajax update button</td></tr>");
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("There was a problem adding this tool");
      }
    });
    return false;
  });
});

// delete tool
$(document).ready(function() {
  $(".tools").on( "click", ".delete", function() {
    var tool2 = $(this).parents(".tr-2");
    var tool1 = $(this).parents(".tr-2").prev("tr.tr-1");

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
    alert("nope");
  });
    return false;
  });
});

