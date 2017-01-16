$(function(){

	var thisUser = null;

	/* render the locks on the screen */
	function render(users) {
		//locks = _.sortBy(locks, ['lockID']);

		var template = $("#user-template").html();
		var compiledTemplate = _.template(template);
		$('#users').html(compiledTemplate({users: users, selfId: thisUser.id}));

		// connect button events
		$('.give-admin').click(function() {
			giveAdmin($(this).data("id"));
		});
		$('.take-admin').click(function() {
			takeAdmin($(this).data("id"));
		});
		$('.delete-user').click(function() {
			deleteUser($(this).data("id"));
		});
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

	function deleteUser(userID) {
		console.log("Gonna delete: " + userID);

		// TODO: need api endpoint.
	}

	function giveAdmin(userID) {
		console.log("Want to give " + userID + " admin");
		$.ajax({
			method: 'PUT',
			url: '/api/v1/user/' + userID,
			data: JSON.stringify({roles: {add: ['admin']}}),
			headers: { 'Content-Type': 'application/json' },
			success: function(data) {
				// All good
				getUsers();
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	function takeAdmin(userID) {
		console.log("Want to take " + userID + " admin");
		$.ajax({
			method: 'PUT',
			url: '/api/v1/user/' + userID,
			data: JSON.stringify({roles: {del: ['admin']}}),
			headers: { 'Content-Type': 'application/json' },
			success: function(data) {
				// All good
				getUsers();
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
