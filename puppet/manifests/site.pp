
node default {
	
	# Exceute the apt-update command
	exec { "apt-update":
		command => "/usr/bin/apt-get update",
	}

	# Install the default packages
	package { ["sudo", "wget", "htop", "screen", "vim-common", "vim", "unzip"]:
		ensure  	=> "present",
		require  	=> Exec["apt-update"],
	}

	# Make sure that the main user vagrant is present and belongs to the group www-data
	user { "vagrant":
		ensure => "present",
		groups => ["www-data"]
	}

}

node "sbt.se" inherits default {
	class { "webb": }

	Package[["sudo", "wget", "htop", "screen", "vim-common", "vim", "unzip"]] -> User["vagrant"] -> Class["webb"]
}






               
