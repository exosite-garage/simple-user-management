$(function(){
	var muranoToken = null;

	/* sign in by posting to /token to get a token and setting
	 it in muranoToken */
	function signIn() {
		console.log('signing in...');
		$.ajax({
			method: 'POST',
			url: '/api/v1/session',
			data: JSON.stringify({email: $('#email').val(), password: $('#password').val()}),
			headers: {
				'Content-Type': 'application/json'
			},
			success: function(data) {
				muranoToken = data.token;
				Cookies.set('sid', data.token, { expires: 1 } );

				window.location.href = "profile.html";

			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}
	function signUp() {
		console.log('signing up...');
		$.ajax({
			method: 'POST',
			url: '/api/v1/user',
			data: JSON.stringify({email: $('#email').val(), password: $('#password').val()}),
			headers: {
				'Content-Type': 'application/json'
			},
			success: function(data) {
				alert("You should soon receive an email with a validation token.");
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	/* sign out by setting muranoToken to null */
	function signOut() {
		muranoToken = null;
		$('#email').val('');
		$('#password').val('');
		$('.nav-signedout').show();
		$('.nav-signedin').hide();
	}


	// set initial state of signin controls
	$('#sign-out').click(function() {
		signOut();
	});
	$('#sign-up').click(function(){
		signUp();
	});

	// TODO: check to see if logged in: if yes, goto profile.html
});
//	vim: set sw=4 ts=4 :
