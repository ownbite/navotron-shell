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

    vcsrepo { $npm_base_path:
        ensure   => present,
        provider => git,
        source   => "https://github.com/joyent/node.git",
        revision => 'deeaf8fab978e3cadb364e46fb32dafdebe5f095'
    }

    exec { "checkout-npm-${npm_branch}":
        path        => $system_paths,
        cwd         => $npm_base_path,
        command     => "git checkout ${npm_branch}",
        unless      => "git branch -v | grep '${npm_branch}'",
        require     => [ Vcsrepo[$npm_base_path] ],
        logoutput   => on_failure,
    }

    exec { "configure-grunt":
        path        => $system_paths,
        command     => "/usr/bin/python2.7 ${npm_base_path}/configure",
        cwd         => $npm_base_path,
        creates     => "${npm_base_path}/config.gypi",
        before      => Exec["install-grunt"],
        require     => [ Exec["checkout-npm-${npm_branch}"], Package[["build-essential", "g++"]] ],
        logoutput   => on_failure,
    }

    exec { "make-grunt":
        path        => $system_paths,
        command     => "make && make install",
        cwd         => $npm_base_path,
        timeout     => 600,
        creates     => [ "/usr/local/bin/npm" ],
        require     => Exec["configure-grunt"],
        logoutput   => on_failure,
    }

    exec { "install-grunt":
        path        => $system_paths,
        command     => "npm install -g grunt-cli",
        timeout     => 600,
        creates     => [ "/usr/local/bin/grunt" ],
        require     => Exec["install-grunt"],
        logoutput   => on_failure,
    }

}