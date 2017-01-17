$(function(){

	var thisUser = null;

	function signOut() {
		Cookies.remove('sid', { domain: window.location.hostname, path: '/'} );
		window.location.href = 'login.html';
	}

	function checkSession() {
		$.ajax({
			method: 'GET',
			url: '/api/v1/session',
			success: function(data) {
				// All good
				thisUser = data;
				$('.nav-signedin').show();
				console.log("Is logged in");
				$('#nav-signedin-message').html('Signed in as <b>' + data.name + '</b> ');
				if ($.inArray('admin', data.roles) > -1) {
					$('.needsAdmin').show();
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				$('.nav-signedout').show();
			}
		});
	}

	$('.nav-signedin').hide();
	$('.nav-signedout').hide();
	$('#sign-out').click(function() {
		signOut();
	});
	$('#sign-in').click(function() {
		window.location.href = 'login.html';
	});

	checkSession();

});
//	vim: set sw=4 ts=4 :
