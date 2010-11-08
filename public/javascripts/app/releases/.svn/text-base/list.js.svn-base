// comma separated functions to add to jquery namespace to prevent conflicts

// $.extend({ 
// 	addFormControls: function(){ 
// 
// 	}
// });


// dom available after page load
$(document).ready(function() {
	
	// select actions
	
	$('#action_select_all').click(function() {
		$('input[name=action_id[]]').attr('checked', true);
	});
	
	$('#action_select_none').click(function() {
		$('input[name=action_id[]]').attr('checked', false);
	});
	
	$('#action_select_released').click(function() {
		$('input[name=action_id[]]').each(function(i) {
			if($(this).hasClass('released')){
				$(this).attr('checked', true);
			}else{
				$(this).attr('checked', false);
			}
		});
	});
	
	$('#action_select_unreleased').click(function() {
		$('input[name=action_id[]]').each(function(i) {
			if($(this).hasClass('unreleased')){
				$(this).attr('checked', true);
			}else{
				$(this).attr('checked', false);
			}
		});
	});
	
	$('#action_archive').click(function() {
		var n = $("input:checked").length;
		if(n > 0){
			if(confirm('Archive '+n+' items?')){
				$('input[name=action_type]').val('archive');
				$('#release_list_form').submit();
			}
		}else{
			alert('No selection')
		}
	});
	
	$('#action_unarchive').click(function() {
		var n = $("input:checked").length;
		if(n > 0){
			if(confirm('Activate '+n+' items?')){
				$('input[name=action_type]').val('unarchive');
				$('#archive_list_form').submit();
			}
		}else{
			alert('No selection')
		}
	});
	
	$('#action_delete').click(function() {
		var n = $("input:checked").length;
		if(n > 0){
			if(confirm('Delete '+n+' items? This cannot be undone!')){
				$('input[name=action_type]').val('delete');
				$('#release_list_form').submit();
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
	
	$('td.releases-edit').click(function() {
		
		var id = $(this).parent().attr('id');
		var baseURL = document.domain;
		var basePort = document.location.port;
		baseURL += ':' + basePort;
		document.location = 'http://'+baseURL+'/releases/'+id;
	});
	
	$('td.archives-edit').click(function() {
		
		var id = $(this).parent().attr('id');
		var baseURL = document.domain;
		var basePort = document.location.port;
		baseURL += ':' + basePort;
		document.location = 'http://'+baseURL+'/archives/'+id;
	});
});
