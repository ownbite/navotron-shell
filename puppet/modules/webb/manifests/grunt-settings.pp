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

    # Unpack npm
    exec { "install-npm":
        path        => $system_paths,
        command     => "tar --strip-components 1 -xzf /tmp/node-v0.10.28-linux-x86.tar.gz",
        cwd         => "/usr/local",
        logoutput   => on_failure,
        creates     => [ "/usr/local/bin/npm" ],
        require     => File["/tmp/node-v0.10.28-linux-x86.tar.gz"],
    }

    # Install bower
    exec { "install-bower":
        path        => $system_paths,
        command     => "npm install -g bower",
        # cwd         => "/usr/local",
        logoutput   => on_failure,
        creates     => [ "/usr/local/bin/bower" ],
        require     => Exec["install-npm"],
    }

    # Install http-server
    exec { "install-http-server":
        path        => $system_paths,
        command     => "sudo npm install -g http-server",
        # cwd         => "/usr/local",
        logoutput   => on_failure,
        creates     => [ "/usr/local/bin/http-server" ],
        require     => Exec["install-npm"],
    }

    
    



}