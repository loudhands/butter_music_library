$(document).ready(function() {
	toggleButtons();
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
