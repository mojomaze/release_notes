// comma separated functions to add to jquery namespace to prevent conflicts

// $.extend({ 
// 	addFormControls: function(){ 
// 
// 	}
// });


// dom available after page load
$(document).ready(function() {
	
	$('#action_delete').click(function() {
		var n = $("input:checked").length;
		if(n > 0){
			if(confirm('Delete '+n+' items? This cannot be undone!')){
				$('input[name=action_type]').val('delete');
				$('#user_list_form').submit();
			}
		}else{
			alert('No selection')
		}
	});
	
	$('tr.list-record').hover(
		function() {
			$(this).addClass('over');
		},
		function() {
			$(this).removeClass('over');
		}
	);
	
	$('td.users-edit').click(function() {
		
		var id = $(this).parent().attr('id');
		var baseURL = document.domain;
		var basePort = document.location.port;
		baseURL += ':' + basePort;
		document.location = 'http://'+baseURL+'/users/'+id+'/edit';
	});
	
});
