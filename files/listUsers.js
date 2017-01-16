$(function(){

	var thisUser = null;

	/* render the locks on the screen */
	function render(users) {
		//locks = _.sortBy(locks, ['lockID']);

		var template = $("#user-template").html();
		var compiledTemplate = _.template(template);
		$('#users').html(compiledTemplate({users: users, selfId: thisUser.id}));

		// connect button events
		/*$('.button-lock').click(function() {
			lockCommand($(this).data("id"), 'locked');
		});
		$('.button-unlock').click(function() {
			lockCommand($(this).data("id"), 'unlocked');
		});*/
	}

	function signOut() {
		// FIXME: This isn't deleteing.
		Cookies.remove('sid', { Domain: window.location.hostname} );
		window.location.href = 'login.html';
	}

	function checkSession() {
		$.ajax({
			method: 'GET',
			url: '/api/v1/session',
			success: function(data) {
				// All good
				thisUser = data;
				console.log("Is logged in");
				$('#nav-signedin-message').html('Signed in as <b>' + data.name + '</b> ');

				getUsers();
			},
			error: function(xhr, textStatus, errorThrown) {
				// Nope. Goto login.

				console.log("Session check failed.");

				window.location.href = "login.html";
			}
		});
	}

	function getUsers() {
		$.ajax({
			method: 'GET',
			url: '/api/v1/users',
			success: function(data) {
				// All good
				render(data);
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	// set initial state of signin controls

	$('#sign-out').click(function() {
		signOut();
	});

	checkSession();

});
//	vim: set sw=4 ts=4 :
