
class webb(
	
) inherits webb::params {

	# Include python
	class { "webb::python-settings": }

	# Include git
	class { "webb::git-settings": }

	# Include grunt
	class { "webb::grunt-settings": }

	# Include nginx
	class { "webb::nginx-settings": }

	# Set requirments
	Class["webb::python-settings"] -> Class["webb::git-settings"] -> Class["webb::grunt-settings"] -> Class["webb::nginx-settings"]

}


