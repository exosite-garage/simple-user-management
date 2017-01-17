$(function(){
	var resetToken = null;

	function changePassword() {
		$.ajax({
			method: 'POST',
			url: '/api/v1/resetPassword',
			data: JSON.stringify({
				resetToken: resetToken,
				password: $('#password').val()
			}),
			headers: { 'Content-Type': 'application/json' },
			success: function(data) {
				//window.location.href = "login.html";
				alert('Changed');
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	$('#changePassword').click(function(){
		changePassword();
	});

	// http://stackoverflow.com/a/901144/3715500
	function getParameterByName(name, url) {
		if (!url) {
			url = window.location.href;
		}
		name = name.replace(/[\[\]]/g, "\\$&");
		var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
			results = regex.exec(url);
		if (!results) return null;
		if (!results[2]) return '';
		return decodeURIComponent(results[2].replace(/\+/g, " "));
	}

	resetToken = getParameterByName('rt');

});
//	vim: set sw=4 ts=4 :
