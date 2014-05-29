class webb::params {

	# Git parameters
	$git_username			= "ownbite"
	$git_email			   	= "linuswallin87@gmail.com"

	# Paths
	$vagrant_base_path     	= "/vagrant/"
	$project_base_path     	= "/vagrant/sbt/"
	$system_paths		   	= ["/usr/bin/","/usr/sbin/","/bin","/usr/local/bin/"]

	# User
	$user 			       	= "vagrant"
	$user_group			   	= "vagrant"

	# Custom variables
	$virtenvwrap_workon	    = "~/envs"
	$project_name		    = "sbt"
	$npm_branch			    = "0.10.5"
	$npm_base_path			= "/tmp/npm-git-clone"

}