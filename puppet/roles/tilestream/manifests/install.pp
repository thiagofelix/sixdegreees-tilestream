class tilestream::install {
  notify { 'Installing Tilestream': }

  package { 'git':
    ensure => 'present'
  }

  class { 'nodejs':
	  version => 'v0.8.26',
	}

	include nginx

	file { 'tilestream.conf':
		path => '/etc/nginx/conf.d/default.conf',
		source => 'puppet:///modules/tilestream/tilestream.conf',
		replace => true,
	}

	file { '/var/www':
		ensure => 'directory',
	}->
	file { 'tilestream-home':
		path => '/var/www/tilestream',
		ensure => 'directory',
		require => File['/var/www'],
	}->
	file { 'tilestream-home-tiles':
		path => '/var/www/tilestream/tiles',
		ensure => 'directory',
		require => File['tilestream-home'],
	}->
	file { 'tilestream-package.json':
		path => '/var/www/tilestream/package.json',
		source => 'puppet:///modules/tilestream/package.json',
		require => File['tilestream-home'],
	}



	file { 'tilestream-upstart':
		path => '/etc/init/tilestream.conf',
		content => template('tilestream/upstart.erb'),
	} ->
	exec { "installing-tilestream-dependencies":
		command => "npm install",
		cwd => '/var/www/tilestream',
		path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"
	} ~>
	service { "tilestream":
	  enable => true,
		ensure => running,
		provider => 'upstart',
		require => File['tilestream-upstart'],
	}
}
