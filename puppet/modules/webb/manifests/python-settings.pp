class webb::python-settings(
	$user   			= $webb::params::user,
  	$user_group     	= $webb::params::user_group,
  	$system_paths		= $webb::params::system_paths,
  	$virtenvwrap_workon = $webb::params::virtenvwrap_workon,
  	$project_name	    = $webb::params::project_name,
) inherits webb::params {

	# Install python and pip
	class { "python":
	  version   => "system",
	  dev       => true,
	  pip 		=> true,
	  require	=> Exec["apt-update"],
	}

	# Install virtualenvwrapper
	exec { "install-virtualenvwrapper":
		path 		=> $system_paths,
		command 	=> "pip install virtualenvwrapper",
		unless 		=> "pip freeze | grep 'virtualenvwrapper'",
		require 	=> [ Class["python"], Package["python-pip"] ],
		logoutput 	=> on_failure,
	}	

	# Set virtualenvwrapper global variable
	file { "/etc/environment":
        content => inline_template("WORKON_HOME='${virtenvwrap_workon}'"),
        require => [ Exec["install-virtualenvwrapper"] ],
    }
	
	# Set ensure that current directory is available
	file { "/home/vagrant/envs":
		ensure 		=> directory,
		owner		=> $user,
		group		=> $user_group,
		require 	=> [ Exec["install-virtualenvwrapper"] ],
	}

	# add source path to bashrc
	file { "/etc/bash.bashrc":
        content => inline_template("source /usr/local/bin/virtualenvwrapper.sh"),
        require => [ Exec["install-virtualenvwrapper"] ],
    }

}