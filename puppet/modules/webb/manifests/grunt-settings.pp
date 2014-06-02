class webb::grunt-settings(
    $user               = $webb::params::user,
    $user_group         = $webb::params::user_group,
    $system_paths       = $webb::params::system_paths,
    $project_name       = $webb::params::project_name,
    $npm_branch         = $webb::params::npm_branch,
    $npm_base_path      = $webb::params::npm_base_path,
) inherits webb::params {


    package { ["build-essential", "g++"]:
        ensure  => present,
        require => Exec["apt-update"],
    }

    # Move Python package
    file { "/tmp/node-v0.10.28-linux-x86.tar.gz":
        source => "puppet:///modules/webb/node-v0.10.28-linux-x86.tar.gz",
    }

    # Unpack Python 3.4
    exec { "unpack-npm":
        path        => $system_paths,
        command     => "tar -xzf node-v0.10.28-linux-x86.tar.gz",
        cwd         => "/tmp/",
        logoutput   => on_failure,
        require     => File["/tmp/node-v0.10.28-linux-x86.tar.gz"],
    }


}