class webb::git-settings(
	$git_username		= $webb::params::git_username,
	$git_email			= $webb::params::git_email,
	$user   			= $webb::params::user,
  	$user_group     	= $webb::params::user_group,
  	$system_paths		= $webb::params::system_paths,
  	$project_name	    = $webb::params::project_name,
  	$project_base_path	= $webb::params::project_base_path,
) inherits webb::params {

	# Install git
	package { "git":
		ensure  	=> "present",
		require  	=> Exec["apt-update"],
	}

	# Configure Git
	exec { "git-author-name":
		path 		=> $system_paths,
	    command 	=> "git config --global user.name '${git_username}'",
	    unless 		=> "git config --global --get user.name|grep '${git_username}'",
	    require		=> [ Package["git"] ],
	    logoutput	=> true,
	}

	exec { "git-author-email":
		path 		=> $system_paths,
	    command 	=> "git config --global user.email '${git_email}'",
	    unless 		=> "git config --global --get user.email|grep '${git_email}'",
		require		=> [ Package["git"] ],
		logoutput	=> true,
	}

}