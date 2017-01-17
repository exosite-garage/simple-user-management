$(function(){

	function signUp() {
		console.log('signing up...');
		$.ajax({
			method: 'POST',
			url: '/api/v1/user-signup',
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

	function forgotPassword() {
		$.ajax({
			method: 'POST',
			url: '/api/v1/forgotten',
			data: JSON.stringify({email: $('#email').val()}),
			headers: { 'Content-Type': 'application/json' },
			success: function(data) {
				alert("You should soon receive an email with a reset link.");
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	$('#sign-up').click(function(){
		signUp();
	});
	$('#forgot').click(function(){
		forgotPassword();
	});

});
//	vim: set sw=4 ts=4 :
