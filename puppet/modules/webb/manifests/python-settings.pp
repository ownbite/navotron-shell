class webb::python-settings(
	$user   			= $webb::params::user,
  	$user_group     	= $webb::params::user_group,
  	$system_paths		= $webb::params::system_paths,
  	$virtenvwrap_workon = $webb::params::virtenvwrap_workon,
  	$project_name	    = $webb::params::project_name,
) inherits webb::params {

	# Move Python package
	file { "${python_base_path}.tgz":
		source 		=> "puppet:///modules/webb/Python-3.4.1.tgz",
	}

	# Unpack Python 3.4
	exec { "unpack-python3.4":
		path 		=> $system_paths,
		command 	=> "tar -xzf ${python_base_path}.tgz",
		cwd 		=> "/tmp/",
		unless 		=> "ls ${python_base_path}",
		logoutput 	=> on_failure,
		require 	=> File["${python_base_path}.tgz"],
	}

	# configure
	exec { "./configure":
        path        => $system_paths,
        command     => "${python_base_path}/configure",
        cwd         => $python_base_path,
        creates     => "${python_base_path}/pyconfig.h",
        require     => Exec["unpack-python3.4"],
        logoutput   => on_failure,
    }

    # make & make install
    exec { "make && make install":
        path        => $system_paths,
        cwd         => $python_base_path,
        alias       => "make-install-python",
        timeout     => 600,
        creates     => [ "/usr/local/bin/python3.4" ],
        require     => Exec["./configure"],
        logoutput   => on_failure,
    }


	file { '/usr/bin/python':
	   ensure => 'link',
	   target => '/usr/local/bin/python3.4',
	   require => Exec["make && make install"],
	}

	file {"/home/${user}/.bashrc":
        ensure  => file,
        content => "alias sudo='sudo '",
        owner   => $user,
        require => Exec["make && make install"],
    }	

	
	# Install virtualenvwrapper
	exec { "install-virtualenvwrapper":
		path 		=> $system_paths,
		command 	=> "pip3.4 install virtualenvwrapper",
		unless 		=> "pip3.4 freeze | grep 'virtualenvwrapper'",
		require 	=> [ Exec["make && make install"] ],
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