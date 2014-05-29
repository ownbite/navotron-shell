
class webb::nginx-settings(
	$base_path           = $webb::params::base_path,
	$owner 			     = $webb::params::owner,
	$vagrant_base_path   = $webb::params::vagrant_base_path,

) inherits webb::params {
	
	file { [ "/etc/nginx/conf.d/default.conf" ]:
		source => "puppet:///modules/webb/default.conf",
		notify => Service['nginx']
	}

	service { "nginx":
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
	}

}