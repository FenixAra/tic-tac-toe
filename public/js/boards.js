$(".square").click(function() {
  $.get("/boards/square/"+$(this).attr("id"), function() {location.reload();});
});
