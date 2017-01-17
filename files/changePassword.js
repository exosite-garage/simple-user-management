$(function(){

	var thisUser = null;

	function checkSession() {
		$.ajax({
			method: 'GET',
			url: '/api/v1/session',
			success: function(data) {
				// All good
				thisUser = data;
				console.log("Is logged in");
				$('#nav-signedin-message').html('Signed in as <b>' + data.name + '</b> ');
				if ($.inArray('admin', data.roles) > -1) {
					$('.needsAdmin').show();
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				// Nope. Goto login.
				console.log("Session check failed.");

				window.location.href = "login.html";
			}
		});
	}

	function changePassword() {
		console.log('Changing passworrd');
		$.ajax({
			method: 'POST',
			url: '/api/v1/session/changepassword',
			data: JSON.stringify({
				oldpassword: $('#old-password').val(),
				password: $('#password').val()
			}),
			headers: {
				'Content-Type': 'application/json'
			},
			success: function(data) {
				window.location.href = "profile.html";
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	$('#changePassword').click(function(){
		changePassword();
	});

	checkSession();
});
//	vim: set sw=4 ts=4 :
