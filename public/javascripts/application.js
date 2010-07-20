$(document).ready(function() {
	toggleButtons();
	selectAll();
	$("table#tracks_container").tablesorter({ headers: { 0: {sorter: false }, 6: { sorter: false } } });
});

function toggleButtons() {
	if ($("#tracks_container :input").is(":checked"))  {
		$("#group_edit_button").removeAttr('disabled');
		$("#group_delete_button").removeAttr('disabled');
	} else {
		$("#group_edit_button").attr('disabled', true);
		$("#group_delete_button").attr('disabled', true);
	}
}

function selectAll() {
  var tog = false; // or true if they are checked on load
  var able = true;
   $('#tracks_container th :input').click(function() { 
      $("input[type=checkbox]").attr("checked",!tog);
      $("#group_edit_button").attr("disabled",!able);
      $("#group_delete_button").attr("disabled",!able);
    tog = !tog;
    able = !able; 
   });
}
