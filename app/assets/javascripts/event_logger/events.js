function on_ready() {
	$("a.toggle-event-messages").click(function() {
		event_id = $(this).attr("data-event-id");
		$("#event-messages-for-" + event_id).toggle();
	});
}

$(document).ready(on_ready);
$(document).on('page:load', on_ready);