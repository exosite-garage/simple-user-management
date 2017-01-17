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
				console.log("Is logged in");
				$('#nav-signedin-message').html('Signed in as <b>' + data.name + '</b> ');
				if ($.inArray('admin', data.roles) > -1) {
					$('.needsAdmin').show();
				}

				getProfileDetails(data.email);
			},
			error: function(xhr, textStatus, errorThrown) {
				// Nope. Goto login.

				console.log("Session check failed.");

				window.location.href = "login.html";
			}
		});
	}

	function getProfileDetails(who) {
		$.ajax({
			method: 'GET',
			url: '/api/v1/user/' + who + '/profile',
			success: function(data) {
				console.log(data);
				var gavHash = md5( data.email.trim() );
				var imgUrl = 'https://www.gravatar.com/avatar/' + gavHash + '?d=mm&s=200';
				$('img.avatar').attr('src', imgUrl);
				$('img.avatar').attr('alt', "Avatar for " + data.name);

				$('#nav-signedin-message').html('Signed in as <b>' + data.name + '</b> ');
				$('.profile-details .real-name').text(data.name);
				$('.profile-details input[name="name"]').val(data.name);
				$('title').text("Profile for " + data.name);
				$('.profile-details .location').text(data.location);
				$('.profile-details input[name="location"]').val(data.location);
				$('.profile-details .bio').text(data.bio);
				$('.profile-details input[name="bio"]').val(data.bio);

				$('.profile-details').show();
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}
	function editProfile() {
		// Edit button pressed.
		// Flip name, location, bio into edit boxes.
		$('.profile-details .viewonly').hide();
		$('.profile-details .editonly').show();
	}
	function saveProfile() {
		// Save button pressed.

		// Flip back to not edit boxes.
		$('.profile-details .editonly').hide();
		$('.profile-details .viewonly').show();

		// Save values (put)
		console.log('Saving profile…');
		$.ajax({
			method: 'PUT',
			url: '/api/v1/user/' + thisUser.email + '/profile',
			data: JSON.stringify({
				name: $('.profile-details input[name="name"]').val(),
				location: $('.profile-details input[name="location"]').val(),
				bio: $('.profile-details input[name="bio"]').val(),
			}),
			headers: {
				'Content-Type': 'application/json'
			},
			success: function(data) {
				console.log("saved.");
				getProfileDetails(thisUser.email);
			},
			error: function(xhr, textStatus, errorThrown) {
				alert(errorThrown);
			}
		});
	}

	function deleteSelf() {
		if (confirm("Really delete your account?")) {
			$.ajax({
				method: 'DELETE',
				url: '/api/v1/user/' + thisUser.id,
				success: function(data) {
					console.log("deleted");

					window.location.href = 'login.html';
				},
				error: function(xhr, textStatus, errorThrown) {
					alert(errorThrown);
				}
			});
		}
	}

	// set initial state of signin controls
	//$('.profile-details').hide();
	$('.profile-details .editonly').hide();

	$('.profile-details a.profile-edit').click(function() {
		editProfile();
	});
	$('.profile-details a.profile-save').click(function() {
		saveProfile();
	});
	$('.profile-details a.profile-delete').click(function() {
		deleteSelf();
	});

	$('#sign-out').click(function() {
		signOut();
	});

	checkSession();

});
//	vim: set sw=4 ts=4 :
