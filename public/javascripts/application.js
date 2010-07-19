$(document).ready(function() {
	toggleButtons();
	selectAll();
	$("table#tracks_container").tablesorter(); 
});

function toggleButtons() {
	if ($("#tracks_container :input").is(":checked")) {
		$("#group_edit_button").removeAttr('disabled');
		$("#group_delete_button").removeAttr('disabled');
	} else {
		$("#group_edit_button").attr('disabled', true);
		$("#group_delete_button").attr('disabled', true);
	}
}

function selectAll() {
  var tog = false; // or true if they are checked on load 
   $('#tracks_container th :input').click(function() { 
      $("input[type=checkbox]").attr("checked",!tog); 
    tog = !tog; 
   });
}
